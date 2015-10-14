#!/bin/sh

# Usage: remove_entry <storedir> <entryname>
#
# Loescht den Eintrag mit dem gegebenen Namen im Store.


. $(dirname $0)/storelib.sh

STORE_DIR=$1
ENTRY_NAME=$2

rm $FILE_KEY $STORE_DIR/$ENTRY_NAME

for KEYS_DIR in $STORE_DIR/keys-*; do
  rm $KEYS_DIR/$ENTRY_NAME.key
done