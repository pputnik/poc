import gspread
import requests
import yaml
from datetime import datetime

tlg_token = ''

def main():
  global tlg_token

  now_d = datetime.now()
  # now_s = now_d.strftime("%Y-%m-%d %H:%M:%S")
  now_s = now_d.strftime('%b/%d/%Y %H:%M')

  print(f"now {now_s}")

  # load config
  with open("../tlg.yml", 'r') as stream:
    data_loaded = yaml.safe_load(stream)

  tlg_token = data_loaded['tlg_token']
  chat_id = data_loaded['chat_id']
  test_chat_id = data_loaded['test_chat_id']
  spreadsheet_id = data_loaded['spreadsheet_id']

  gc = gspread.service_account(filename='../creds.json')

  gsheet = gc.open_by_key(spreadsheet_id)
  mydata = gsheet.sheet1.get_all_records()

  wsheet = gsheet.worksheet("default")
  rownum = 1  # the first line is header so we need to skip it

  for line in mydata:
    rownum = rownum + 1
    print(f"{rownum} {line}")
    if not line['Scheduled'] or not line['Text']:  # just strange line, maybe draft
      continue

    try:
      scheduled = datetime.strptime(line['Scheduled'], '%b/%d/%Y %H:%M')
    except Exception as e:
      print("ERR: this line does not contain valid Scheduled date, will be skipped")
      print(e)
      print("--------------------------")
      break
      continue

    print(f"scheduled={scheduled}")

    if now_d > scheduled and not line['Posted']:  # date is in the past but not posted yet
      if line['To test']:
        chat = test_chat_id
      else:
        chat = chat_id

      try:
        result = post(chat_id, line['Text'])
      except Exception as e:
        print("ERR: can't post this message, something's wrong")
        print(e)
        continue
      if not result:
        print("ERR: can't post this message, returned status is wrong")
        print(e)
        continue

      # posted, now let's update the spreadsheet
      wsheet.update('B' + str(rownum), now_s)


def post(chat_id, message):
  global tlg_token

  # send msg
  print("posting")
  url = f"https://api.telegram.org/bot{tlg_token}/sendMessage?chat_id={chat_id}&text={message}"
  result = requests.get(url).json()
  print(result)

  return result['ok']

if __name__ == '__main__':
  main()
