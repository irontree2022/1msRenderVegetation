using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class GenSimpleDepthMapFeature : ScriptableRendererFeature
{
    class GenSimpleDepthMapPass : ScriptableRenderPass
    {
        private RenderTargetHandle depthHandle;
        private Material depthMaterial;
        RenderTextureFormat colorFormat = RenderTextureFormat.RFloat;

        public GenSimpleDepthMapPass()
        {
            depthHandle.Init("_CustomSimpleDepthRT");
        }
        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
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

        private Simple__FrustumCulling_OcclusionCulling simple;
        public override void Execute(ScriptableRenderContext context, ref RenderingData data)
        {
            if (!Application.isPlaying) return;
            if (data.cameraData.camera != Camera.main) return;
            if (simple == null)
                simple = GameObject.FindObjectOfType<Simple__FrustumCulling_OcclusionCulling>();
            if (simple == null) return;


            if (depthMaterial == null)
                depthMaterial = new Material(simple.depthConversionShader);

            // ����Ϊ"GenSimpleDepthMap"��CommandBuffer��
            // ���������Frame Debugger�з������ǲ鿴��
            CommandBuffer cmd = CommandBufferPool.Get("GenSimpleDepthMap");
            // ���������ͼ
            // ���Ĳ�������������ͼ��������ʱRT
            cmd.Blit(
                BuiltinRenderTextureType.Depth, // Դ�������Ȼ���
                depthHandle.Identifier(),       // Ŀ�꣺��ʱRT
                depthMaterial                   // ���ת������
            );

            // ���ͼ���ɺ�ת��cmd�Լ����ͼrt
            simple.AfterDepthMapGenerated(cmd, depthHandle.Identifier());

            // ����ﵽ��Ⱦβ����
            // ָʾ��Ⱦ���߰�ָ��˳������ȥִ��
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        public override void FrameCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(depthHandle.id);
        }

    }


    private GenSimpleDepthMapPass depthPass;
    public RenderPassEvent renderPassEvent = RenderPassEvent.BeforeRenderingOpaques;
    public override void Create()
    {
        depthPass = new GenSimpleDepthMapPass();
        depthPass.renderPassEvent = renderPassEvent;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData data)
    {
        renderer.EnqueuePass(depthPass);
    }

}