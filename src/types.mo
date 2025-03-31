import Blob "mo:base/Blob";
import Principal "mo:base/Principal";

module {
  public type Account = {
    owner : Principal;
    subaccount : ?Blob;
  };

  public type Holder = {
    owner: Principal;
    subaccount: ?Blob;
  };

  public type HolderCategory = {
    name : Text;
    holders : [Account];
    allocatedAmount : Nat;
    blockingDays : Nat;
  };


  public type FeeAllocationPercentages = {
    name : Text;
    account : Account;
    percent : Nat; // % multiplicado por 100 (ej. 225 = 2.25%)
  };

  public func checkFeeAllocationPercentages(allocationsFee: [FeeAllocationPercentages]): Bool {
    var accumulator = 0;
    for(a in allocationsFee.vals()) {
        accumulator += (a.percent);
    };
    return accumulator <= 100 * 100
  };
};
