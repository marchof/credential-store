#!/bin/sh

# Usage: create_keypair <targetdir>
#
# Erzeugt ein RSA Keypaar im gegebenen Zielverzeichnis im PEM-Format 


. $(dirname $0)/storelib.sh

TARGET_DIR=$1

PRIVATE_KEY=$(generatePrivateKey)
PUBLIC_KEY=$(getPublicKey <<< "$PRIVATE_KEY")
FP=$(getFingerprint <<< "$PUBLIC_KEY")

echo "$PRIVATE_KEY" > $TARGET_DIR/private-$FP.pem
echo "$PUBLIC_KEY" > $TARGET_DIR/public-$FP.pem




