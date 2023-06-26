import requests
import yaml

with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

print(data_loaded)
