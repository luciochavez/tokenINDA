///This is a naieve token implementation and shows the minimum possible implementation. It does not provide archiving and will not scale.
///Please see https://github.com/PanIndustrial-Org/ICRC_fungible for a full featured implementation


import ExperimentalCycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "..";

shared ({ caller = _owner }) actor class Token  (
    init_args1 : ICRC1.InitArgs,
    init_args2 : ICRC2.InitArgs,
) = this{

    let icrc1_args : ICRC1.InitArgs = {
        init_args1 with minting_account = switch(
            init_args1.minting_account){
              case(?val) ?val;
              case(null) {?{
                owner = _owner;
                subaccount = null;
              }};
            };
    };

    let icrc2_args : ICRC2.InitArgs = init_args2;

    stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id), ?icrc1_args, _owner);

    let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;

    private var _icrc1 : ?ICRC1.ICRC1 = null;

    private func get_icrc1_state() : ICRC1.CurrentState {
      return icrc1_state_current;
    };

    private func get_icrc1_environment() : ICRC1.Environment {
    {
      get_time = null;
      get_fee = null;
      add_ledger_transaction = null;
      can_transfer = null;
    };
  };

    func icrc1() : ICRC1.ICRC1 {
    switch(_icrc1){
      case(null){
        let initclass : ICRC1.ICRC1 = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        _icrc1 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };



    stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id),?icrc2_args, _owner);

    let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

    private var _icrc2 : ?ICRC2.ICRC2 = null;

    private func get_icrc2_state() : ICRC2.CurrentState {
      return icrc2_state_current;
    };

    private func get_icrc2_environment() : ICRC2.Environment {
      {
        icrc1 = icrc1();
        get_fee = null;
        can_approve = null;
        can_transfer_from = null;
      };
    };

  func icrc2() : ICRC2.ICRC2 {
    switch(_icrc2){
      case(null){
        let initclass : ICRC2.ICRC2 = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

    /// Functions for the ICRC1 token standard
    public shared query func icrc1_name() : async Text {
        icrc1().name();
    };

    public shared query func icrc1_symbol() : async Text {
        icrc1().symbol();
    };

    public shared query func icrc1_decimals() : async Nat8 {
        icrc1().decimals();
    };

    public shared query func icrc1_fee() : async ICRC1.Balance {
        icrc1().fee();
    };

    public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
        icrc1().metadata()
    };

    public shared query func icrc1_total_supply() : async ICRC1.Balance {
        icrc1().total_supply();
    };

    public shared query func icrc1_minting_account() : async ?ICRC1.Account {
        ?icrc1().minting_account();
    };

    public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
        icrc1().balance_of(args);
    };

    public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
        icrc1().supported_standards();
    };

    public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
        await* icrc1().transfer(caller, args);
    };

    public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
        await* icrc1().mint(caller, args);
    };

    public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
        await*  icrc1().burn(caller, args);
    };

    public query ({ caller }) func icrc2_allowance(args: ICRC2.AllowanceArgs) : async ICRC2.Allowance {
      return icrc2().allowance(args.spender, args.account, false);
    };

    public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
        await*  icrc2().approve(caller, args);
    };

    public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
        await* icrc2().transfer_from(caller, args);
    };

    // Deposit cycles into this canister.
    public shared func deposit_cycles() : async () {
        let amount = ExperimentalCycles.available();
        let accepted = ExperimentalCycles.accept<system>(amount);
        assert (accepted == amount);
    };
};
