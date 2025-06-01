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
            // 匹配目标RT的描述(也就是RT的创建参数)
            RenderTextureDescriptor desc = cameraTextureDescriptor;
            desc.colorFormat = colorFormat;
            desc.useMipMap = false;
            // 从池子中拿一个符合RT参数的实例，如果没有就创建个新的
            // 因为有缓存池的存在，我们这里频繁创建销毁，几乎没什么性能消耗
            // 但是如果是在低端GPU设备上，缓存池就很可能会因为容量不足而频繁创建销毁了，
            // 所以最好自己持有每个RenderTargetHandle，手动管理它的生命周期
            cmd.GetTemporaryRT(depthHandle.id, desc, FilterMode.Point);
            // 配置通道的渲染目标是我们自定义RT
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

            // 命名为"GenSimpleDepthMap"的CommandBuffer，
            // 它会出现在Frame Debugger中方便我们查看。
            CommandBuffer cmd = CommandBufferPool.Get("GenSimpleDepthMap");
            // 获得相机深度图
            // 核心操作：将相机深度图拷贝到临时RT
            cmd.Blit(
                BuiltinRenderTextureType.Depth, // 源：相机深度缓冲
                depthHandle.Identifier(),       // 目标：临时RT
                depthMaterial                   // 深度转换材质
            );

            // 深度图生成后转发cmd以及深度图rt
            simple.AfterDepthMapGenerated(cmd, depthHandle.Identifier());

            // 这里达到渲染尾部，
            // 指示渲染管线按指令顺序依次去执行
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