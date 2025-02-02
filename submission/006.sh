# Which tx in block 257,343 spends the coinbase output of block 256,128?

#!/bin/bash

# Block height of the coinbase transaction
COINBASE_BLOCK_HEIGHT=256128

# Block height of the block to search for the spending transaction
SPEND_BLOCK_HEIGHT=257343

# Get the coinbase transaction ID from block 256,128
COINBASE_TXID=$(bitcoin-cli getblockhash $COINBASE_BLOCK_HEIGHT | xargs bitcoin-cli getblock | jq -r '.tx[0]')

# Get the list of transactions in block 257,343
SPEND_BLOCK_TXIDS=$(bitcoin-cli getblockhash $SPEND_BLOCK_HEIGHT | xargs bitcoin-cli getblock | jq -r '.tx[]')

# Iterate through each transaction in block 257,343
for TXID in $SPEND_BLOCK_TXIDS; do
  # Get the raw transaction details
  TX_JSON=$(bitcoin-cli getrawtransaction "$TXID" true)

  # Check if any input references the coinbase transaction
  if echo "$TX_JSON" | jq -e ".vin[] | select(.txid == \"$COINBASE_TXID\")" > /dev/null; then
    echo "$TXID"
    exit 0
  fi
done

# If no transaction is found, exit with an error
echo "No transaction in block $SPEND_BLOCK_HEIGHT spends the coinbase output of block $COINBASE_BLOCK_HEIGHT."
exit 1