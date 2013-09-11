#! /bin/bash
# Dependencies: imagemagick scp xclip

FILE="screenshot-`date +%Y-%m-%d_%H-%M`.png"
TMP=~/tmp/screenshots
REMOTE=vrac
SHOTOPTION="-window root"
UPLOAD=0

SERVER="pwet.fr:~/vrac/"
URL="http://vrac.pwet.fr/$FILE"

print_usage ()
{
    echo "Usage : $0 [-w] [-u]"
    echo -e "\t-w : select a window before taking the screenshot"
    echo -e "\t-u : copy by SCP"
}

# options
while getopts "uw" opt ; do
    case $opt in
        u ) UPLOAD=1 ;;
        w ) SHOTOPTION="" ;;
        * ) echo "Wrong option $opt"
            print_usage "$0"
            exit 1 ;;
    esac
done

[ ! -d $TMP ] &&  mkdir -p "$TMP"
cd "$TMP"

# screenshot
import $SHOTOPTION "$FILE"

if [ $UPLOAD -eq 1 ] ; then
    echo -n "$URL" | xclip
    scp "$FILE" "$SERVER"
fi

