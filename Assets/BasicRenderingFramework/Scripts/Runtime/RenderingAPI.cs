using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Timeline;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// 渲染API
    /// <para>暴露给其他系统的渲染接口，外部系统与渲染系统交互一律通过 RenderingAPI 进行。</para>
    /// </summary>
    public static class RenderingAPI
    {
        private static RenderVegetationIn1ms _RenderParams;
        private static RenderingSharedVars _RenderVars;


        /// <summary>
        /// 渲染控制参数
        /// </summary>
        public static RenderVegetationIn1ms RenderParams { get => _RenderParams; }
        /// <summary>
        /// 共享的渲染变量
        /// </summary>
        public static RenderingSharedVars RenderVars { get => _RenderVars; }
        /// <summary>
        /// 设置渲染控制参数对象
        /// </summary>
        /// <param name="renderParams">渲染控制参数对象</param>
        public static void Init(RenderVegetationIn1ms renderParams)
        {
            _RenderParams = renderParams;
            _RenderVars = new RenderingSharedVars();
        }



        /// <summary>
        /// 渲染系统是否初始化完毕？
        /// </summary>
        public static bool Initialized => _RenderVars != null && _RenderVars.Initialized;



        /// <summary>
        /// 本地植被数据库异步加载状态事件
        /// <para>bool: isDone 是否加载完成</para>
        /// <para>float: progress 加载进度</para>
        /// <para>string: info 加载信息</para>
        /// <para>string: details 加载详细信息</para>
        /// </summary>
        public static event System.Action<bool, float, string, string> E_LocalVegetationDataLoadingSituation;
        /// <summary>
        /// 触发事件：本地植被数据库异步加载状态
        /// <para>【警告】此函数为渲染系统专用函数，不能被其他系统调用，否则调用无响应，并触发警告。</para>
        /// <para>_identity: 身份验证信息</para>
        /// <para>bool: isDone 是否加载完成</para>
        /// <para>float: progress 加载进度</para>
        /// <para>string: info 加载信息</para>
        /// <para>string: details 加载详细信息</para>
        /// </summary>
        public static void TriggerEvent_E_LocalVegetationDataLoadingSituation(int _identity, bool isDone, float progress, string info, string details)
        {
            if(_RenderVars == null || !_RenderVars.identityPassed(_identity))
            {
                Debug.LogWarning($"[RenderVegetationIn1ms] 身份验证失败！此函数为渲染系统专用函数，不能被其他系统调用。");
                return;
            }
            E_LocalVegetationDataLoadingSituation?.Invoke(isDone, progress, info, details);
        }



        public static void OnDestroy()
        {
            _RenderParams = null;
            _RenderVars = null;
        }
    }
}
