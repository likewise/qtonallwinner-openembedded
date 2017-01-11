#!/bin/bash

# cat ~/.netrc
# machine XXX.stackstorage.com login XXX password YYY

TIMESTAMP=`date +%Y%m%d`

COMPRESSOR=pixz
FILENAME=openembedded${TIMESTAMP}.tar.${COMPRESSOR}

echo $FILENAME

rm /tmp/?x.md5sum

#time tar -Ipixz -cvf- meta* openembedded-core build/conf build/Makefile build/sstate-cache doc scripts tmux.sh | \
time tar -I${COMPRESSOR} -cvf- \
meta* openembedded-core build/conf build/Makefile doc scripts tmux.sh | \
tee >(md5sum >/tmp/tx.md5sum) | \
curl -T- -n -o /dev/stdout \
https://sidebranch.stackstorage.com/remote.php/webdav/BridgeMate/Backups/$FILENAME \
--header "Transfer-Encoding: chunked"

#md5sum $FILENAME
#tar -I${COMPRESSOR} tf $FILENAME
#rm $FILENAME

#tee $FILENAME |
#curl -T. -n -o /dev/stdout \
#curl -X PUT --data-binary @- -n -o /dev/stdout \ <-works

#./scripts/upload.py $FILENAME

# https://curl.haxx.se/mail/lib-2007-01/0229.html
echo downloading

curl -n https://sidebranch.stackstorage.com/remote.php/webdav/BridgeMate/Backups/$FILENAME | \
md5sum - >/tmp/rx.md5sum

diff /tmp/rx.md5sum /tmp/tx.md5sum
if [ $? -eq 0 ]; then
	echo MATCH
else
	echo FAILED
fi

# http://askubuntu.com/questions/385264/dump-md5-and-sha1-checksums-with-a-single-command

