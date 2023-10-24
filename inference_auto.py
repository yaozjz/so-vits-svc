import subprocess
import json

F0 = {
    "0":"crepe", 
    "1": "pm", 
    "2": "dio", 
    "3": "harvest", 
    "4": "rmvpe", 
    "5": "fcpe"
}

# 主模型
model_name = "G_52800.pth"
# 参考干声
wav_name = input("输入参考干声(默认为test(.wav))>>>")
wav_name = "test" if wav_name == "" else wav_name
# 音高
key_num = input("输入音高(key)默认为0>>>")
key_num = "0" if key_num == "" else key_num

f0_predictor = input("输入使用的F0预测器(0:crepe,1:pm,2:dio,3:harvest,4:rmvpe,5:fcpe)默认4\n>>>")
f0_predictor = "rmvpe" if f0_predictor == "" else F0[f0_predictor]

if_diffusion = "n"
diffusion_name = ""
diffusion_k_step = "100"
#NSF_HIFIGAN增强器
if_enhance = 'y'

if_feature_retrieval = 'y'
cluster_ratio = 0.5

if_clip = 0
if_linear_gradient = 0

if_auto_predict_f0 = 'n'

# 音频输出格式:
wavFomat = "flac"
'''
crepe
pm
dio
harvest
rmvpe
fcpe
'''
print("\n============")
print("推理配置清单")
print("============\n")
print(f"使用的模型：{model_name}")
print(f"参考的干声：{wav_name}.wav")
print(f"音高调整：{key_num} key")
print(f"F0预测器：{f0_predictor}\n")


# check_menu = input("按回车键继续")
print("==================================================开始推理========================================================")

inference_case = r'.\env\python.exe inference_main.py'
config_File = "configs/config.json"
speeker = "keqing"
with open(config_File) as f:
    config_dict = json.load(f)
    speeker, = config_dict["spk"]
inference_case = inference_case + f' -m "logs/44k/{model_name}" -c {config_File} -n "{wav_name}" -t {key_num} -s {speeker} -f0p {f0_predictor}'

if if_diffusion == 'y':
    inference_case = inference_case + f' -shd -dm "logs/44k/diffusion/{diffusion_name}" -ks {diffusion_k_step}'
if if_enhance == 'y':
    inference_case = inference_case + f' -eh'
# if if_cluster == 'y':
#     inference_case = inference_case + f' -cm "logs/44k/kmeans_10000.pt" -cr {cluster_ratio}'
if if_feature_retrieval == 'y':
    inference_case = inference_case + f' --feature_retrieval -cr {cluster_ratio}'
if if_auto_predict_f0 == 'y':
    inference_case = inference_case + f' -a'

inference_case = inference_case + f' -cl {if_clip} -lg {if_linear_gradient}'
inference_case += f' -sd -30 -wf {wavFomat}'

subprocess.run(f'{inference_case}', shell=True)
