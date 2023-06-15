#!/bin/sh

CONFIG=$HOME/.config/system
GLOBAL_PROTECT=/Applications/GlobalProtect.app/Contents/Resources/

sudo -A -v

sudo cp $CONFIG/etc/* /etc/

if [ -d $GLOBAL_PROTECT ]; then
    sudo mkdir $GLOBAL_PROTECT/Scripts/
    sudo cp $CONFIG/GlobalProtect_Event_Trigger.sh $GLOBAL_PROTECT/Scripts/
fi


