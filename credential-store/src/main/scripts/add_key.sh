#!/bin/sh

# Usage: add_publickey <storedir> <publickey> [<privatekey>]
#
# Fuegt einen neuen public Key zu dem Store hinzu. Sofern der Store bereits Einträge enthält,
# ist ein privater Key eines bereits bekannten public Keys erforderlich, um die bestehenden
# Einträge mit dem neuen Key zu verschluesseln.


. $(dirname $0)/storelib.sh

STORE_DIR=$1
PUBLIC_KEY_FILE=$2  
PRIVATE_KEY_FILE=$3

TARGET_FP=$(cat $PUBLIC_KEY_FILE | getFingerprint)
TARGET_KEYS_DIR=$STORE_DIR/keys-$TARGET_FP
mkdir $TARGET_KEYS_DIR
cp $PUBLIC_KEY_FILE $TARGET_KEYS_DIR/public.pem

if [ -z "$PRIVATE_KEY_FILE" ]; then
  echo "no private key provided, existing entries cannot be copied"
  exit 0
fi

SOURCE_FP=$(cat $PRIVATE_KEY_FILE | getPublicKey | getFingerprint)
SOURCE_KEYS_DIR=$STORE_DIR/keys-$SOURCE_FP
for SOURCE_KEY_FILE in $(ls $SOURCE_KEYS_DIR/*.key 2> /dev/null); do
  KEY_NAME=$(echo "$SOURCE_KEY_FILE" | sed 's/\.key$//' | sed 's/^.*\///')
  TARGET_KEY_FILE=$TARGET_KEYS_DIR/$KEY_NAME.key
  echo "copy key $KEY_NAME"
  cat $SOURCE_KEY_FILE | decryptKey $PRIVATE_KEY_FILE  | encryptKey $PUBLIC_KEY_FILE > $TARGET_KEY_FILE
done
