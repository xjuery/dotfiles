#! /bin/bash

COUNT=$(apt list --upgradable 2> /dev/null | wc -l)
UPGRADABLE_COUNT=`expr $COUNT - 1`
echo $UPGRADABLE_COUNT > ~/.apt_upgrade_count
