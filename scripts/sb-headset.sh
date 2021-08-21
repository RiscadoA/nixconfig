#!/usr/bin/env bash

if headsetcontrol -c; then
	echo -ne '\uf590' $(headsetcontrol -bc)% ''
fi

