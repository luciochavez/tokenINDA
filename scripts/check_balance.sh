#!/bin/bash
echo "🔎 Consultando saldo..."
dfx canister call tokenINDA balanceOf '("$1")'
