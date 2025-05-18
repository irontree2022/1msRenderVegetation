// GenDepthMapController.cs
using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering;
using Unity.Mathematics;
using System;
using System.Collections;
using System.Collections.Generic;



public class GenDepthMapController : MonoBehaviour
{
    static GenDepthMapController _instance;
    public static GenDepthMapController Instance => _instance;
    public Camera Camera;


    [Header("已初始化完成")]
    public bool IsInitialized;
    [Header("深度图")]
    public RenderTexture RT;



    [Space(10)]
    [Header("调试相关内容")]
    public bool IsGenOnlyOnce;
    public Shader depthShader;
    public bool showDebug = true;
    public float debugSize = 256f;


    public event System.Action<CommandBuffer, RenderTargetIdentifier> AfterDepthMapGeneratedEvent;
    public event System.Action<CommandBuffer> DrawInstancesEvent;
    public event System.Action<CommandBuffer> DrawInstancesShadowEvent;
    public void Trigger_AfterDepthMapGeneratedEvent(CommandBuffer cmd, RenderTargetIdentifier targetIdentifier) => AfterDepthMapGeneratedEvent?.Invoke(cmd, targetIdentifier);
    public void Trigger_DrawInstancesEvent(CommandBuffer cmd) => DrawInstancesEvent?.Invoke(cmd);
    public void Trigger_DrawInstancesShadowEvent(CommandBuffer cmd) => DrawInstancesShadowEvent?.Invoke(cmd);

    private void Awake()
    {
        // 确保URP启用深度纹理
        UniversalRenderPipelineAsset urpAsset = GraphicsSettings.currentRenderPipeline as UniversalRenderPipelineAsset;
        if (urpAsset != null)
            urpAsset.supportsCameraDepthTexture = true;

        if (depthShader == null)
            depthShader = Shader.Find("Hidden/DepthConversion2");

        Camera = Camera.main;
        Camera.depthTextureMode |= DepthTextureMode.Depth;

        RT = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.RFloat);
        RT.useMipMap = false;
        RT.autoGenerateMips = false;
        RT.filterMode = FilterMode.Point;
        RT.Create();

        IsInitialized = true;
        _instance = this;
    }



    void OnGUI()
    {
        if (showDebug && RT != null)
        {
            GUI.DrawTexture(
                new Rect(10, 0, debugSize, debugSize),
                RT,
                ScaleMode.ScaleToFit
            );
        }
    }

    void OnDestroy()
    {
        if (RT != null)
            RT.Release();
        RT = null;
    }
}