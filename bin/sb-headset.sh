#!/usr/bin/env bash

if headsetcontrol -bc > /dev/null 2>&1; then
	level=$(headsetcontrol -bc)
	if [[ $level != 0 ]]; then
		echo -ne '\uf590' $level% ''
	fi
fi
