using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class GenDepthMapFeature : ScriptableRendererFeature
{
    class GenDepthMapPass : ScriptableRenderPass
    {
        private RenderTargetHandle depthHandle;
        private Material depthMaterial;
        private RenderTexture targetRT;
        RenderTextureFormat colorFormat = RenderTextureFormat.RFloat;
        Material genDepthMipmapaterial;
        public GenDepthMapPass()
        {
            depthHandle.Init("_CustomDepthRT");
        }
        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            if (!Enable) return;

            // ƥ��Ŀ��RT������(Ҳ����RT�Ĵ�������)
            RenderTextureDescriptor desc = cameraTextureDescriptor;
            desc.colorFormat = colorFormat;
            desc.useMipMap = false;
            // �ӳ�������һ������RT������ʵ�������û�оʹ������µ�
            // ��Ϊ�л���صĴ��ڣ���������Ƶ���������٣�����ûʲô��������
            // ����������ڵͶ�GPU�豸�ϣ�����ؾͺܿ��ܻ���Ϊ���������Ƶ�����������ˣ�
            // ��������Լ�����ÿ��RenderTargetHandle���ֶ�����������������
            cmd.GetTemporaryRT(depthHandle.id, desc, FilterMode.Point);
            // ����ͨ������ȾĿ���������Զ���RT
            ConfigureTarget(depthHandle.Identifier());
        }

        private bool Enable => GenDepthMapController.Instance != null && GenDepthMapController.Instance.IsInitialized;
        private OcclusionCulling_Hi_z hi_Z;
        public override void Execute(ScriptableRenderContext context, ref RenderingData data)
        {
            if (!Enable) return;
            if (data.cameraData.camera != GenDepthMapController.Instance.Camera) return;
            if (depthMaterial == null)
                depthMaterial = new Material(GenDepthMapController.Instance.depthShader);
            targetRT = GenDepthMapController.Instance.RT;
            if (depthMaterial == null || targetRT == null) return;
            if (hi_Z == null)
                hi_Z = GameObject.FindAnyObjectByType<OcclusionCulling_Hi_z>();
            if (hi_Z == null)
                return;
            // ����Ϊ"GenDepthMap"��CommandBuffer��
            // ���������Frame Debugger�з������ǲ鿴��
            CommandBuffer cmd = CommandBufferPool.Get("GenDepthMap");
            // ���������ͼ
            // ���Ĳ�������������ͼ��������ʱRT
            cmd.Blit(
                BuiltinRenderTextureType.Depth, // Դ�������Ȼ���
                depthHandle.Identifier(),       // Ŀ�꣺��ʱRT
                depthMaterial                   // ���ת������
            );

            // ��ʼ����Mipmap
            // ������Сmipmap�ߴ�Ϊ 1x1
            if (genDepthMipmapaterial == null)
                genDepthMipmapaterial = new Material(GenDepthMapController.Instance.genDepthMipmapShader);
            // �������ɵ����ͼ
            RenderTargetHandle tempMipmapRT = default;
            tempMipmapRT.Init("tempDepthMipmapRT");
            RenderTextureDescriptor _desc = new RenderTextureDescriptor(Screen.width, Screen.height, colorFormat, 0);
            _desc.useMipMap = true;
            _desc.autoGenerateMips = false;
            cmd.GetTemporaryRT(tempMipmapRT.id, _desc, FilterMode.Point);
            var width = Screen.width;
            var height = Screen.height;
            var _w = width;
            var _h = width;
            var mipmapLevel = 0;
            RenderTargetHandle per = default;
            while (_w > 1 && _h > 1)
            {
                // mipmapLevel == 0 ʱ��ʵ��ʹ�õ��ǿ������������ͼ
                RenderTargetHandle mipmapHandle = mipmapLevel == 0 ? depthHandle : default;

                if(mipmapLevel != 0)
                {
                    // ����һ����ʱRT���ڴ洢��ǰ��Mipmap������
                    mipmapHandle.Init($"tempMipmap_{mipmapLevel}");
                    RenderTextureDescriptor desc = new RenderTextureDescriptor(_w, _h, colorFormat, 0);
                    desc.useMipMap = false;
                    cmd.GetTemporaryRT(mipmapHandle.id, desc, FilterMode.Point);
                    // ����һ��Mipmap����shader��������ǰ��Mipmap��
                    // ��shader�ڲ���������д����ȵ���Сֵ
                    cmd.Blit(per.Identifier(), mipmapHandle.Identifier(), genDepthMipmapaterial);
                }
                // ��󽫵�ǰ��Mipmap�����������ͼ�Ķ�Ӧ�㼶��
                // һ�㲻��Ҫ�������ͼ��һ��RenderTargetHandle��һ��RenderTexture�������忴���ѡ��һ�־Ϳ��ԣ�
                // һ���ʹ�� RenderTargetHandle ���㹻�ˣ�
                // ��������Ϊʾ����ʾ��������ⴴ��������RT�����ʵ��ʹ��ʱ����Ҫ������
                cmd.CopyTexture(mipmapHandle.Identifier(), 0, 0, tempMipmapRT.Identifier(), 0, mipmapLevel);
                cmd.CopyTexture(mipmapHandle.Identifier(), 0, 0, targetRT, 0, mipmapLevel);
                if (mipmapLevel != 0)
                    cmd.ReleaseTemporaryRT(per.id); // �ͷ���ʱRT
                per = mipmapHandle;


                ++mipmapLevel;
                // Ҳ����ÿ��mipmap�ߴ綼��֮ǰ��һ��
                _w = width >> mipmapLevel; 
                _h = height >> mipmapLevel;
            }
            cmd.ReleaseTemporaryRT(per.id);// �ͷ���ʱRT
            GenDepthMapController.Instance.MipmapCount = mipmapLevel;
            GenDepthMapController.Instance.IsMipmapGenCompleted = true;


            // ���ͼ���ɺ�ת��cmd�Լ����ͼrt
            GenDepthMapController.Instance.Trigger_AfterDepthMapGeneratedEvent(cmd, tempMipmapRT.Identifier());

            // ����ﵽ��Ⱦβ����
            // ָʾ��Ⱦ���߰�ָ��˳������ȥִ��
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
            cmd.ReleaseTemporaryRT(tempMipmapRT.id);
        }

        public override void FrameCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(depthHandle.id);
        }

    }


    private GenDepthMapPass depthPass;
    public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
    public override void Create()
    {
        depthPass = new GenDepthMapPass();
        depthPass.renderPassEvent = renderPassEvent;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData data)
    {
        if (GenDepthMapController.Instance == null)
            return;
        renderer.EnqueuePass(depthPass);
    }

}