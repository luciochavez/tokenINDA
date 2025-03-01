#!/bin/bash

echo "🚀 Configurando la estructura del repositorio tokenINDA..."

# Crear carpetas
mkdir -p src/contracts
mkdir -p scripts
mkdir -p tests
mkdir -p docs

# Crear archivos base
touch src/contracts/Token.mo
touch scripts/deploy.sh
touch scripts/transfer.sh
touch scripts/check_balance.sh
touch tests/test_token.mo
touch docs/README.md
touch docs/architecture.md
touch .gitignore
touch LICENSE
touch dfx.json
touch mops.toml

# Escribir contenido en cada archivo
echo 'import ICRC2 "mo:icrc2-mo";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor Token {
    let token = ICRC2.Token({
        name = "INDA Token";
        symbol = "INDA";
        decimals = 8;
        initialSupply = 1_000_000_000;
        owner = Principal.fromText("aaaaa-aa");
    });

    public query func balanceOf(account : Text) : async Nat {
        token.balanceOf(account)
    };

    public func transfer(from: Text, to: Text, amount: Nat) : async Bool {
        token.transfer(from, to, amount)
    };
}' > src/contracts/Token.mo

echo '#!/bin/bash
echo "📦 Desplegando token INDA..."
dfx deploy --network ic' > scripts/deploy.sh

echo '#!/bin/bash
echo "💸 Transfiriendo tokens..."
dfx canister call tokenINDA transfer '"'"'("$1", "$2", $3)'"'"'' > scripts/transfer.sh

echo '#!/bin/bash
echo "🔎 Consultando saldo..."
dfx canister call tokenINDA balanceOf '"'"'("$1")'"'"'' > scripts/check_balance.sh

echo 'import Debug "mo:base/Debug";
import Token "mo:contracts/Token";

actor {
  public func testBalance() : async () {
    let balance = await Token.balanceOf("aaaaa-aa");
    Debug.print("Saldo: " # debug_show(balance));
  };
};' > tests/test_token.mo

echo '# tokenINDA
Este repositorio contiene el contrato inteligente del token INDA basado en el estándar ICRC-2.
' > docs/README.md

echo '{
  "canisters": {
    "tokenINDA": {
      "main": "src/contracts/Token.mo",
      "type": "motoko"
    }
  }
}' > dfx.json

echo '[dependencies]
icrc2-mo = "latest"' > mops.toml

# Dar permisos de ejecución a los scripts
chmod +x scripts/*.sh

echo "🚀 Estructura creada correctamente."
echo "💾 Los scripts están listos para ejecutarse."
