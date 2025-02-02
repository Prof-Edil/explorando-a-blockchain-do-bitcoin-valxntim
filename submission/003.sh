# How many new outputs were created by block 123,456?
#!/bin/bash

# Block number to query
BLOCK=123456

# Get the block hash using the block number
BLOCK_HASH=$(bitcoin-cli getblockhash $BLOCK)

# Get the block details
BLOCK_DETAILS=$(bitcoin-cli getblock $BLOCK_HASH)

# Initialize a counter for the outputs
OUTPUT_COUNT=0

# Loop through each transaction in the block and count the outputs
for TXID in $(echo $BLOCK_DETAILS | jq -r '.tx[]'); do
  # Get the raw transaction details
  RAW_TXN=$(bitcoin-cli getrawtransaction "$TXID" true)

  # Count the outputs in the transaction
  NUM_OUTPUTS=$(echo $RAW_TXN | jq '.vout | length')

  # Add to the total output count
  OUTPUT_COUNT=$((OUTPUT_COUNT + NUM_OUTPUTS))
done

# Output the total number of new outputs
echo $OUTPUT_COUNT

