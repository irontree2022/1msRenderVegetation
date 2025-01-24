using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrintingInformation : MonoBehaviour
{
    [Header("设备信息")]
    public UnityEngine.UI.Text DeviceInfoText;
    [Header("错误信息")]
    public UnityEngine.UI.Text ErrorInfoText;

    /// <summary>
    /// 当前设备是否华为手机
    /// </summary>
    public bool isHUAWEI { get => SystemInfo.deviceModel.ToLower().Contains("HUAWEI".ToLower()); }
    /// <summary>
    /// 设置错误信息
    /// </summary>
    public void SetError(string errorInfo) => ErrorInfoText.text = errorInfo;

    void Start()
    {
        DeviceInfoText.text =
            $"设备:{SystemInfo.deviceModel}\n" +
            $"OS:{SystemInfo.operatingSystem}\n" +
            $"CPU:{SystemInfo.processorType} [{SystemInfo.processorCount} cores]\n" +
            $"GPU:{SystemInfo.graphicsDeviceName}\n" +
            $"GPU:{SystemInfo.graphicsDeviceVersion} [{SystemInfo.graphicsDeviceType}]\n" + 
            $"GPU Instancing:{(SystemInfo.supportsInstancing ? "支持" : "不支持")}\n" + 
            $"ComputeShader:{(SystemInfo.supportsComputeShaders ? "支持" : "不支持")}";
    }
}