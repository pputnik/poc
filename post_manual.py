
import requests
import yaml
import datetime

now_d = datetime.datetime.now()
now_s = now_d.strftime("%Y-%m-%d %H:%M:%S")
print(f"now_s={now_s}")

# photo = "https://cdn.anime-planet.com/characters/primary/coconut-nekopara-1.jpg?t=1625885499"
photo = "https://cdn.anime-planet.com/characters/primary/coconut-nekopara-1.jpg"

# load config
with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

tlg_token = data_loaded['tlg_token']
chat_id = data_loaded['chat_id']
print(f"tlg_token={tlg_token}")
print(f"chat_id={chat_id}")
caption = """
трохи тексту
"""

# send msg
# url = f"https://api.telegram.org/bot{tlg_token}/sendMessage?chat_id={chat_id}&text={now_s}"
url = f"https://api.telegram.org/bot{tlg_token}/sendPhoto?chat_id={chat_id}&photo={now_s}&caption={caption}"
print(requests.post(url).json())



# https://core.telegram.org/bots/api#formatting-options
# https://core.telegram.org/bots/api#sendphoto
