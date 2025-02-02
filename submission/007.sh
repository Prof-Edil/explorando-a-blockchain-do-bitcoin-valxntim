#!/bin/sh

BLOCKHASH=$(bitcoin-cli getblockhash 123321)
readarray -t TRANSACTIONS < <(bitcoin-cli getblock $BLOCKHASH | jq -r '.tx[]')

# Skip coinbase transaction (first in array)
for TXID in "${TRANSACTIONS[@]:1}"
do  
    TX=$(bitcoin-cli getrawtransaction "$TXID" 1 | jq -c .)
    readarray -t OUTPUTS < <(echo "$TX" | jq -c '.vout[]')

    for OUTPUT in "${OUTPUTS[@]}"
    do
        VOUT_INDEX=$(echo "$OUTPUT" | jq -r '.n')
        UNSPENT=$(bitcoin-cli gettxout "$TXID" "$VOUT_INDEX")

        if [[ -n "$UNSPENT" ]]; then
            # Handle P2PK (pubkey) and P2PKH (address) outputs
            SPK=$(echo "$UNSPENT" | jq '.scriptPubKey')
            case $(echo "$SPK" | jq -r '.type') in
                "pubkey")
                    echo "$SPK" | jq -r '.asm | split(" ")[0]'
                    exit 0
                    ;;
                "pubkeyhash")
                    echo "$SPK" | jq -r '.address'
                    exit 0
                    ;;
            esac
        fi
    done
done

echo "No unspent output found" >&2
exit 1