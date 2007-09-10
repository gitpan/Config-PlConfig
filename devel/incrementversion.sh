#!/bin/bash
basedir=$(dirname $0);
curversion=$(  perl $basedir/curversion -Q  );
nv=$(perl $basedir/curversion -i);
nextversion=$( perl $basedir/curversion -iQ );

if [ ! -z "$1" ]; then
    nv="$1"
    nextversion=$(echo "$1" | perl -nle'print quotemeta');
fi

for file in $(ack -l "\b$curversion\b")
do
    test ! "$?" && break;
    perl -pi -e"
        s/\b$curversion\b/$nextversion/g            
    " "$file"
done

echo ">>> New version: $nv"


