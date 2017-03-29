#!/bin/bash

##########################################################################
#                                                                        #
#  Copyright (C) 2017  Lukas Yoder                                       #
#                                                                        #
#  This program is free software: you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or     #
#  (at your option) any later version.                                   #
#                                                                        #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
#                                                                        #
#  You should have received a copy of the GNU General Public License     #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>. #
#                                                                        #
#  find_roborio.sh: this returns the IP address of your roboRIO          #
#                                                                        #
##########################################################################


# Cleaning up variables.
ADDRESS_LOCAL_IP=
ADDRESS_LAN_IP=

TEAM_NUMBER=1683
IP_UPPER=`expr $TEAM_NUMBER / 100`
IP_LOWER=`expr $TEAM_NUMBER % 100`
ADDRESS=roboRIO-$TEAM_NUMBER-FRC
ADDRESS_LOCAL_IP=`ping -c2 -W1 $ADDRESS.local 2>/dev/null |              \
  sed "s/\(.\+\)transmitted\(.\+\)//g" |                                 \
  sed "s/\(.\+\)FRC (//g" | sed "s/):\(.\+\)//g" | sed "s/PING\(.\+\)//g"\
  | sed "s/\(.\+\)ms//g" | sed "s/---\(.\+\)//g" | sed '/^$/d' | sort -u`

ADDRESS_LAN_IP=`ping -c2 -W1 roboRIO-$ADDRESS.lan 2>/dev/null |          \
  sed "s/\(.\+\)transmitted\(.\+\)//g" |                                 \
  sed "s/\(.\+\)FRC (//g" | sed "s/):\(.\+\)//g" | sed "s/PING\(.\+\)//g"\
  | sed "s/\(.\+\)ms//g" | sed "s/---\(.\+\)//g" | sed '/^$/d' | sort -u`
ADDRESS_DEFAULT=10.$IP_UPPER.$IP_LOWER.2


# To connect to the roboRIO via USB and shell into it that way requires
#   special FRC drivers, which we probably shouldn't use
#USB_PACK_LOSS=`ping -c 2 -q 172.22.11.2 | grep -oP '\d+(?=% packet loss)'`
#PACKET_LOSS_PERCENT_MAXIMUM=50
#
#if [[ $USB_PACK_LOSS -le $PACKET_LOSS_PERCENT_MAXIMUM ]]; then
#  ADDRESS_USB=172.22.11.2
#fi


if    [ ! -z "$ADDRESS_LOCAL_IP" ]; then echo "$ADDRESS_LOCAL_IP"
elif  [ ! -z "$ADDRESS_LAN_IP" ];   then echo "$ADDRESS_LAN_IP"
elif  [ ! -z "$ADDRESS_DEFAULT" ];  then echo "$ADDRESS_DEFAULT"
elif  [ ! -z "$ADDRESS_USB" ];      then echo "$ADDRESS_USB"
fi

# vim:ts=2:sw=2:nospell
