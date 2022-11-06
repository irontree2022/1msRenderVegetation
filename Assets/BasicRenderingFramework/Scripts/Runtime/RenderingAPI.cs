using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Timeline;

namespace RenderVegetationIn1ms
{
    /// <summary>
    /// ��ȾAPI
    /// <para>��¶������ϵͳ����Ⱦ�ӿڣ��ⲿϵͳ����Ⱦϵͳ����һ��ͨ�� RenderingAPI ���С�</para>
    /// </summary>
    public static class RenderingAPI
    {
        private static RenderVegetationIn1ms _RenderParams;
        private static RenderingSharedVars _RenderVars;


        /// <summary>
        /// ��Ⱦ���Ʋ���
        /// </summary>
        public static RenderVegetationIn1ms RenderParams { get => _RenderParams; }
        /// <summary>
        /// �������Ⱦ����
        /// </summary>
        public static RenderingSharedVars RenderVars { get => _RenderVars; }
        /// <summary>
        /// ������Ⱦ���Ʋ�������
        /// </summary>
        /// <param name="renderParams">��Ⱦ���Ʋ�������</param>
        public static void Init(RenderVegetationIn1ms renderParams)
        {
            _RenderParams = renderParams;
            _RenderVars = new RenderingSharedVars();
        }



        /// <summary>
        /// ��Ⱦϵͳ�Ƿ��ʼ����ϣ�
        /// </summary>
        public static bool Initialized => _RenderVars != null && _RenderVars.Initialized;



        /// <summary>
        /// ����ֲ�����ݿ��첽����״̬�¼�
        /// <para>bool: isDone �Ƿ�������</para>
        /// <para>float: progress ���ؽ���</para>
        /// <para>string: info ������Ϣ</para>
        /// <para>string: details ������ϸ��Ϣ</para>
        /// </summary>
        public static event System.Action<bool, float, string, string> E_LocalVegetationDataLoadingSituation;
        /// <summary>
        /// �����¼�������ֲ�����ݿ��첽����״̬
        /// <para>�����桿�˺���Ϊ��Ⱦϵͳר�ú��������ܱ�����ϵͳ���ã������������Ӧ�����������档</para>
        /// <para>_identity: �����֤��Ϣ</para>
        /// <para>bool: isDone �Ƿ�������</para>
        /// <para>float: progress ���ؽ���</para>
        /// <para>string: info ������Ϣ</para>
        /// <para>string: details ������ϸ��Ϣ</para>
        /// </summary>
        public static void TriggerEvent_E_LocalVegetationDataLoadingSituation(int _identity, bool isDone, float progress, string info, string details)
        {
            if(_RenderVars == null || !_RenderVars.identityPassed(_identity))
            {
                Debug.LogWarning($"[RenderVegetationIn1ms] �����֤ʧ�ܣ��˺���Ϊ��Ⱦϵͳר�ú��������ܱ�����ϵͳ���á�");
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
