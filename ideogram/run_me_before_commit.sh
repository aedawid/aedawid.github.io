#!/bin/bash

list=`cat database/bands/list.txt | awk -F, '{print $1}'`
files=`ls database/bands/custom*.json | tr '/' ' ' | tr '.' ' ' | awk '{print $3}'`

for i in `echo $files`
do
    list=`echo $list | tr ' ' '\n' | grep -v $i | tr '\n' ' '`
done

for i in `echo $list`
do
    cat database/bands/list.txt | grep -v $i > database/bands/tmp
    mv database/bands/tmp database/bands/list.txt
done

n=`ls database/bands/custom*.json | tr '-' ' ' | tr '.' ' ' | awk '{print $2}' | sort -n | tail -1`

for i in `ls database/bands/*.json | grep -v "custom" | tr '/' ' ' | tr '.' ' ' | awk '{print $3}'`
do
  let "n=$n+1"
  echo "custom-"$n","$i >> database/bands/list.txt
  mv database/bands/$i.json database/bands/"custom-"$n".json"
done

python3 ./.apindex/apindex.py ./database