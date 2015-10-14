#!/bin/sh

# Usage: get_entry <storedir> <entryname> <privatekey>
#
# Entschluesselt den gegebenen Eintrag aus dem Store auf stdout 


. $(dirname $0)/storelib.sh

STORE_DIR=$1
ENTRY_NAME=$2  
PRIVATE_KEY_FILE=$3  

FP=$(cat $PRIVATE_KEY_FILE | getPublicKey | getFingerprint)

ENTRY_ENC_FILE=$STORE_DIR/$ENTRY_NAME
ENTRY_KEY_FILE=$STORE_DIR/keys-$FP/$ENTRY_NAME.key

decryptFile $PRIVATE_KEY_FILE $ENTRY_ENC_FILE $ENTRY_KEY_FILE
