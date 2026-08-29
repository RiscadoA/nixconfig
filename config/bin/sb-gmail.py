#!/usr/bin/env python3

import imaplib
import os

# Get credential paths from environment variables
username_file = os.environ.get('GMAIL_USERNAME_FILE', '/home/riscadoa/nixos/secrets/gmail-username')
password_file = os.environ.get('GMAIL_PASSWORD_FILE', '/home/riscadoa/nixos/secrets/gmail-password')

with open(username_file, 'r') as file:
    username = file.read().strip()
with open(password_file, 'r') as file:
    password = file.read().strip()

obj = imaplib.IMAP4_SSL('imap.gmail.com', '993')
obj.login(username, password)
obj.select()
print(len(obj.search(None, 'UnSeen')[1][0].split()))
