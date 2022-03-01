#!/usr/bin/env bash

echo -e '\uf0ae' $(nix-shell -p 'python.withPackages(ps: with ps; [ requests ])' --run 'python /etc/nixos/bin/sb-tasks.py')
