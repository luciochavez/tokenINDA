# 🏆 INDA Token - ICRC-2 en Internet Computer

Este repositorio contiene la implementación del **token INDA**, basado en el estándar **ICRC-2**, desarrollado en **Motoko** y desplegado en **Internet Computer (ICP)**.  

## 📌 Características del Token
- ✅ **ICRC-2 Compatible**: Compatible con wallets y DEX que soportan este estándar.
- 🏗 **Construido en Motoko**: Código seguro y optimizado para **Internet Computer**.
- 🔧 **Desplegable en ICP**: Puede ejecutarse en la red principal o localmente.
- 💰 **Transferencias seguras**: Permite transacciones con validaciones de saldo.

---

## 📂 Estructura del Proyecto

```bash
📦 tokenINDA
 ┣ 📂 src               # 📜 Código del token en Motoko
 ┃ ┣ 📜 token.mo        # Token
 ┃ ┣ 📜 types.mo        # types
 ┃ ┣ 📜 main.mo         # main
 ┣ 📂 scripts           # 🔧 Scripts para despliegue e interacción
 ┃ ┣ 📜 deploy.sh       # Desplegar el token en ICP
 ┃ ┣ 📜 transfer.sh     # Transferir tokens
 ┃ ┗ 📜 check_balance.sh # Consultar saldo
 ┣ 📂 tests             # ✅ Pruebas automatizadas
 ┃ ┗ 📜 test_token.mo   # Test unitario para el token
 ┣ 📂 docs              # 📄 Documentación del proyecto
 ┃ ┗ 📜 architecture.md # Explicación técnica del ecosistema
 ┣ 📜 dfx.json          # Configuración de DFX
 ┣ 📜 mops.toml         # Dependencias de Mops
 ┣ 📜 .gitignore        # Archivos a ignorar en Git
 ┗ 📜 LICENSE           # Licencia del proyecto
```

## 🖥️ Estado del Nodo ICP Local (`dfx ping local`)

 Ejecutando el comando:
 ```bash
 dfx ping local
63, 238, 162, 84, 41, 17, 249, 248]          }
     ```
