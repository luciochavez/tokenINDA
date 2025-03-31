import Token "token";
import Principal "mo:base/Principal";

shared ({ caller = _owner }) actor class Token({
  icrc1_init_args = {
    name = "INDA Token";
    symbol = "INDA";
    decimals = 8;
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
  fee_distribution_percentages : {
    toBurn : Nat; 
    pooles: [Types.FeeAllocationPercentages]
  };
  
});
