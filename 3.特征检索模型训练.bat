@echo off
chcp 65001
echo ============================================ 开始训练 ============================================
.\env\python.exe train_index.py -c configs/config.json
pause