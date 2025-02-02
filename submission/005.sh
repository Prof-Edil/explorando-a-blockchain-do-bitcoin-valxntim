#!/bin/bash

# This script creates a 1-of-4 Pay-to-Script-Hash (P2SH) multisig address 
# using the public keys extracted from the inputs of the specified Bitcoin transaction.

# Transaction ID (TXID) of the Bitcoin transaction to analyze
TRANSACTION_ID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Fetch the full transaction details in JSON format using `getrawtransaction`
TRANSACTION_JSON=$(bitcoin-cli getrawtransaction "$TRANSACTION_ID" true)

# Extract all public keys from the first 4 inputs using `jq`
PUBLIC_KEYS=($(echo "$TRANSACTION_JSON" | jq -r '.vin[0:4][] | .txinwitness[1]'))

# Create a 1-of-4 multisig address using the extracted public keys
MULTISIG_ADDRESS=$(bitcoin-cli createmultisig 1 "[\"${PUBLIC_KEYS[0]}\", \"${PUBLIC_KEYS[1]}\", \"${PUBLIC_KEYS[2]}\", \"${PUBLIC_KEYS[3]}\"]" legacy | jq -r .address)

# Output the generated P2SH multisig address
echo $MULTISIG_ADDRESS