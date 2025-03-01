# icrc2.mo

## Warning - This is an alpha release. It has not been audited and should not be used in production.

## Install
```
mops add icrc2-mo
```

## Usage
```motoko
import ICRC2 "mo:icrc2-mo/ICRC2";

## Initialization

This ICRC2 class uses a migration pattern as laid out in https://github.com/ZhenyaUsenko/motoko-migrations, but encapsulates the pattern in the Class+ pattern as described at https://forum.dfinity.org/t/writing-motoko-stable-libraries/21201 . As a result, when you insatiate the class you need to pass the stable memory state into the class:

```

stable var icrc1_migration_state = ICRC1.init(ICRC1.initialState() , #v0_1_0(#id), _args, init_msg.caller);

  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_environment() : ICRC2.Environment {
      {
        icrc1 = icrc1();
        get_fee = null;
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

```
The above pattern will allow your class to call icrc2().XXXXX to easily access the stable state of your class and you will not have to worry about pre or post upgrade methods.

Init args:

```

  /// MaxAllowance indicates the maximum allowance a spender can be approved for.
  public type MaxAllowance = {
    /// A fixed maximum value for the allowance.
    #Fixed: Nat;
    /// Indicates the allowance is set to the total supply of the token.
    #TotalSupply;
  };

  /// Fee defines the structure of how fees are calculated and charged.
  public type Fee = {
    /// A fixed fee amount that is applied to transactions.
    #Fixed: Nat;
    /// Indicates fee structure is defined in the surrounding environment.
    #Environment;
    /// Fee is defined and managed by ICRC-1 standards.
    #ICRC1;
  };

  public type InitArgs = {
      max_approvals_per_account : ?Nat; // maximum number of approvals to allow each account
      max_allowance : ?MaxAllowance; // max allowance to allow for each approval
      fee : ?Fee; // fee to charge for each approval or transfer from
      /// Optional advanced settings for additional initialization aspects.
      advanced_settings: ?AdvancedSettings;
      max_approvals: ?Nat; // max number of approvals to keep active in the canister
      settle_to_approvals: ?Nat;  // number of approvals to settle to during clean up
  };
```

### Environment

The environment pattern lets you pass dynamic information about your environment to the class.

```
  

  // Environment defines the context in which the token ledger operates.
  public type Environment = {
    /// Reference to the ICRC-1 ledger interface.
    icrc1 : ICRC1.ICRC1;
    /// Optional fee calculating function.
    get_fee : ?((State, Environment, ApproveArgs) -> Balance);
    /// TokenApprovalNotification captures the necessary information for a token approval event.
  };
```
## Deduplication

The class uses a Representational Independent Hash map to keep track of duplicate transactions within the permitted drift timeline.  The hash of the "tx" value is used such that provided memos and created_at_time will keep deduplication from triggering.

## Event system

### Subscriptions

The class has a register_token_approved_listener and register_transfer_from_listener endpoint that allows other objects to register an event listener and be notified whenever a token event occurs from one user to another.

The events are synchronous and cannot directly make calls to other canisters.  We suggest using them to set timers if notifications need to be sent using the Timers API.

```

    /// TransferFromListener is a callback type used to listen to transfer events.
  public type TransferFromListener = (TransferFromNotification, trxid: Nat) -> ();

  /// TokenApprovalListener is a callback type used to listen to approval events.
  public type TokenApprovalListener = (TokenApprovalNotification, trxid: Nat) -> ();

```

### Overrides

The user may assign a function to intercept each transaction type just before it is committed to the transaction log.  These functions are optional. The user may manipulate the values and return them to the processing transaction and the new values will be used for the transaction block information and for notifying subscribed components.

By returning an #err from these functions you will effectively cancel the transaction and the caller will receive back a #GenericError for that request with the message you provide.

Wire these functions up by including them in your call to transfer_tokens_from and approve_transfer.

```
public type TokenApprovalNotification = {
    from : Account;
    amount : Nat;
    requested_amount: Nat;
    expected_allowance : ?Nat;
    spender : Account;             // Approval is given to an ICRC Account
    memo :  ?Blob;
    fee : ?Nat;
    calculated_fee: Nat;
    expires_at : ?Nat64;
    created_at_time : ?Nat64; 
  };

  /// TransferFromNotification captures the necessary information for a transfer from event.
  public type TransferFromNotification = {
    spender: Account; // the subaccount of the caller (used to identify the spender)
    from : Account;
    to : Account;
    memo : ?Blob;
    amount : Nat;
    fee : ?Nat;
    calculated_fee: Nat;
    created_at_time : ?Nat64;
  };
   
   /// Optional synchronous or asynchronous functions triggered when transferring from an account.
    can_transfer_from : ?{
      #Sync : ((trx: Value, trxtop: ?Value, notification: TransferFromNotification) -> Result.Result<(trx: Value, trxtop: ?Value, notification: TransferFromNotification), Text>);
      #Async : ((trx: Value, trxtop: ?Value, notification: TransferFromNotification) -> async* Star.Star<(trx: Value, trxtop: ?Value, notification: TransferFromNotification), Text>);
    };

    /// Optional synchronous or asynchronous functions triggered upon approval of a transfer.
    can_approve : ?{
      #Sync : ((trx: Value, trxtop: ?Value, notification: TokenApprovalNotification) -> Result.Result<(trx: Value, trxtop: ?Value, notification: TokenApprovalNotification), Text>);
      #Async : ((trx: Value, trxtop: ?Value, notification: TokenApprovalNotification) -> async* Star.Star<(trx: Value, trxtop: ?Value, notification: TokenApprovalNotification), Text>);
    };

```

## Funding

This library was initially incentivized by [ICDevs](https://icdevs.org/). You can view more about the bounty on the [forum](https://forum.dfinity.org/t/assigned-icdevs-org-bounty-44-icrc-2-and-icrc-3-motoko-6-000) .  If you use this library and gain value from it, please consider a [donation](https://icdevs.org/donations.html) to ICDevs.