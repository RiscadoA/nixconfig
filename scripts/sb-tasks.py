#!/usr/bin/env python

from multiprocessing import Pool

import requests

# Creating an API Key and Token
# For the key, access this URL:
#   https://trello.com/1/appKey/generate
# For the token, access this:
#   https://trello.com/1/authorize?response_type=token&expiration=30days&name=gui&key=REPLACE_WITH_YOUR_KEY
API_KEY = '213b8ea77a27607eb8ea3b45c912b618'
API_TOKEN = '26ad26aa79a6269cc3a29956b533865d4d6723c2b86ea3d722f185a1f5f32cba'

BOARD_ID = '60662b7b0097ad2a380690e7'

if __name__ == '__main__':
    board = requests.get('https://trello.com/1/boards/%s' % BOARD_ID, params={'key': API_KEY, 'token': API_TOKEN}).json()
    lists = requests.get('https://trello.com/1/boards/%s/lists' % BOARD_ID, params={'key': API_KEY, 'token': API_TOKEN}).json()
    lists = { l['name']: l['id'] for l in lists }
    weekly = len(requests.get('https://trello.com/1/lists/%s/cards' % lists['Weekly To Do'], params={'key': API_KEY, 'token': API_TOKEN}).json())
    daily = len(requests.get('https://trello.com/1/lists/%s/cards' % lists['Daily To Do'], params={'key': API_KEY, 'token': API_TOKEN}).json())
    print("%d/%d" % (weekly, daily))
