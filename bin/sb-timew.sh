#!/usr/bin/env bash

if [ $(timew get dom.active) -eq 1 ]
then
    tags=
    for (( i=1; i<=$(timew get dom.active.tag.count); i++ ))
    do
        tags="$tags $(timew get dom.active.tag.$i)"
    done

    icons=('\uf251' '\uf254' '\uf253')
    index=$(expr $(date +%s) / 2 % 3)
    echo -e ${icons[$index]} $tags
else
    echo -e '\uf252'
fi

