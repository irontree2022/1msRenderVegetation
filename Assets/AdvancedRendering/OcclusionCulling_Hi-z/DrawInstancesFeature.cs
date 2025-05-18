using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class DrawInstancesFeature : ScriptableRendererFeature
{
    class DrawInstancesPass : ScriptableRenderPass
    {
        private OcclusionCulling_Hi_z hi_Z;
        private bool Enable => GenDepthMapController.Instance != null && GenDepthMapController.Instance.IsInitialized;
        public override void Execute(ScriptableRenderContext context, ref RenderingData data)
        {
            if (!Enable) return;
            if (hi_Z == null)
                hi_Z = GameObject.FindAnyObjectByType<OcclusionCulling_Hi_z>();
            if (hi_Z == null || hi_Z.UseCPU)
                return;

            CommandBuffer cmd = CommandBufferPool.Get("DrawInstances");

            GenDepthMapController.Instance.Trigger_DrawInstancesEvent(cmd);

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
    }

    public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingOpaques;
    private DrawInstancesPass drawInstancesPass;
    public override void Create()
    {

        drawInstancesPass = new DrawInstancesPass();
        drawInstancesPass.renderPassEvent = renderPassEvent;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData data)
    {
        if (GenDepthMapController.Instance == null)
            return;
        renderer.EnqueuePass(drawInstancesPass);
    }
}
