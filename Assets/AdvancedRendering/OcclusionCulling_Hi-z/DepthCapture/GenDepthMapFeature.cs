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
        public GenDepthMapPass()
        {
            depthHandle.Init("_CustomDepthRT");
        }
        private bool Enable => GenDepthMapController.Instance != null && GenDepthMapController.Instance.IsInitialized;
        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            if (!Enable) return;

            var colorFormat = RenderTextureFormat.RFloat; // �洢���ֵ
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
            cmd.CopyTexture(depthHandle.Identifier(), targetRT);
            GenDepthMapController.Instance.Trigger_AfterDepthMapGeneratedEvent(cmd, depthHandle.Identifier());
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
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