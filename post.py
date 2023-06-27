import gspread
import requests
import yaml
from datetime import datetime

DOMAIN = "https://api.telegram.org"
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
  rownum = 1  # the first line is header, so we need to skip it

  for line in mydata:
    rownum = rownum + 1
    # print(f"{rownum} {line}")
    if not line['Scheduled'] or not line['Text']:
      print(f"{rownum} ignore: no 'Scheduled' or 'Text', just strange line, maybe draft {line}")
      continue

    try:
      scheduled = datetime.strptime(line['Scheduled'], '%b/%d/%Y %H:%M')
    except Exception as e:
      print(f"{rownum} ERR: this line does not contain valid Scheduled date, will be skipped {line}")
      print(e)
      print("--------------------------")
      continue

    print(f"scheduled={scheduled}")

    if now_d > scheduled and not line['Posted']:  # date is in the past but not posted yet
      if line['To test']:
        chat = test_chat_id
      else:
        chat = chat_id

      try:
        print(f"{rownum} sending... {line}")
        if line['Img URL']:
          if line['NSFW']:
            result = send_photo(chat, line['Text'], line['Img URL'], True)
          else:
            result = send_photo(chat, line['Text'], line['Img URL'])
        else:
          result = send_message(chat, line['Text'])
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


def send_photo(chat_id, message, url, nsfw=False):
  global tlg_token

  # send msg
  print("sendPhoto")
  url = f"{DOMAIN}/bot{tlg_token}/sendPhoto?chat_id={chat_id}&photo={url}&caption={message}&has_spoiler={nsfw}"
  result = requests.get(url).json()
  print(result)

  return result['ok']


def send_message(chat_id, message):
  global tlg_token

  # send msg
  print("sendMessage")
  url = f"{DOMAIN}/bot{tlg_token}/sendMessage?chat_id={chat_id}&text={message}"
  result = requests.get(url).json()
  print(result)

  return result['ok']


if __name__ == '__main__':
  main()
