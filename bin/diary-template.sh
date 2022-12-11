#!/usr/bin/env bash

nix-shell -p python --run "python /etc/nixos/bin/diary-template.py"
