#!/usr/bin/env bash

if headsetcontrol -c; then
	level=$(headsetcontrol -bc)
	if [[ $level != 0 ]]; then
		echo -ne '\uf590' $level% ''
	fi
fi
