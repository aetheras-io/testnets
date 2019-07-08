#!/bin/bash
read -p "Completely uninstall agora? (all local chain data will be deleted) [Y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf ${HOME}/.agora >/dev/null
    rm -rf /usr/local/bin/agora >/dev/null
fi
