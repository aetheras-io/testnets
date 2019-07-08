#!/bin/bash

NETWORK=0000_NOBITA
RELEASE=v0.5.0
WORK_DIR=${AGORA_HOME:-$HOME}
PUBLIC_PEER=8c7eedf6e406388b251feebabda7656a55b3bfd3@35.201.233.223:26656

printf 'info: %s\n' "installing agora ${NETWORK}" 1>&2
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    ARCH=linux.amd64
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ARCH=darwin.amd64
else
    echo "Unsupported operating system ${OSTYPE}"
fi

function main() {
    set -e
    need_cmd chmod
    need_cmd ln
    need_cmd popd
    need_cmd pushd

    local _genesisUrl="https://raw.githubusercontent.com/aetheras-io/testnets/master/${NETWORK}/genesis.json"
    local _release="https://github.com/aetheras-io/testnets/releases/download/${RELEASE}/agora.${ARCH}"
    local _uninstall="https://raw.githubusercontent.com/aetheras-io/testnets/master/scripts/uninstall.sh"

    tmp=$(mktemp -d)
    pushd ${tmp} >/dev/null

    printf 'info: %s\n' "detected ${ARCH}" 1>&2
    printf 'info: %s\n' 'downloading files' 1>&2
    downloader ${_genesisUrl} genesis.json
    downloader ${_release} agora
    downloader ${_uninstall} uninstall

    printf 'info: %s\n' "installing to ${WORK_DIR}/.agora"
    chmod u+x ./agora
    chmod u+x ./uninstall
    ./agora init ${HOSTNAME} --chain-id ${NETWORK} 2>/dev/null
    rm ${WORK_DIR}/.agora/config/genesis.json
    mkdir -p ${WORK_DIR}/.agora/bin
    mv genesis.json ${WORK_DIR}/.agora/config/genesis.json
    mv agora ${WORK_DIR}/.agora/bin
    mv uninstall ${WORK_DIR}/.agora/bin
    ln -s ${WORK_DIR}/.agora/bin/agora /usr/local/bin/agora

    popd >/dev/null
    printf 'info: %s\n' 'install complete'
    printf 'info: %s\n' "please add ${WORK_DIR}/.agora/bin to your PATH"
    printf 'info: %s\n' "to join the network, add \"${PUBLIC_PEER}\" to \"${WORK_DIR}/.agora/config/config.toml\" for \"p2p.persistent_peers\""
}

need_cmd() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# This wraps curl or wget. Try curl first, if not installed,
# use wget instead.
downloader() {
    need_cmd curl
    curl --proto '=https' --tlsv1.2 --silent --show-error --fail --location "$1" --output "$2"
}

main "$@"
