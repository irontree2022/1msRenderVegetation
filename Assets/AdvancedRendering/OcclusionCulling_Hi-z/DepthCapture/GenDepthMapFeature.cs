// DepthCaptureFeature.cs
using System.Runtime.ConstrainedExecution;
using Unity.VisualScripting;
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
        public bool done;
        RenderTextureFormat colorFormat = RenderTextureFormat.RFloat;
        Material genDepthMipmapaterial;
        public GenDepthMapPass()
        {
            depthHandle.Init("_CustomDepthRT");
        }
        private bool Enable => GenDepthMapController.Instance != null && GenDepthMapController.Instance.IsInitialized;
        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            if (!Enable) return;

            // ƥ��Ŀ��RT������
            RenderTextureDescriptor desc = cameraTextureDescriptor;
            desc.colorFormat = colorFormat;
            desc.useMipMap = false;

            cmd.GetTemporaryRT(depthHandle.id, desc, FilterMode.Point);
            ConfigureTarget(depthHandle.Identifier());
        }

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
            RenderTargetHandle tempMipmapRT = default;
            tempMipmapRT.Init("tempDepthMipmapRT");
            RenderTextureDescriptor _desc = new RenderTextureDescriptor(Screen.width, Screen.height, colorFormat, 0);
            _desc.useMipMap = true;
            _desc.autoGenerateMips = false;
            cmd.GetTemporaryRT(tempMipmapRT.id, _desc, FilterMode.Point);

            var width = targetRT.width;
            var height = targetRT.height;
            var _w = width;
            var _h = width;
            var mipmapLevel = 0;
            RenderTargetHandle per = default;
            while (_w > 1 && _h > 1)
            {
                RenderTargetHandle mipmapHandle = mipmapLevel == 0 ? depthHandle : default;

                if(mipmapLevel != 0)
                {
                    mipmapHandle.Init($"tempMipmap_{mipmapLevel}");
                    RenderTextureDescriptor desc = new RenderTextureDescriptor(_w, _h, colorFormat, 0);
                    desc.useMipMap = false;
                    cmd.GetTemporaryRT(mipmapHandle.id, desc, FilterMode.Point);
                    cmd.Blit(per.Identifier(), mipmapHandle.Identifier(), genDepthMipmapaterial);
                }
                cmd.CopyTexture(mipmapHandle.Identifier(), 0, 0, tempMipmapRT.Identifier(), 0, mipmapLevel);
                cmd.CopyTexture(mipmapHandle.Identifier(), 0, 0, targetRT, 0, mipmapLevel);
                if (mipmapLevel != 0)
                    cmd.ReleaseTemporaryRT(per.id);
                per = mipmapHandle;


                ++mipmapLevel;
                // Ҳ����ÿ��mipmap�ߴ綼��֮ǰ��һ��
                _w = width >> mipmapLevel; 
                _h = height >> mipmapLevel;
            }
            cmd.ReleaseTemporaryRT(per.id);
            GenDepthMapController.Instance.MipmapCount = mipmapLevel;
            GenDepthMapController.Instance.IsMipmapGenCompleted = true;

            GenDepthMapController.Instance.Trigger_AfterDepthMapGeneratedEvent(cmd, tempMipmapRT.Identifier());
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
    public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingPrePasses;
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