#!/usr/bin/env bash
## Made for Bitbar https://getbitbar.com/ or Argos https://extensions.gnome.org/extension/1176/argos/ with ❤️

shopt -s extglob

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"
SELFNAME="$(basename "${BASH_SOURCE[0]}")"
## Icon
ICON="🦊"
#ICON=":globe_with_meridians:"
## Sort output by FF Profiles or FF Editions
## Firefox profiles = FFP
## Firefox editions = FFE
FFSORT="FFP"
## Detect OS
PLATFORM="unknown"
UNAMESTR="$(uname)"
if [ "$UNAMESTR" == "Linux" ]; then
  PLATFORM="linux"
  ## Firefox Stable binary path
  FFSBIN="/usr/bin/firefox"
  ## Firefox ESR binary path
  FFEBIN="/usr/bin/firefox-esr"
  ## Firefox Developer Edition binary path
  FFDBIN="/usr/bin/firefox-developer-edition"
  ## Firefox Nightly binary path
  FFNBIN="/usr/bin/firefox-nightly"
  ## Firefox Linux profiles path
  FFPPATH="$HOME/.mozilla/firefox"
elif [ "$UNAMESTR" == "Darwin" ]; then
  PLATFORM="mac"
  ## Firefox Stable binary path
  FFSBIN="/Applications/Firefox.app/Contents/MacOS/firefox"
  ## Firefox ESR binary path
  FFEBIN="/Applications/Firefox ESR.app/Contents/MacOS/firefox"
  ## Firefox Developer Edition binary path
  FFDBIN="/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox"
  ## Firefox Nightly binary path
  FFNBIN="/Applications/Firefox Nightly Edition.app/Contents/MacOS/firefox"
  ## Firefox macOS profiles path
  FFPPATH="$HOME/Library/Application Support/Firefox/Profiles"
fi
## Firefox profiles
PROFILES="$(find "$FFPPATH" -maxdepth 1 -name "*.*" -type d | awk -F"." '{print $NF}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')"
if [ ! -f "$FFSBIN" -a ! -f "$FFEBIN" -a ! -f "$FFDBIN" -a ! -f "$FFNBIN" ]; then
  echo "Install Firefox or edit Binary Paths in script!"
  exit 1
fi
FFBINCOUNTER="0"
EDITIONS=()
if [ -f "$FFNBIN" ]; then
  let FFBINCOUNTER=$FFBINCOUNTER+1
  EDTN="n"
  EDITIONS=("${EDITIONS[@]}" "n")
  open_ffd() {
    "$FFDBIN" -P "${PROFILE}" -no-remote >/dev/null 2>&1 &
  }
fi
if [ -f "$FFDBIN" ]; then
  let FFBINCOUNTER=$FFBINCOUNTER+1
  EDTN="d"
  EDITIONS=("${EDITIONS[@]}" "d")
  open_ffd() {
    "$FFDBIN" -P "${PROFILE}" -no-remote >/dev/null 2>&1 &
  }
fi
if [ -f "$FFEBIN" ]; then
  let FFBINCOUNTER=$FFBINCOUNTER+1
  EDTN="e"
  EDITIONS=("${EDITIONS[@]}" "e")
  open_ffe() {
    "$FFEBIN" -P "${PROFILE}" -no-remote >/dev/null 2>&1 &
  }
fi
if [ -f "$FFSBIN" ]; then
  let FFBINCOUNTER=$FFBINCOUNTER+1
  EDTN="s"
  EDITIONS=("${EDITIONS[@]}" "s")
  open_ffs() {
    "$FFSBIN" -P "${PROFILE}" -no-remote >/dev/null 2>&1 &
  }
fi

PPATTERN="+($(echo ${PROFILES// /|}))"
EDITIONSX="$(echo ${EDITIONS[@]}|rev)"
EPATTERN="+($(echo ${EDITIONSX// /|}))"

ff_profiles() {
  echo "$ICON"
  echo "---";
  for PROFILE in ${PROFILES}; do
    echo "$PROFILE | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=$EDTN terminal=false"
    if [ $FFBINCOUNTER -gt 1 ]; then
      if [ -f "$FFSBIN" ]; then
        echo "-- STABLE | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=s terminal=false"
      fi
      if [ -f "$FFEBIN" ]; then
        echo "-- ESR | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=e terminal=false"
      fi
      if [ -f "$FFDBIN" ]; then
        echo "-- DEV | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=d terminal=false"
      fi
      if [ -f "$FFNBIN" ]; then
        echo "-- NN | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=n terminal=false"
      fi
    fi
  done
}

ff_editions() {
  echo "$ICON"
  echo "---";
  for EDITION in ${EDITIONSX}; do
    if [ "$EDITION" == "s" ]; then
      ENAME="Stable"
    fi
    if [ "$EDITION" == "e" ]; then
      ENAME="ESR"
    fi
    if [ "$EDITION" == "d" ]; then
      ENAME="Dev"
    fi
    if [ "$EDITION" == "n" ]; then
      ENAME="Nightly"
    fi
    echo "$ENAME"
    for PROFILE in ${PROFILES}; do
      echo "-- $PROFILE | bash=$ROOTDIR/$SELFNAME param1=$PROFILE param2=$EDITION terminal=false"
    done
  done
}

if [ "$FFSORT" == "FFP" ]; then
  PROFILE="$1"
  EDITION="$2"
  case "$PROFILE" in
    $PPATTERN)
      echo "Running $EDITION $PROFILE"
      "open_ff"${EDITION} ${PROFILE}
      ;;
    *)
      ff_profiles
      ;;
  esac
fi

if [ "$FFSORT" == "FFE" ]; then
  PROFILE="$1"
  EDITION="$2"
  case "$EDITION" in
    $EPATTERN)
      echo "Running $EDITION $PROFILE"
      "open_ff"${EDITION} ${PROFILE}
      ;;
    *)
      ff_editions
      ;;
  esac
fi
