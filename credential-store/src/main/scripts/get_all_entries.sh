#!/bin/sh

# Usage: get_all_entries <storedir> <targetdir> <privatekey>
#
# Entschluesselt alle Eintraege in das gegebene Verzeichnis 


. $(dirname $0)/storelib.sh

STORE_DIR=$1
TARGET_DIR=$2  
PRIVATE_KEY_FILE=$3  

FP=$(cat $PRIVATE_KEY_FILE | getPublicKey | getFingerprint)

for ENTRY_NAME in $(ls $STORE_DIR 2> /dev/null); do
  ENTRY_ENC_FILE=$STORE_DIR/$ENTRY_NAME
  if [ -f "$ENTRY_ENC_FILE" ]; then
    ENTRY_KEY_FILE=$STORE_DIR/keys-$FP/$ENTRY_NAME.key
    ENTRY_PLAIN_FILE=$TARGET_DIR/$ENTRY_NAME
    decryptFile $PRIVATE_KEY_FILE $ENTRY_ENC_FILE $ENTRY_KEY_FILE > $ENTRY_PLAIN_FILE
  fi
done
