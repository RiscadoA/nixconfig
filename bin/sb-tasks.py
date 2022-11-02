#!/usr/bin/env python

from multiprocessing import Pool

import requests

# Creating an API Key and Token
# For the key, access this URL:
#   https://trello.com/1/appKey/generate
# For the token, access this:
#   https://trello.com/1/authorize?response_type=token&expiration=30days&name=gui&key=REPLACE_WITH_YOUR_KEY

with open('/home/riscadoa/nixos/secrets/trello-api-key', 'r') as file:
    API_KEY = file.read().strip()
with open('/home/riscadoa/nixos/secrets/trello-api-token', 'r') as file:
    API_TOKEN = file.read().strip()

BOARD_ID = '60662b7b0097ad2a380690e7'

if __name__ == '__main__':
    board = requests.get('https://trello.com/1/boards/%s' % BOARD_ID, params={'key': API_KEY, 'token': API_TOKEN}).json()
    lists = requests.get('https://trello.com/1/boards/%s/lists' % BOARD_ID, params={'key': API_KEY, 'token': API_TOKEN}).json()
    lists = { l['name']: l['id'] for l in lists }
    weekly = len(requests.get('https://trello.com/1/lists/%s/cards' % lists['Weekly To Do'], params={'key': API_KEY, 'token': API_TOKEN}).json())
    daily = len(requests.get('https://trello.com/1/lists/%s/cards' % lists['Daily To Do'], params={'key': API_KEY, 'token': API_TOKEN}).json())
    print("%d/%d" % (weekly, daily))
