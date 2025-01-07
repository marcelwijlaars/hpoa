#!/bin/sh
DELAYMIN=2
let DELAYSEC=$DELAYMIN*60
RUNMIN=0
while :
do 
sleep $DELAYSEC
let RUNMIN=$RUNMIN+$DELAYMIN
ps -ef | grep $1 | grep -v grep >/dev/null 2>&1
if [ $? -eq 0 ]; then
echo HP SUM has been running for $RUNMIN minutes.
else
echo HP SUM stopped running after $RUNMIN minutes.
break
fi
done
