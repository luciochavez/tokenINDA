import Token "token";
import Types "types";
import Principal "mo:base/Principal";

actor {
  public let indaToken = Token({
    icrc1_init_args = {
      name = "INDA Token";
      symbol = "INDA";
      decimals = 6;
      fee = ? #Fixed(10_000); // 0.01 INDA por tx
      metadata = [];
      minting_account = null; // Se asigna dinámicamente al owner del canister
      initial_balances = [];
      archive_options = null;
    };

    icrc2_init_args = {
      maximum_approvals_per_account = ?20;
      maximum_approvals = ?100;
      fee = null;
    };

    initial_distribution = [
      {
        categoryName = "Indasocial Comunidad";
        holders = [
          { owner = Principal.fromText("aaaaa-aa"); subaccount = null }
        ];
        allocatedAmount = 1_050_000;
        blockingDays = 730; // 24 meses
      },
      {
        categoryName = "Liquidez";
        holders = [
          { owner = Principal.fromText("bbbbb-bb"); subaccount = null }
        ];
        allocatedAmount = 1_200_000;
        blockingDays = 0;
      },
      {
        categoryName = "Equipo y Desarrollo";
        holders = [
          { owner = Principal.fromText("ccccc-cc"); subaccount = null }
        ];
        allocatedAmount = 300_000;
        blockingDays = 540; // 18 meses
      },
      {
        categoryName = "Inversores y Alianzas";
        holders = [
          { owner = Principal.fromText("ddddd-dd"); subaccount = null }
        ];
        allocatedAmount = 450_000;
        blockingDays = 365; // 12 meses
      }
    ];

    fee_distribution_percentages = {
      // reciclar???
      toBurn = 30_000; // 0.03 INDA, el 1% real si fee = 0.01
      pooles = [
        {
          name = "DAO Pool";
          to = { owner = Principal.fromText("eeee-eee"); subaccount = null };
          percentage = 200; // 2%
        },
        {
          name = "Marketing";
          to = { owner = Principal.fromText("ffff-fff"); subaccount = null };
          percentage = 100; // 1%
        }
      ];
    };
  });
};
