#!/bin/sh

generatePrivateKey() {
  # Erzeugt einen neuen 4096 Bit RSA Private Key im PEM Format
  openssl genrsa 4096
}

getPublicKey() {
  # Extrahiert den Public Key aus einem RSA Private Key im PEM Format
  openssl rsa -pubout
}

getFingerprint() {
  # Ermittelt den SHA1-Fingerprint eines PEM-codierten public Keys
  openssl rsa -pubin -pubout -outform DER | openssl sha1 | sed 's/^.* //'
}

generateFileKey() {
  # Erzeugt einen neuen File-Key
  openssl rand -hex 32
}

encryptKey() {
  # Verschluesselt den File Key von stdin mit dem gegebenen Public Key
  # @param $1 Public Key File
  openssl rsautl -encrypt -inkey $1 -pubin
}

decryptKey() {
  # Entschluesselt den File Key mit dem gegebenen Private Key
  # @param $1 Private Key File
  openssl rsautl -decrypt -inkey $1
}

encryptFile() {
  # Verschluesselt den Input von stdin mit dem gegebenen File Key
  # @param $1 File Key
  # @param $2 Speicherort der verschluesselten Datei
  export FILE_KEY="$1"
  openssl enc -aes-256-cbc -salt -out $2 -pass env:FILE_KEY
  export -n FILE_KEY
}

decryptFile() {
  # Entschluesselt mit dem gegebenen private Key
  # @param $1 PEM-codierte private Keydatei
  # @param $2 Speicherort der verschluesselten Datei
  # @param $3 Speicherort des veschluesselten Dateischluessels
  
  cat $3 | decryptKey $1 | openssl enc -d -aes-256-cbc -in $2 -pass stdin
}



