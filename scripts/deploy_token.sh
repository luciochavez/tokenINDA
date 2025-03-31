//comando para extraer la mime-type del archivo de imagen del logo y convertir a base64 con la mime insertada:
echo -n "data:$(file --mime-type -b logo.svg);base64," > logo.txt && base64 -w 0 logo.svg >> logo.txt`
// ejemplo de salida -> data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgoKPHN2ZwogICB3aWR0aD0iNzYuNDg4NzkybW0iCiAgIGhlaWdodD0iODYuNDU0NjEzbW0iCiAgIHZpZXdCb3g9IjAgMCA3Ni40ODg3OTIgODYuNDU0NjE0IgogICB2ZXJzaW9uPSIxLjEiCiAgIGlkPSJzdmc1IgogICBpbmtzY2FwZTp2ZXJzaW9uPSIxLjEuMiAoMGEwMGNmNTMzOSwgMjAyMi0wMi0wNCkiCiAgIHNvZGlwb2RpOmRvY25hbWU9ImxvZ28uc3ZnIgogICB4bWxuczppbmtzY2FwZT0iaHR0cDovL3d3dy5pbmtzY2FwZS5vcmcvbmFtZXNwYWNlcy9pbmtzY2FwZSIKICAgeG1sbnM6c29kaXBvZGk9Imh0dHA6Ly9zb2RpcG9kaS5zb3VyY2Vmb3JnZS5uZXQvRFREL3NvZGlwb2RpLTAuZHRkIgogICB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxzb2RpcG9kaTpuYW1lZHZpZXcKICAgICBpZD0ibmFtZWR2aWV3NyIKICAgICBwYWdlY29sb3I9IiNmZmZmZmYiCiAgICAgYm9yZGVyY29sb3I9IiM2NjY2NjYiCiAgICAgYm9yZGVyb3BhY2l0eT0iMS4wIgogICAgIGlua3NjYXBlOnBhZ2VzaGFkb3c9IjIiCiAgICAgaW5rc2NhcGU6cGFnZW9wYWNpdHk9IjAuMCIKICAgICBpbmtzY2FwZTpwYWdlY2hlY2tlcmJvYXJkPSJmYWxzZSIKICAgICBpbmtzY2FwZTpkb2N1bWVudC11bml0cz0ibW0iCiAgICAgc2hvd2dyaWQ9ImZhbHNlIgogICAgIGlua3NjYXBlOnpvb209IjEuMDI5MjE2MiIKICAgICBpbmtzY2FwZTpjeD0iMTI1LjgyMzkxIgogICAgIGlua3NjYXBlOmN5PSIxNDkuNjI4NDMiCiAgICAgaW5rc2NhcGU6d2luZG93LXdpZHRoPSIxMDM1IgogICAgIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijc3OCIKICAgICBpbmtzY2FwZTp3aW5kb3cteD0iNTAiCiAgICAgaW5rc2NhcGU6d2luZG93LXk9IjExNjkiCiAgICAgaW5rc2NhcGU6d2luZG93LW1heGltaXplZD0iMCIKICAgICBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjEiCiAgICAgaW5rc2NhcGU6c25hcC1ncmlkcz0iZmFsc2UiCiAgICAgYm9yZGVybGF5ZXI9ImZhbHNlIgogICAgIHNob3dib3JkZXI9InRydWUiCiAgICAgaW5rc2NhcGU6c2hvd3BhZ2VzaGFkb3c9ImZhbHNlIgogICAgIGZpdC1tYXJnaW4tdG9wPSIwIgogICAgIGZpdC1tYXJnaW4tbGVmdD0iMCIKICAgICBmaXQtbWFyZ2luLXJpZ2h0PSIwIgogICAgIGZpdC1tYXJnaW4tYm90dG9tPSIwIiAvPgogIDxkZWZzCiAgICAgaWQ9ImRlZnMyIiAvPgogIDxnCiAgICAgaW5rc2NhcGU6bGFiZWw9IkNhcGEgMSIKICAgICBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIgogICAgIGlkPSJsYXllcjEiCiAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTI3Ljk2Nzc5NSwtNDIuOTYxMTQ1KSI+CiAgICA8cGF0aAogICAgICAgc29kaXBvZGk6dHlwZT0ic3RhciIKICAgICAgIHN0eWxlPSJmaWxsOiMwMGZmZmY7ZmlsbC1vcGFjaXR5OjA7c3Ryb2tlOiMzN2Q2ZWE7c3Ryb2tlLXdpZHRoOjE5LjE0MzM7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS1taXRlcmxpbWl0OjQ7c3Ryb2tlLWRhc2hhcnJheTpub25lO3N0cm9rZS1vcGFjaXR5OjEiCiAgICAgICBpZD0icGF0aDg4NDQiCiAgICAgICBpbmtzY2FwZTpmbGF0c2lkZWQ9InRydWUiCiAgICAgICBzb2RpcG9kaTpzaWRlcz0iNiIKICAgICAgIHNvZGlwb2RpOmN4PSIxMTQuNTM3MTgiCiAgICAgICBzb2RpcG9kaTpjeT0iMzA1Ljk3OTgzIgogICAgICAgc29kaXBvZGk6cjE9Ijc3Ljc2MzQ5NiIKICAgICAgIHNvZGlwb2RpOnIyPSI2Ny4zNDUxNjEiCiAgICAgICBzb2RpcG9kaTphcmcxPSIwLjUxNjcwNDgyIgogICAgICAgc29kaXBvZGk6YXJnMj0iMS4wNDAzMDM2IgogICAgICAgaW5rc2NhcGU6cm91bmRlZD0iMCIKICAgICAgIGlua3NjYXBlOnJhbmRvbWl6ZWQ9IjAiCiAgICAgICB0cmFuc2Zvcm09Im1hdHJpeCgwLjI2NDU4MzMzLDAsMCwwLjI2NDU4MzMzLDE4LjA4NDU3LC01Ljc3ODg2MzYpIgogICAgICAgaW5rc2NhcGU6dHJhbnNmb3JtLWNlbnRlci15PSItMS4wMTk5MzI4ZS0wNiIKICAgICAgIGQ9Im0gMTgyLjE0ODc5LDM0NC4zOTYzOCAtNjcuMDc1NTIsMzkuMzQ1MSAtNjcuNjExNjA4LC0zOC40MTY1NiAtMC41MzYwOTQsLTc3Ljc2MTY1IDY3LjA3NTUxMiwtMzkuMzQ1MDkgNjcuNjExNjEsMzguNDE2NTUgeiIgLz4KICAgIDxwYXRoCiAgICAgICBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMzdkNmVhO3N0cm9rZS13aWR0aDo1LjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjptaXRlcjtzdHJva2UtbWl0ZXJsaW1pdDo0O3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtzdHJva2Utb3BhY2l0eToxIgogICAgICAgZD0iTSA2Ni4yNzgxMDMsODUuMzQyNjc2IDg0LjE2NzAwNSw5NS41MDcwNTcgMTAxLjkxNDA3LDg1LjA5NyAxMDEuNzcyMjMsNjQuNTIyNTYzIDgzLjg4MzMyNCw1NC4zNTgxODUiCiAgICAgICBpZD0icGF0aDIxNjE5IiAvPgogICAgPHBhdGgKICAgICAgIHN0eWxlPSJmaWxsOm5vbmU7c3Ryb2tlOiMzN2Q2ZWE7c3Ryb2tlLXdpZHRoOjUuMDY1O3N0cm9rZS1saW5lY2FwOmJ1dHQ7c3Ryb2tlLWxpbmVqb2luOm1pdGVyO3N0cm9rZS1taXRlcmxpbWl0OjQ7c3Ryb2tlLWRhc2hhcnJheTpub25lO3N0cm9rZS1vcGFjaXR5OjEiCiAgICAgICBkPSJtIDQ4LjUzMTAzOSw5NS43NTI3MzQgMC4xNDE4NCwyMC41NzQ0MzYgYyAwLDAgMTcuODg4OTA1LDEwLjE2NDM4IDE3Ljg4ODkwNSwxMC4xNjQzOCBsIDE3Ljc0NzA2NCwtMTAuNDEwMDYiCiAgICAgICBpZD0icGF0aDIxNzM0IiAvPgogICAgPGVsbGlwc2UKICAgICAgIHN0eWxlPSJmaWxsOm5vbmU7ZmlsbC1ydWxlOmV2ZW5vZGQ7c3Ryb2tlOiMzN2Q2ZWE7c3Ryb2tlLXdpZHRoOjUuMDY1O3N0cm9rZS1taXRlcmxpbWl0OjQ7c3Ryb2tlLWRhc2hhcnJheTpub25lO3N0cm9rZS1vcGFjaXR5OjEiCiAgICAgICBpZD0icGF0aDI3NDYyIgogICAgICAgY3g9IjkwLjI2NDgwMSIKICAgICAgIGN5PSIxMTIuMzI3MzQiCiAgICAgICByeD0iNS4wNjQyOTUzIgogICAgICAgcnk9IjUuMTU3NjM4MSIgLz4KICAgIDxlbGxpcHNlCiAgICAgICBzdHlsZT0iZmlsbDpub25lO2ZpbGwtcnVsZTpldmVub2RkO3N0cm9rZTojMzdkNmVhO3N0cm9rZS13aWR0aDo1LjA2NTtzdHJva2UtbWl0ZXJsaW1pdDo0O3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtzdHJva2Utb3BhY2l0eToxIgogICAgICAgaWQ9InBhdGgyNzQ2Mi02IgogICAgICAgY3g9Ijc3Ljc2MzAwOCIKICAgICAgIGN5PSI1MC42NTEyODMiCiAgICAgICByeD0iNS4wNjQyOTUzIgogICAgICAgcnk9IjUuMTU3NjM4MSIgLz4KICA8L2c+Cjwvc3ZnPgo=
// Nota importante, Si se establece un porcentage del fee para la quema, hay que establecer el parametro min_burn_amount en el deploy
// con un valor menor o igual al valor en tokens correspondiente a ese porcentage para un Fee
// Ejemplo si el fee es de 10_000 y el porcentage de ese fee asignado a la quema es de 12.5% (1250) el valor de min_burn_amount tiene que ser
// menor a 1250. De lo contrario falla la quema y el porcentaje correspondiente queda en posecion del usuario

// Ejemplo de envio de parametros de deploy

dfx deploy ICRC_template_backend --argument '(
  record {
    initial_distribution = vec {
      record {
        name = "Founders";
        allocatedAmount = 100_000_000_000 : nat;
        holders = vec {
          record {
            owner = principal "abcde-hijkl...";
            subaccount = null;
          };
        };
        blockingDays = 40 : nat;
      };
      record {
        name = "Investors";
        allocatedAmount = 500_000_000_000 : nat;
        holders = vec {
          record {
            owner = principal "abcde-hijkl...";
            subaccount = null;
          };
        };
        blockingDays = 30 : nat;
      };
    };
    icrc1_init_args = record {
      fee = opt variant { Fixed = 10_000 : nat };
      advanced_settings = null;
      max_memo = opt (32 : nat);
      decimals = 8 : nat8;
      metadata = null;
      minting_account = opt record {
        owner = principal "abcde-hijkl...";
        subaccount = null;
      };
      logo = opt "data:image/svg+xml;base64,PD94REL3Mw...3ZnPgo=";
      permitted_drift = null;
      name = opt "Template";
      settle_to_accounts = null;
      fee_collector = opt record {
        owner = principal "abcde-hijkl...";
        subaccount = null;
      };
      transaction_window = null;
      min_burn_amount = opt (100_000 : nat);
      max_supply = null;
      max_accounts = null;
      symbol = opt "TT";
    };
    fee_distribution_percentages = record {
      toBurn = 2_500 : nat;
      pooles = vec {};
    };
    icrc2_init_args = record {
      fee = opt variant { Fixed = 10_000 : nat };
      advanced_settings = null;
      max_allowance = null;
      max_approvals = null;
      max_approvals_per_account = null;
      settle_to_approvals = null;
    };
  },
)'

// Para iniciar la distribucion, desde el deployer del token 
dfx canister call ICRC_template_backend distribution_info