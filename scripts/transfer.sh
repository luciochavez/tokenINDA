#!/bin/bash
echo "💸 Transfiriendo tokens..."
dfx canister call tokenINDA transfer '("$1", "$2", $3)'
