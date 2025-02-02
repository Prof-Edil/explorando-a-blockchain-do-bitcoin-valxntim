#!/bin/sh

# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

TXID="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"
TRANSACTION=$(bitcoin-cli getrawtransaction "$TXID" 1)

# Extract the public key from the witness data (SegWit format)
# The public key is the third element in the witness array (index 2)
PUBKEY=$(echo "$TRANSACTION" | jq -r '.vin[0].txinwitness[2]')

# Remove the first 4 characters (OP_IF and OP_PUSHBYTES_33) and last 2 characters (OP_ENDIF)
PUBKEY=$(echo "$PUBKEY" | cut -c 5-70)

echo "$PUBKEY"