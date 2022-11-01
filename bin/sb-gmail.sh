#!/usr/bin/env bash

echo -e '\uf0e0' $(nix-shell -p python --run "python /home/riscadoa/bin/sb-gmail.py")
