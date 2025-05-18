using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class DrawInstancesShadowFeature : ScriptableRendererFeature
{
    class DrawInstancesShadowPass : ScriptableRenderPass
    {
        private OcclusionCulling_Hi_z hi_Z;
        private bool Enable => GenDepthMapController.Instance != null && GenDepthMapController.Instance.IsInitialized;

        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            // ≈‰÷√“ı”∞‰÷»æƒø±Í
            ConfigureTarget(new RenderTargetIdentifier(Shader.PropertyToID("_MainLightShadowmapTexture")));
            ConfigureClear(ClearFlag.All, Color.black);
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData data)
        {
            if (!Enable) return;
            if (hi_Z == null)
                hi_Z = GameObject.FindAnyObjectByType<OcclusionCulling_Hi_z>();
            if (hi_Z == null || hi_Z.UseCPU)
                return;

            CommandBuffer cmd = CommandBufferPool.Get("DrawInstancesShadow");

            GenDepthMapController.Instance.Trigger_DrawInstancesShadowEvent(cmd);

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
    }

    public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingShadows;
    DrawInstancesShadowPass drawInstancesShadowPass;
    public override void Create()
    {
        drawInstancesShadowPass = new DrawInstancesShadowPass();
        drawInstancesShadowPass.renderPassEvent = renderPassEvent;
    }
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (GenDepthMapController.Instance == null)
            return;
        renderer.EnqueuePass(drawInstancesShadowPass);
    }
}


