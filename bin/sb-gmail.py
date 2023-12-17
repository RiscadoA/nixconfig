#!/usr/bin/env python3

import imaplib

with open('/home/riscadoa/nixos/secrets/gmail-username', 'r') as file:
    username = file.read().strip()
with open('/home/riscadoa/nixos/secrets/gmail-password', 'r') as file:
    password = file.read().strip()

obj = imaplib.IMAP4_SSL('imap.gmail.com', '993')
obj.login(username, password)
obj.select()
print(len(obj.search(None, 'UnSeen')[1][0].split()))
