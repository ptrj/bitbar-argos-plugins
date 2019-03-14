#!/bin/bash
#
# <bitbar.title>Multiple Firefox Profiles</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Peter Jirasek</bitbar.author>
# <bitbar.author.github>ptrj</bitbar.author.github>
# <bitbar.desc>You can open different Firefox profiles at the same time</bitbar.desc>
# <bitbar.image>https://i.imgur.com/XxVNUa6.png</bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>

## 1. open Firefox
## 2. in to URL type about:profiles
## 3. create profiles
## 4. put your profile names in to PROFILES variable
PROFILES="Default Anonimize Private Bank Work"

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"
SELFNAME="$(basename "${BASH_SOURCE[0]}")"
PATTERN="+($(echo ${PROFILES// /|}))"
EDITIONS="s d"


## Firefox Stable
open_ffs() {
  /Applications/Firefox.app/Contents/MacOS/firefox -P "${PROFILE}" >/dev/null 2>&1 &
}

## Firefox Developer Edition
open_ffd() {
  /Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox -P "${PROFILE}" >/dev/null 2>&1 &
}

bitbar() {
  echo "🦊"
  echo "---";
  for PROFILE in ${PROFILES}; do
    echo "$PROFILE | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=s terminal=false"
    if [ -f "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox" ]; then
      echo "----"
      echo "-- Stable | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=s terminal=false"
      echo "-- Devel | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=d terminal=false"
    fi
  done
}

EDITION="${2:-s}"
PROFILE="$1"
case "$PROFILE" in
  $PATTERN)
    "open_ff"${EDITION} $PROFILE
    ;;
    *) bitbar
esac
