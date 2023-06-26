import gspread
import yaml
import datetime
from oauth2client.service_account import ServiceAccountCredentials

now_d = datetime.datetime.now()
now_s = now_d.strftime("%Y-%m-%d %H:%M:%S")


with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

spreadsheet_id = data_loaded['spreadsheet_id']


gc = gspread.service_account(filename='../creds.json')

gsheet = gc.open_by_key(spreadsheet_id)
mydata = gsheet.sheet1.get_all_records()

for line in mydata:
  print(line)




