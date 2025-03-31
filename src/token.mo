import ExperimentalCycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import Map "mo:map/Map";
import { ihash } "mo:map/Map";
import { now } "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Nat "mo:base/Nat";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "mo:icrc2-mo/ICRC2";
import Types "types";
import { print } "mo:base/Debug";

// Inicio del actor del token
shared ({ caller = _owner }) actor class Token({
  icrc1_init_args : ICRC1.InitArgs;
  icrc2_init_args : ICRC2.InitArgs;
  initial_distribution : [Types.HolderCategory];
  fee_distribution_percentages: { toBurn : Nat; pooles: [Types.FeeAllocationPercentages] };
}) = this {
  // -- Métodos públicos de ICRC1
  public shared query func icrc1_name() : async Text { icrc1().name() };
  public shared query func icrc1_symbol() : async Text { icrc1().symbol() };
  public shared query func icrc1_decimals() : async Nat8 { icrc1().decimals() };
  public shared query func icrc1_fee() : async ICRC1.Balance {
    icrc1().fee() + fee_distribution_percentages.toBurn;
  };
  public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] { icrc1().metadata() };
  public shared query func icrc1_total_supply() : async ICRC1.Balance { icrc1().total_supply() };
  public shared query func icrc1_minting_account() : async ?ICRC1.Account { ?icrc1().minting_account() };
  public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance { icrc1().balance_of(args) };
  public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] { icrc1().supported_standards() };

  public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
    switch (validate_transaction({ args with from = caller })) {
      case (#Ok) {
        let trxResult = await* icrc1().transfer(caller, args);
        switch trxResult {
          case (#Ok(_)) {
            ignore await* icrc1().burn(caller, { args with amount = fee_distribution_percentages.toBurn });
          };
          case _ {};
        };
        trxResult
      };
      case (#Err(err)) { #Err(err) };
    };
  };

  public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
    await* icrc1().mint(caller, args);
  };

  public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
    await* icrc1().burn(caller, args);
  };

  // -- ICRC2 (approve, allowance y transfer_from)
  public query ({ caller }) func icrc2_allowance(args : ICRC2.AllowanceArgs) : async ICRC2.Allowance {
    return icrc2().allowance(args.spender, args.account, false);
  };

  public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
    switch (validate_transaction({ args with from = caller })) {
      case (#Ok) { await* icrc2().approve(caller, args) };
      case (#Err(err)) {
        switch err {
          case (#InsufficientFunds(data)) { #Err(#InsufficientFunds(data)) };
          case (_) { #Err(#GenericError({ error_code = 0; message = "Unexpected error" })) };
        };
      };
    };
  };

  public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
    let check = validate_transaction({ from = args.from.owner; from_subaccount = args.from.subaccount; amount = args.amount });
    switch check {
      case (#Ok) {
        let trxResult = await* icrc2().transfer_from(caller, args);
        switch trxResult {
          case (#Ok(_)) {
            ignore await* icrc1().burn(args.from.owner, { args with amount = fee_distribution_percentages.toBurn });
          };
          case _ {};
        };
        trxResult
      };
      case (#Err(err)) { #Err(err) };
    };
  };

  // -- Depósito de ciclos (ICP "gas")
  public shared func deposit_cycles() : async () {
    let amount = ExperimentalCycles.available();
    let accepted = ExperimentalCycles.accept<system>(amount);
    assert (accepted == amount);
  };

  // -- Distribución inicial
  stable var distributedAmount = 0;
  stable var distribution_is_started = false;
  stable let holders_unlock_dates = Map.new<Types.Account, LockedAmount>();

  type LockedAmount = {
    unlockDate : Int;
    amount : Nat;
  };

  func _distribution() : async () {
    if (distribution_is_started) return;
    distribution_is_started := true;

    for (category in initial_distribution.vals()) {
      for (holder in category.holders.vals()) {
        let mint_args : ICRC1.Mint = {
          to = holder;
          created_at_time = ?Nat64.fromNat(Int.abs(now()));
          amount = category.allocatedAmount;
          memo = null;
        };
        let _mint_result = await* icrc1().mint(icrc1().minting_account().owner, mint_args);
        switch _mint_result {
          case (#Ok(_)) {
            distributedAmount += category.allocatedAmount;
            let unlock_date = now() + category.blockingDays * 24 * 60 * 60 * 1_000_000_000;
            let locked_ammount : LockedAmount = {
              unlockDate = unlock_date;
              amount = category.allocatedAmount;
            };
            ignore Map.put<Types.Account, LockedAmount>(holders_unlock_dates, ICRC1.ahash, holder, locked_ammount);
          };
          case _ {};
        };
      };
    };
  };

  public shared ({ caller }) func distribution_info() : async ?DistributionInfo {
    if (not distribution_is_started and caller == _owner) {
      await _distribution();
    };
    getDistributionStatus();
  };

  type DistributionInfo = {
    amountCurrentlyBlocked : Nat;
    amountReleasedToDate : Nat;
    releases : [{ date : Int; amount : Nat }];
  };

  func getDistributionStatus() : ?DistributionInfo {
    let releasesMap = Map.new<Int, Nat>();
    let currentTime = now();
    var amountCurrentlyBlocked = 0;

    for (holder in Map.vals(holders_unlock_dates)) {
      if (currentTime < holder.unlockDate) {
        amountCurrentlyBlocked += holder.amount;
      };
      switch Map.remove<Int, Nat>(releasesMap, ihash, holder.unlockDate) {
        case null {
          ignore Map.put<Int, Nat>(releasesMap, ihash, holder.unlockDate, holder.amount);
        };
        case (?val) {
          ignore Map.put<Int, Nat>(releasesMap, ihash, holder.unlockDate, val + holder.amount);
        };
      };
    };

    let amountReleasedToDate : Nat = distributedAmount - amountCurrentlyBlocked;
    let entries = Map.toArray(releasesMap);
    let releases = Array.map<(Int, Nat), { date : Int; amount : Nat }>(entries, func x = { date = x.0; amount = x.1 });

    ?{ amountCurrentlyBlocked; amountReleasedToDate; releases }
  };

  func validate_transaction({ from; amount; from_subaccount }) : { #Ok; #Err: ICRC1.TransferError } {
    let currentTime = now();
    let fromAccount = { owner = from; subaccount = from_subaccount };
    let lockedAmount = Map.get<Types.Account, LockedAmount>(holders_unlock_dates, ICRC1.ahash, fromAccount);
    switch lockedAmount {
      case null { #Ok };
      case (?locked) {
        if (currentTime < locked.unlockDate) {
          let balance = icrc1().balance_of(fromAccount);
          if (balance < amount + icrc1().fee()) {
            #Err(#InsufficientFunds({ balance }));
          } else if ((balance - amount - icrc1().fee()) < locked.amount) {
            #Err(#GenericError({ error_code = 18; message = "Insufficient unlocked balance" }));
          } else {
            #Ok;
          };
        } else {
          #Ok;
        };
      };
    };
  };

  // ICRC1 internals
  let icrc1_args : ICRC1.InitArgs = {
    icrc1_init_args with minting_account = switch (icrc1_init_args.minting_account) {
      case (?val) ?val;
      case null => ?{ owner = _owner; subaccount = null };
    };
    fee = switch (icrc1_init_args.fee) {
      case (? #Fixed(_fee)) => ? #Fixed(_fee - fee_distribution_percentages.toBurn);
      case _ => ? #Fixed(10_000 - fee_distribution_percentages.toBurn);
    };
  };

  stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id), ?icrc1_args, _owner);
  let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;
  private var _icrc1 : ?ICRC1.ICRC1 = null;

  private func get_icrc1_environment() : ICRC1.Environment = {
    get_time = null;
    get_fee = null;
    add_ledger_transaction = null;
    can_transfer = null;
  };

  func icrc1() : ICRC1.ICRC1 {
    switch (_icrc1) {
      case null => {
        let instance = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        _icrc1 := ?instance;
        instance;
      };
      case (?val) => val;
    };
  };

  // ICRC2 internals
  stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id), ?icrc2_init_args, _owner);
  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;
  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_environment() : ICRC2.Environment = {
    icrc1 = icrc1();
    get_fee = null;
    can_approve = null;
    can_transfer_from = null;
  };

  func icrc2() : ICRC2.ICRC2 {
    switch (_icrc2) {
      case null => {
        let instance = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?instance;
        instance;
      };
      case (?val) => val;
    };
  }

};
