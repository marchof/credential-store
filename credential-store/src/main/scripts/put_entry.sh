#!/bin/sh

# Usage: put_entry <storedir> <entryname>
#
# Fuegt den Input von stdin unter dem gegebenen Namen in den Store ein.
# Der Inhalt wird mit allen im Store bekannten public Keys verschlüsselt.


. $(dirname $0)/storelib.sh

STORE_DIR=$1
ENTRY_NAME=$2

FILE_KEY=$(generateFileKey)

encryptFile "$FILE_KEY" $STORE_DIR/$ENTRY_NAME

for KEYS_DIR in $STORE_DIR/keys-*; do
  PUBLIC_KEY_FILE=$KEYS_DIR/public.pem
  ENTRY_KEY_FILE=$KEYS_DIR/$ENTRY_NAME.key
  echo "$FILE_KEY" | encryptKey $PUBLIC_KEY_FILE > $ENTRY_KEY_FILE
done