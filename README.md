# Agora Testnets

To Automatically Install:

```curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/aetheras-io/testnets/master/scripts/get-agora.sh | sh```

### Testnet 0000_NOBITA

Manual Installation Steps

```sh
# Initialize Agora
agora init ${NODE_NAME} --chain-id "0000_NOBITA"

# Get the latest Genesis file
mkdir -p ~/.agora/config
curl https://raw.githubusercontent.com/aetheras-io/testnets/master/0000_NOBITA/genesis.json > ~/.agora/config/genesis.json

# Add Public Sentry Peer to config.toml's persistent peer list
[p2p]
persistent_peers = "8c7eedf6e406388b251feebabda7656a55b3bfd3@35.201.233.223:26656"
```
