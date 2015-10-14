#!/bin/sh

# Integration test scenario for credential store operations

SCRIPTS_LOCATION=./src/main/scripts

TEST_TARGET=./target/test
TEST_STORE=$TEST_TARGET/store
TEST_KEYS=$TEST_TARGET/keys

assertEquals() {
  if [ "$1" == "$2" ]; then
    echo "Value as expected: $2."
  else
    echo "Expected $1, but was $2."
    exit 1
  fi
}


echo === Setup ===

rm -rf $TEST_TARGET
mkdir -p $TEST_TARGET
mkdir $TEST_STORE
mkdir $TEST_KEYS

echo === Create Keypairs ===

mkdir $TEST_KEYS/keysA
sh $SCRIPTS_LOCATION/create_keypair.sh $TEST_KEYS/keysA
KEY_A_PUBLIC=$(ls $TEST_KEYS/keysA/public-*)
KEY_A_PRIVATE=$(ls $TEST_KEYS/keysA/private-*)

mkdir $TEST_KEYS/keysB
sh $SCRIPTS_LOCATION/create_keypair.sh $TEST_KEYS/keysB
KEY_B_PUBLIC=$(ls $TEST_KEYS/keysB/public-*)
KEY_B_PRIVATE=$(ls $TEST_KEYS/keysB/private-*)

mkdir $TEST_KEYS/keysC
sh $SCRIPTS_LOCATION/create_keypair.sh $TEST_KEYS/keysC
KEY_C_PUBLIC=$(ls $TEST_KEYS/keysC/public-*)
KEY_C_PRIVATE=$(ls $TEST_KEYS/keysC/private-*)


echo === Add keys to empty store ===

sh $SCRIPTS_LOCATION/add_key.sh $TEST_STORE $KEY_A_PUBLIC
sh $SCRIPTS_LOCATION/add_key.sh $TEST_STORE $KEY_B_PUBLIC $KEY_A_PRIVATE


echo === Add entry ===

echo "geheim1111" | sh $SCRIPTS_LOCATION/put_entry.sh $TEST_STORE com.example.credential1 


echo === Read entry with diffent keys ===

assertEquals "geheim1111" $(sh $SCRIPTS_LOCATION/get_entry.sh $TEST_STORE com.example.credential1 $KEY_A_PRIVATE)
assertEquals "geheim1111" $(sh $SCRIPTS_LOCATION/get_entry.sh $TEST_STORE com.example.credential1 $KEY_B_PRIVATE)


echo === Add another keypairs ===

sh $SCRIPTS_LOCATION/add_key.sh $TEST_STORE $KEY_C_PUBLIC $KEY_A_PRIVATE


echo === Read existing entry with new key ===

assertEquals "geheim1111" $(sh $SCRIPTS_LOCATION/get_entry.sh $TEST_STORE com.example.credential1 $KEY_C_PRIVATE)


echo === Add another entry and read with all keys ===

echo "topsecret6723" | sh $SCRIPTS_LOCATION/put_entry.sh $TEST_STORE com.example.credential2 
assertEquals "topsecret6723" $(sh $SCRIPTS_LOCATION/get_entry.sh $TEST_STORE com.example.credential2 $KEY_A_PRIVATE)
assertEquals "topsecret6723" $(sh $SCRIPTS_LOCATION/get_entry.sh $TEST_STORE com.example.credential2 $KEY_B_PRIVATE)
assertEquals "topsecret6723" $(sh $SCRIPTS_LOCATION/get_entry.sh $TEST_STORE com.example.credential2 $KEY_C_PRIVATE)
