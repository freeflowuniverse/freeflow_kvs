#!/bin/sh

rm config data -rf
TMHOME="." tendermint init
./tm2rmb -config config/config.toml -twin 12 -app myapp
