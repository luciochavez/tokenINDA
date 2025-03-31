import Token "token";
import Principal "mo:base/Principal";

shared ({ caller = _owner }) actor class Token({
  icrc1_init_args = {
    name = "INDA Token";
    symbol = "INDA";
    decimals = 6;
    fee = ? #Fixed(10_000); // 0.01 INDA
    //metadata = [];
    minting_account = null;
    //initial_balances = [];
    archive_options = null;
  };

  icrc2_init_args = {
    maximum_approvals_per_account = ?20;
    maximum_approvals = ?100;
    fee = null;
  };

  initial_distribution : [Types.HolderCategory];
 initial_distribution : [
    {
      categoryName = "Indasocial Community";
      holders = [
        { owner = Principal.fromText("aaaaa-aa"); subaccount = null }
      ];
      allocatedAmount = 1_050_000;
      blockingDays = 730;
    },
    {
      categoryName = "Liquidity";
      holders = [
        { owner = Principal.fromText("bbbbb-bb"); subaccount = null }
      ];
      allocatedAmount = 1_200_000;
      blockingDays = 0;
    },
    {
      categoryName = "Team and Development";
      holders = [
        { owner = Principal.fromText("ccccc-cc"); subaccount = null }
      ];
      allocatedAmount = 300_000;
      blockingDays = 540;
    },
    {
      categoryName = "Investors and Partnerships";
      holders = [
        { owner = Principal.fromText("ddddd-dd"); subaccount = null }
      ];
      allocatedAmount = 450_000;
      blockingDays = 365;
    }
  ];

  fee_distribution_percentages : {
    toBurn = 30000; // 1% de 0.01 INDA = 0.0001
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
