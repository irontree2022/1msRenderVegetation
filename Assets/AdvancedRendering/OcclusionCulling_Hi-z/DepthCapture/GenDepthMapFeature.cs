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
            // 命名为"GenDepthMap"的CommandBuffer，
            // 它会出现在Frame Debugger中方便我们查看。
            CommandBuffer cmd = CommandBufferPool.Get("GenDepthMap");
            // 获得相机深度图
            // 核心操作：将相机深度图拷贝到临时RT
            cmd.Blit(
                BuiltinRenderTextureType.Depth, // 源：相机深度缓冲
                depthHandle.Identifier(),       // 目标：临时RT
                depthMaterial                   // 深度转换材质
            );

            // 开始生成Mipmap
            // 这里最小mipmap尺寸为 1x1
            if (genDepthMipmapaterial == null)
                genDepthMipmapaterial = new Material(GenDepthMapController.Instance.genDepthMipmapShader);
            // 最终生成的深度图
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
                // mipmapLevel == 0 时，实际使用的是拷贝后的相机深度图
                RenderTargetHandle mipmapHandle = mipmapLevel == 0 ? depthHandle : default;

                if(mipmapLevel != 0)
                {
                    // 生成一个临时RT用于存储当前层Mipmap处理结果
                    mipmapHandle.Init($"tempMipmap_{mipmapLevel}");
                    RenderTextureDescriptor desc = new RenderTextureDescriptor(_w, _h, colorFormat, 0);
                    desc.useMipMap = false;
                    cmd.GetTemporaryRT(mipmapHandle.id, desc, FilterMode.Point);
                    // 将上一层Mipmap经过shader拷贝到当前层Mipmap中
                    // 该shader内部将采样并写入深度的最小值
                    cmd.Blit(per.Identifier(), mipmapHandle.Identifier(), genDepthMipmapaterial);
                }
                // 最后将当前层Mipmap纹理拷贝到深度图的对应层级中
                // 一般不需要两个深度图（一个RenderTargetHandle，一个RenderTexture），具体看情况选择一种就可以，
                // 一般仅使用 RenderTargetHandle 就足够了，
                // 这里是作为示例演示，这里额外创建了俩个RT，大家实际使用时不需要这样做
                cmd.CopyTexture(mipmapHandle.Identifier(), 0, 0, tempMipmapRT.Identifier(), 0, mipmapLevel);
                cmd.CopyTexture(mipmapHandle.Identifier(), 0, 0, targetRT, 0, mipmapLevel);
                if (mipmapLevel != 0)
                    cmd.ReleaseTemporaryRT(per.id); // 释放临时RT
                per = mipmapHandle;


                ++mipmapLevel;
                // 也就是每层mipmap尺寸都是之前的一半
                _w = width >> mipmapLevel; 
                _h = height >> mipmapLevel;
            }
            cmd.ReleaseTemporaryRT(per.id);// 释放临时RT
            GenDepthMapController.Instance.MipmapCount = mipmapLevel;
            GenDepthMapController.Instance.IsMipmapGenCompleted = true;


            // 深度图生成后转发cmd以及深度图rt
            GenDepthMapController.Instance.Trigger_AfterDepthMapGeneratedEvent(cmd, tempMipmapRT.Identifier());

            // 这里达到渲染尾部，
            // 指示渲染管线按指令顺序依次去执行
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