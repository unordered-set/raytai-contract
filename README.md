# RayTai NFT

## Deployment

```
export RPC_URL=<Your RPC endpoint>
export PRIVATE_KEY=<Your wallets private key>

forge create RayTaiNFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY \
--constructor-args \
"RayTai" "RATA" "dc7a451e18cea32d0f7d9b19afb264ad3effd8e2a837d1077be037390471f979" \
"25000000000000000" "33000000000000000" \
"2" "3" \
"3333"  \
30168306 \
--gas-limit 2000000 --gas-price 5361452348 --priority-gas-price 5361452348
```

## Testing
Mumbai: 0xc528617A0Eb835022d2c75719A526E0624195F63

AL:
```
    "0x1904166894a3b50764F165175599AEDD3C9c29Ce",
    "0x1904166894a3b50764F165175599AEDD3C9c29Cd",
    "0x1904166894a3b50764F165175599AEDD3C9c29Cc",
```