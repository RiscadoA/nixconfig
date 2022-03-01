#!/usr/bin/env bash

echo -e '\uf0e0' $(nix-shell -p python --run "python /etc/nixos/bin/sb-gmail.py")
