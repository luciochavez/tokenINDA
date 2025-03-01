import MigrationTypes "../types";
import v0_1_0 "types";

import D "mo:base/Debug";
import Opt "mo:base/Option";
import Itertools "mo:itertools/Iter";

import Vec "mo:vector";
import Map "mo:map9/Map";
import Set "mo:map9/Set";

module {

  type Account = v0_1_0.Account;
  type Balance = v0_1_0.Balance;

  type ApprovalInfo = v0_1_0.ApprovalInfo;

  let ahash = v0_1_0.ahash;
  let apphash = v0_1_0.apphash;


  public func upgrade(prevmigration_state: MigrationTypes.State, args: MigrationTypes.Args, caller: Principal): MigrationTypes.State {

    let {
        max_approvals_per_account;
        fee;
        max_approvals;
        settle_to_approvals;
        advanced_settings;
        max_allowance;
    } = switch(args){
      case(?args) {
        {
          args with
          max_approvals_per_account = Opt.get<Nat>(args.max_approvals_per_account, 500);
          max_approvals = Opt.get<Nat>(args.max_approvals, 5_000_000);
          settle_to_approvals = Opt.get<Nat>(args.settle_to_approvals, 4_990_000);
          fee = switch(args.fee){
            case(null) #ICRC1;
            case(?val) val;
          };
        }
      };
      case(null) {{
          max_approvals_per_account = 500;
          max_approvals = 5_000_000;
          settle_to_approvals = 4_990_000;
          fee = #ICRC1;
          advanced_settings = null;
          max_allowance = null;
        }
      };
    };

    var existing_approvals =switch(advanced_settings){
      case(null) [];
      case(?val) val.existing_approvals;
    };
    
    let approvals = Map.fromIter<(Account, Account), ApprovalInfo>(existing_approvals.vals(), apphash);

    

    let state : MigrationTypes.Current.State = {
      ledger_info = {
        var max_approvals_per_account = max_approvals_per_account;
        var max_approvals = max_approvals;
        var settle_to_approvals = settle_to_approvals;
        var fee = fee;
        var max_allowance = max_allowance;
        var metadata = null;
      };
      token_approvals = approvals;
      indexes : v0_1_0.Indexes = {
        spender_to_approval_account = Map.new<v0_1_0.Account, Set.Set<(Account)>>();
        owner_to_approval_account = Map.new<v0_1_0.Account, Set.Set<(Account)>>();
      };
    };

    

    return #v0_1_0(#data(state));
  };

  public func downgrade(prev_migration_state: MigrationTypes.State, args: MigrationTypes.Args, caller: Principal): MigrationTypes.State {

    return #v0_0_0(#data);
  };

};