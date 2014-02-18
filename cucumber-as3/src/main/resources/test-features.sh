#!/bin/bash

adl TestRunner.xml > testrunner_log.txt &

sleep 2

cucumber --strict --format pretty --out cucumber-log.txt \
    --format junit --out surefire-reports --format html --out cucumber-result.html

RES=$?

ps -ef | grep "MirrorballSlotsMain-descriptor" | awk '{print $2}' | xargs kill

echo "exit code = $RES"

echo `pwd`

exit $RES