@echo off
chcp 65001
echo ==========================================================================
echo 注：训练生成的模型含有继续训练所需的信息。如果确认不再训练，可以移除模型中此部分信息，得到约 1/3 大小的最终模型。
echo ==========================================================================
echo.
echo 请输入需要压缩的模型步数（例：模型为G_800.pth就输入800）
set /p step=:
echo ================================ 成功！开始处理 ================================
.\env\python.exe compress_model.py -c="configs/config.json" -i="logs/44k/G_%step%.pth" -o="logs/44k/release.pth"
echo ================================ 处理完毕，输出为release.pth ================================
pause