import gspread
import yaml
from datetime import datetime
from oauth2client.service_account import ServiceAccountCredentials

now_d = datetime.now()
now_s = now_d.strftime("%Y-%m-%d %H:%M:%S")


with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

spreadsheet_id = data_loaded['spreadsheet_id']


gc = gspread.service_account(filename='../creds.json')

gsheet = gc.open_by_key(spreadsheet_id)
mydata = gsheet.sheet1.get_all_records()

for line in mydata:
  print(line)
  if not line['Scheduled']:  # just strange line, maybe draft
    continue

  try:
    scheduled = datetime.strptime(line['Scheduled'], '%b/%d/%Y %H:%M')
  except Exception as e:
    print("ERR: this line does not contain valid Scheduled date, will be skipped")
    print(e)
    continue

  print(now_d - scheduled)
  print(type(now_d))
  print(type(scheduled))
  break
  # if not line['Posted']:





