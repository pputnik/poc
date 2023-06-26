import requests
import yaml
import datetime
from datetime import datetime

now_d = datetime.datetime.now()

now_s = strftime("%Y-%m-%d %H:%M:%S", now_d)
print(f"now_s={now_s}")

# load config
with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

tlg_token = data_loaded['tlg_token']
chat_id = data_loaded['chat_id']

# send msg
url = f"https://api.telegram.org/bot{tlg_token}/sendMessage?chat_id={chat_id}&text={now_s}"
print(requests.get(url).json())
