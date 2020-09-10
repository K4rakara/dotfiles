#!/usr/bin/bash

now=`date +%I:%M`;

if [ `date +%H` -gt 12 ]; then
  now+="PM";
else
  now+="AM";
fi;

dow=`date +%w`;

if [[ $1 = "short" ]]; then
  case $dow in
    0 ) dow="Sun" ;;
    1 ) dow="Mon" ;;
    2 ) dow="Tue" ;;
    3 ) dow="Wen" ;;
    4 ) dow="Thu" ;;
    5 ) dow="Fri" ;;
    6 ) dow="Sat" ;;
  esac;
else
  case $dow in
    0 ) dow="Sunday"   ;;
    1 ) dow="Monday"   ;;
    2 ) dow="Tuesday"  ;;
    3 ) dow="Wenesday" ;;
    4 ) dow="Thursday" ;;
    5 ) dow="Friday"   ;;
    6 ) dow="Saturday" ;;
  esac;
fi;

month=`date +%m`;

if [[ $1 = "short" ]]; then
  case "$month" in
    01 ) month="Jan"  ;;
    02 ) month="Feb"  ;;
    03 ) month="Mar"  ;;
    04 ) month="Apr"  ;;
    05 ) month="May"  ;;
    06 ) month="Jun"  ;;
    07 ) month="Jul"  ;;
    08 ) month="Aug"  ;;
    09 ) month="Sept" ;;
    10 ) month="Oct"  ;;
    11 ) month="Nov"  ;;
    12 ) month="Dec"  ;;
  esac;
else
  case "$month" in
    01 ) month="January"   ;;
    02 ) month="Febuary"   ;;
    03 ) month="March"     ;;
    04 ) month="April"     ;;
    05 ) month="May"       ;;
    06 ) month="June"      ;;
    07 ) month="July"      ;;
    08 ) month="August"    ;;
    09 ) month="September" ;;
    10 ) month="October"   ;;
    11 ) month="November"  ;;
    12 ) month="December"  ;;
  esac;
fi;

dom=`date +%d`;

if [ $dom -gt 20 ]; then
  case "${dom:$((${#dom}-1))}" in
    1 ) dom+="st" ;;
    2 ) dom+="nd" ;;
    3 ) dom+="rd" ;;
    * ) dom+="th" ;;
  esac;
else
  case "${dom:$((${#dom}-1))}" in
    1 ) dom+="st" ;;
    2 ) dom+="nd" ;;
    3 ) dom+="rd" ;;
    * ) dom+="th" ;;
  esac;
fi;

echo "$dow, $month $dom, $(date +%Y) -- $now";
