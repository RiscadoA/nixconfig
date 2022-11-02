#!/usr/bin/env bash

echo -e '\uf0e0' $(nix-shell -p python --run "python /home/riscadoa/nixos/bin/sb-gmail.py")
