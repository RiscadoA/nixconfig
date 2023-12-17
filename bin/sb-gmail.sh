#!/usr/bin/env bash

echo -e '\uf0e0' $(nix-shell -p python3 --run "python /home/riscadoa/nixos/bin/sb-gmail.py")
