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
    to : Account;
    percentage : Nat; // % multiplicado por 100 (ej. 225 = 2.25%)
  };

  public func checkFeeAllocationPercentages(pools : [FeeAllocationPercentages]) : Bool {
    var total = 0;
    for (p in pools.vals()) {
      total += p.percentage;
    };
    total <= 10_000; // No excede 100%
  };
};
