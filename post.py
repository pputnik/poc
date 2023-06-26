import requests
import yaml
import datetime

now = datetime.datetime.now()

now_s = strftime("%Y-%m-%d %H:%M:%S", now)
print(f"now_s={now_s}")

with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

tlg_token = data_loaded['tlg_token']
chat_id = data_loaded['chat_id']

url = f"https://api.telegram.org/bot{tlg_token}/sendMessage?chat_id={chat_id}&text={now_s}"
print(requests.get(url).json())
