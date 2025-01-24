using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrintingInformation : MonoBehaviour
{
    [Header("�豸��Ϣ")]
    public UnityEngine.UI.Text DeviceInfoText;
    [Header("������Ϣ")]
    public UnityEngine.UI.Text ErrorInfoText;

    /// <summary>
    /// ��ǰ�豸�Ƿ�Ϊ�ֻ�
    /// </summary>
    public bool isHUAWEI { get => SystemInfo.deviceModel.ToLower().Contains("HUAWEI".ToLower()); }
    /// <summary>
    /// ���ô�����Ϣ
    /// </summary>
    public void SetError(string errorInfo) => ErrorInfoText.text = errorInfo;

    void Start()
    {
        DeviceInfoText.text =
            $"�豸:{SystemInfo.deviceModel}\n" +
            $"OS:{SystemInfo.operatingSystem}\n" +
            $"CPU:{SystemInfo.processorType} [{SystemInfo.processorCount} cores]\n" +
            $"GPU:{SystemInfo.graphicsDeviceName}\n" +
            $"GPU:{SystemInfo.graphicsDeviceVersion} [{SystemInfo.graphicsDeviceType}]\n" + 
            $"GPU Instancing:{(SystemInfo.supportsInstancing ? "֧��" : "��֧��")}\n" + 
            $"ComputeShader:{(SystemInfo.supportsComputeShaders ? "֧��" : "��֧��")}";
    }
}