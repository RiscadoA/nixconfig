#!/usr/bin/env bash

if [ $(timew get dom.active) -eq 1 ]
then
    tags=""
    for (( i=1; i<=$(timew get dom.active.tag.count); i++ ))
    do
        tags="$tags $(timew get dom.active.tag.$i)"
    done

    echo -e '\uf252' $tags
else
    echo -e '\uf253'
fi

