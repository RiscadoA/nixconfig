#!/usr/bin/env bash

if [[ $(/usr/bin/env nmcli d | grep ethernet) = *'connected'* ]]; then
	echo -e '\uf6ff'
else
	echo -e '\uf1eb' $(/usr/bin/env nmcli -t -f NAME c show --active | head -n 1) 
fi
