using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace RenderVegetationIn1ms.BasicRenderingFrameworkDemo
{
    public class UIManager : MonoBehaviour
    {
        public Image ScreenImage;
        public Text TitleText;
        public GameObject LoadingPanel;
        public Image LoadingImage;
        public Image ProgressImage;
        public Text ProgressText;
        public Text LoadingStatusText;

        [Header("启动时文本动画时间(秒)")]
        [Range(0.5f, 8f)]
        public float TitlleTextAnimationTimeInterval = 2;
        [Header("启动时文本大小起始值")]
        [Range(0f, 1f)]
        public float TitlleTextFontSizeStartPercentage = 0.5f;


        private static UIManager _Instance;
        public static UIManager Instance => _Instance;


        private bool _Initialized;
        private int _TitlleTextFontSize;
        private float _TimeInterval;
        private bool _TitlleTextAnimationDone;
        private bool _RenderingSystemStarted;
        private string _TitileStr;
        private string _DetailsStr;
        private float _Progress;
        private object _ProgressSync = new object();
        private bool _CanIntoGameScene;
        private const string _EnteringGameScene = "正在进入游戏场景...";
        private float _EnteredGameScenedDelayTime = 2f;
        private bool _EnteredGameSceneAnimationDone;
        private bool _EnteredGameScene;

        private void Awake() => _Instance = this;
        private void Init()
        {
            _Initialized = true;

            _TitlleTextFontSize = TitleText.fontSize;
            TitleText.fontSize = (int)(TitlleTextFontSizeStartPercentage * _TitlleTextFontSize);
            SetTitleTextAlpha(0);
            SetProgress(null, null, 0);
            LoadingPanel.SetActive(false);

        }
        private void SetTitleTextAlpha(float Alpha)
        {
            var color = TitleText.color;
            color.a = Alpha;
            TitleText.color = color;
        }
        private void SetScreenImageAlpha(float Alpha)
        {
            var color = ScreenImage.color;
            color.a = Alpha;
            ScreenImage.color = color;
        }
        private void SetProgress(string info, string details, float progress)
        {
            var size = ProgressImage.rectTransform.sizeDelta;
            size.x = progress * LoadingImage.rectTransform.sizeDelta.x;
            ProgressImage.rectTransform.sizeDelta = size;
            if (string.IsNullOrEmpty(info)) info = string.Empty;
            if (string.IsNullOrEmpty(details)) details = string.Empty;
            ProgressText.text = info;
            LoadingStatusText.text = details;
        }
        private void StartRenderingSystem()
        {
            _RenderingSystemStarted = true;
            RenderingAPI.E_LocalVegetationDataLoadingSituation += RenderingAPI_E_LocalVegetationDataLoadingSituation;
            RenderingAPI.RenderParams.AllowRendering = true;
        }
        private void RenderingAPI_E_LocalVegetationDataLoadingSituation(bool isDone, float progress, string info, string details)
        {
            lock (_ProgressSync)
            {
                if (isDone)
                {
                    _CanIntoGameScene = true;
                    _TitileStr = _EnteringGameScene;
                    _Progress = 1;
                    return;
                }
                _TitileStr = $"{info} {(progress * 100).ToString("f2")}%";
                _DetailsStr = details;
                _Progress = progress;
            }
        }
        public void SetProgressUIs()
        {
            if(!LoadingPanel.activeSelf)
                LoadingPanel.SetActive(true);
            if (!LoadingImage.gameObject.activeSelf)
                LoadingImage.gameObject.SetActive(true);
            if (!ProgressImage.gameObject.activeSelf)
                ProgressImage.gameObject.SetActive(true);
            if (!ProgressText.gameObject.activeSelf)
                ProgressText.gameObject.SetActive(true);
            if (!LoadingStatusText.gameObject.activeSelf)
                LoadingStatusText.gameObject.SetActive(true);
            if (!LoadingImage.enabled)
                LoadingImage.enabled = true;
            if (!ProgressImage.enabled)
                ProgressImage.enabled = true;
            if (!ProgressText.enabled)
                ProgressText.enabled = true;
            if (!LoadingStatusText.enabled)
                LoadingStatusText.enabled = true;

            lock (_ProgressSync)
                SetProgress(_TitileStr, _DetailsStr, _Progress);
        }
        private void IntoGameScene()
        {
            _EnteredGameScene = true;
            SetScreenImageAlpha(1);
            ScreenImage.gameObject.SetActive(false);
            LoadingPanel.gameObject.SetActive(false);
        }

        private void Update()
        {
            if (!_Initialized) Init();
            if (!_TitlleTextAnimationDone)
            {
                if (_TimeInterval >= TitlleTextAnimationTimeInterval)
                {
                    _TitlleTextAnimationDone = true;
                    _TimeInterval = 0;
                    SetTitleTextAlpha(1);
                    TitleText.fontSize = _TitlleTextFontSize;
                }
                else
                {
                    var value = _TimeInterval / TitlleTextAnimationTimeInterval;
                    SetTitleTextAlpha(value);
                    var startFontSize = TitlleTextFontSizeStartPercentage * _TitlleTextFontSize;
                    TitleText.fontSize = (int)(startFontSize + value * (1 - TitlleTextFontSizeStartPercentage) * _TitlleTextFontSize);
                    _TimeInterval += Time.deltaTime;
                }
            }
            if(_TitlleTextAnimationDone && !_RenderingSystemStarted && RenderingAPI.Initialized)
                StartRenderingSystem();

            if (_RenderingSystemStarted)
            {
                lock (_ProgressSync)
                    if (!_CanIntoGameScene)
                        SetProgressUIs();
                    else if (ProgressText.text != _EnteringGameScene)
                        SetProgressUIs();
            }

            if(_CanIntoGameScene && !_EnteredGameScene && !_EnteredGameSceneAnimationDone)
            {
                if(_TimeInterval >= _EnteredGameScenedDelayTime)
                {
                    var dtime = _TimeInterval - _EnteredGameScenedDelayTime;
                    if(dtime > 2.5f)
                        _EnteredGameSceneAnimationDone = true;
                    else
                    {
                        if (LoadingPanel.activeSelf)
                            LoadingPanel.SetActive(false);
                        if (TitleText.gameObject.activeSelf)
                            TitleText.gameObject.SetActive(false);
                        SetScreenImageAlpha(1 - dtime / 3f);
                    }
                }
                _TimeInterval += Time.deltaTime;
            }

            if (!_EnteredGameScene && _CanIntoGameScene && _EnteredGameSceneAnimationDone)
                IntoGameScene();

        }
        private void OnDestroy()
        {
            RenderingAPI.E_LocalVegetationDataLoadingSituation -= RenderingAPI_E_LocalVegetationDataLoadingSituation;
            _ProgressSync = null;
            _Instance = null;
        }
    }
}
