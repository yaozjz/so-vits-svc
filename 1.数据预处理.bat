@echo off
chcp 65001
echo ====================================================================================================
echo 为避免可能的法律纠纷和道德风险，使用者在使用该整合包前，请务必仔细阅读本条款，继续使用即代表理解并同意该声明，如有异议，请立即停止使用并删除本整合包。
echo.
echo 1. 本整合包修改自So-VITS-SVC 4.0项目(https://github.com/svc-develop-team/so-vits-svc)，该项目目前由So-VITS社区维护。
echo.
echo 2. 本整合包仅为交流学习所用，在使用本整合包时，必须根据知情同意原则取得数据集音声来源的授权许可，并根据授权协议条款规定使用数据集。
echo.
echo 3. 禁止使用该整合包对公众人物、政治人物或其他容易引起争议的人物进行模型训练。使用本整合包产出和传输的信息需符合中国法律、国际公约的规定、符合公序良俗。不将本整合包以及与之相关的服务用作非法用途以及非正当用途。
echo.
echo 4. 禁止将本整合包用于血腥、暴力、性相关、或侵犯他人合法权利的用途。
echo.
echo 5. 任何发布到公共平台的基于So-VITS制作的作品，都必须要明确指明用于变声器转换的输入源歌声、音频，例如：使用他人发布的视频/音频，通过分离的人声作为输入源进行转换的，必须要给出明确的原视频、音乐链接；若使用是自己的人声，或是使用其他歌声合成引擎合成的声音作为输入源进行转换的，也必须加以说明。	
echo.			
echo 因使用者违反上述条款中的任意一条或多条而造成的一切后果，均由使用者本人承担，与整合包作者、项目作者以及So-VITS社区无关，特此声明。
echo =========================================================================================================
echo.

echo 请选择要使用的speech_encoder（输入0为vec768l12，1为vec256l9，2为hubertsoft）

echo 注：一般来说选vec768l12即可，即使用Content Vec的第12层Transformer输出作为特征输入，4.0是vec256l9
set /p encoder=:
echo.
echo 请选择要使用的f0_predictor（输入0为crepe，1为dio，2为pm，3为harvest，4为rmvpe，5为fcpe）

echo 注：仓库默认选择dio，推荐rmvpe，如果训练集过于嘈杂，请使用crepe处理f0，当然更慢也对机子要求更高，这规矩你早就懂的.jpg
set /p predictor=:
echo.
echo ==================================================================
if "%encoder%"=="0" (set se=vec768l12 & echo 使用vec768l12)
if "%encoder%"=="1" (set se=vec256l9 & echo 使用vec256l9)
if "%encoder%"=="2" (set se=hubertsoft & echo 使用hubertsoft)
if "%predictor%"=="0" (set f0=crepe & echo 使用crepe)
if "%predictor%"=="1" (set f0=dio & echo 使用dio)
if "%predictor%"=="2" (set f0=pm & echo 使用pm)
if "%predictor%"=="3" (set f0=harvest & echo 使用harvest)
if "%predictor%"=="4" (set f0=rmvpe & echo 使用rmvpe)
if "%predictor%"=="5" (set f0=fcpe & echo 使用fcpe)
echo ==================================================================
echo.
echo ================================= 开始处理 =================================
echo "注意：路径和音频文件名中不能有中文和特殊符号！"
echo ================================ 重采样至44100Hz单声道 ================================
.\env\python.exe resample.py
echo ================================ 自动划分训练集、验证集，以及自动生成配置文件 ================================
.\env\python.exe preprocess_flist_config.py --speech_encoder %se% --vol_aug
echo ================================ 生成hubert与f0 ================================
.\env\python.exe preprocess_hubert_f0.py --f0_predictor %f0% --use_diff
echo ================================ 处理完毕 ================================
pause