import gspread
import yaml
from oauth2client.service_account import ServiceAccountCredentials

with open("../tlg.yml", 'r') as stream:
  data_loaded = yaml.safe_load(stream)

spreadsheet_id = data_loaded['spreadsheet_id']


gc = gspread.service_account(filename='../creds.json')

gsheet = gc.open_by_key(spreadsheet_id)
mydata = gsheet.sheet1.get_all_records()
print(mydata)




