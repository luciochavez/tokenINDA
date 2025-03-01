// please do not import any types from your project outside migrations folder here
// it can lead to bugs when you change those types later, because migration types should not be changed
// you should also avoid importing these types anywhere in your project directly from here
// use MigrationTypes.Current property instead

import D "mo:base/Debug";
import Blob "mo:base/Blob";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Star "mo:star/star";

import MapLib "mo:map9/Map";
import SetLib "mo:map9/Set";
import VecLib "mo:vector";

import ICRC1 "mo:icrc1-mo/ICRC1/";

module {

  /// Vector provides an interface to a vector-like collection.
  public let Vector = VecLib;

  /// Map provides an interface to a key-value storage collection.
  public let Map = MapLib;

  /// Set provides an interface to a set-like collection, storing unique elements.
  public let Set = SetLib;

  /// LedgerInfoShared contains shared configuration settings for the ledger.
  public type LedgerInfoShared = {
    /// Maximum number of approvals one account can set for others.
    max_approvals_per_account : Nat;
    /// Maximum number of total approvals the ledger can store.
    max_approvals : Nat;
    /// Maximum allowance for a spender, which could be a fixed value or based on total supply.
    max_allowance : ?MaxAllowance;
    /// Number of approvals the ledger is settled to when cleanup routines run.
    settle_to_approvals : Nat;
    /// Structure describing how transaction fees are determined.
    fee : Fee;
  };

  /// Stats contains general statistics about the ledger and approvals in the system.
  public type Stats = {
    /// Shared ledger info with configurations.
    ledger_info : LedgerInfoShared;
    /// Count of all current token approvals.
    token_approvals_count : Nat;
    /// Counts of approvals broken down by spender and owner.
    indexes: {
      /// Count of approvals per spender.
      spender_to_approval_account_count : Nat;
      /// Count of approvals per owner.
      owner_to_approval_account_count : Nat;
    };
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

  /// MaxAllowance indicates the maximum allowance a spender can be approved for.
  public type MaxAllowance = {
    /// A fixed maximum value for the allowance.
    #Fixed: Nat;
    /// Indicates the allowance is set to the total supply of the token.
    #TotalSupply;
  };

  /// Environment defines the context in which the token ledger operates.
  public type Environment = {
    /// Reference to the ICRC-1 ledger interface.
    icrc1 : ICRC1.ICRC1;
    /// Optional fee calculating function.
    get_fee : ?((State, Environment, ApproveArgs) -> Balance);
    /// Optional synchronous or asynchronous functions triggered when transferring from an account.
    
  };

  public type CanTransferFrom = ?{
      #Sync : (<system>(trx: Value, trxtop: ?Value, notification: TransferFromNotification) -> Result.Result<(trx: Value, trxtop: ?Value, notification: TransferFromNotification), Text>);
      #Async : (<system>(trx: Value, trxtop: ?Value, notification: TransferFromNotification) -> async* Star.Star<(trx: Value, trxtop: ?Value, notification: TransferFromNotification), Text>);
    };

    /// Optional synchronous or asynchronous functions triggered upon approval of a transfer.
  public type CanApprove = ?{
    #Sync : (<system>(trx: Value, trxtop: ?Value, notification: TokenApprovalNotification) -> Result.Result<(trx: Value, trxtop: ?Value, notification: TokenApprovalNotification), Text>);
    #Async : (<system>(trx: Value, trxtop: ?Value, notification: TokenApprovalNotification) -> async* Star.Star<(trx: Value, trxtop: ?Value, notification: TokenApprovalNotification), Text>);
  };

  /// Value is a generic type capable of representing different values in a shared data structure.
  public type Value = {
    #Nat : Nat;
    #Int : Int;
    #Blob : Blob;
    #Text : Text;
    #Array : [Value];
    #Map: [(Text, Value)];
  };

  /// Account represents a unique identity on the ledger with an optional subaccount.
  public type Account = {
    /// The principal identifier for the account.
    owner : Principal;
    /// An optional subaccount providing for multiple identities under the same owner.
    subaccount : ?Subaccount;
  };

  /// Subaccount represents a byte array used to create multiple account identities for the same owner.
  public type Subaccount = Blob;

  /// ApproveArgs defines the arguments that are necessary when creating an approval.
  public type ApproveArgs = {
    /// Optional subaccount from which to approve.
    from_subaccount : ?Blob;
    /// Account to which the approval is granted.
    spender : Account;
    /// Amount of tokens approved for transfer.
    amount : Nat;
    /// Optional expected current allowance, used to check for modifications.
    expected_allowance : ?Nat;
    /// Optional timestamp when the approval expires.
    expires_at : ?Nat64;
    /// Optional fee associated with the transaction.
    fee : ?Nat;
    /// Optional memo or note to include with the approval.
    memo : ?Blob;
    /// Optional timestamp of when the approval was created.
    created_at_time : ?Nat64;
  };

  /// ApproveError lists varieties of errors that can be returned during approval process.
  public type ApproveError = {
    /// Returned when the fee provided is less than expected.
    #BadFee :  { expected_fee : Nat };
    /// Returned when there are not enough funds to pay the fee.
    #InsufficientFunds :  { balance : Nat };
    /// Returned when the current allowance does not match the expected amount.
    #AllowanceChanged :  { current_allowance : Nat };
    /// Returned when an approval request has already expired.
    #Expired :  { ledger_time : Nat64; };
    #TooOld;
    /// Returned when an approval is deemed to be created in the future.
    #CreatedInFuture:  { ledger_time : Nat64 };
    /// Returned when the request is duplicate of an earlier one.
    #Duplicate :  { duplicate_of : Nat };
    #TemporarilyUnavailable;
    /// Generic error with a code and message.
    #GenericError :  { error_code : Nat; message : Text };
  };

  /// UpdateLedgerInfoRequest defines requests that can update ledger configurations.
  public type UpdateLedgerInfoRequest = {
    #MaxApprovalsPerAccount : Nat;
    #MaxApprovals : Nat;
    #MaxAllowance : ?MaxAllowance;
    #SettleToApprovals : Nat;
    #Fee : Fee;
  };

  /// ApproveResponse is the result type of approve operations, indicating success or the error occurred.
  public type ApproveResponse = { #Ok : Nat; #Err : ApproveError };

  /// ApproveStar combines ApproveResponse and Text using the Star pattern.
  public type ApproveStar = Star.Star<ApproveResponse, Text>;

  /// TransferFromError defines different errors that can occur during a transfer from an account.
  public type TransferFromError = {
    /// Error for an incorrect or insufficient fee.
    #BadFee :  { expected_fee : Nat };
    /// Error for a burn amount that is below the minimum requirement.
    #BadBurn :  { min_burn_amount : Nat };
    /// Error when there are insufficient funds to complete the transfer.
    #InsufficientFunds :  { balance : Nat };
    /// Error when the spender exceeds the allowance.
    #InsufficientAllowance :  { allowance : Nat };
    #TooOld;
    /// Error when an operation is created in the future.
    #CreatedInFuture:  { ledger_time : Nat64 };
    /// Error when an operation duplicates a previous one.
    #Duplicate :  { duplicate_of : Nat };
    #TemporarilyUnavailable;
    /// Generic error that includes an error code and a descriptive message.
    #GenericError :  { error_code : Nat; message : Text };
  };

  /// TransferFromArgs contains the arguments necessary for a transfer from one account to another.
  public type TransferFromArgs = {
    spender_subaccount : ?Blob;
    from : Account;
    to : Account;
    amount : Nat;
    fee : ?Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  };

  /// AllowanceArgs contains the arguments necessary for querying the allowance on the ledger.
  public type AllowanceArgs = {
    account : Account;
    spender : Account;
  };

  /// Allowance represents the amount a spender is allowed to use and its expiration time.
  public type Allowance = {
    allowance : Nat;
    expires_at : ?Nat64;
  };

  /// account_hash32 is a hash function for accounts, returning a 32-bit hash value.
  public let account_hash32 = ICRC1.account_hash32;

  /// account_eq is an equality checker for accounts.
  public let account_eq = ICRC1.account_eq;

  /// account_compare is a comparator function for accounts.
  public let account_compare = ICRC1.account_compare;

  /// ahash is a general purpose hash function.
  public let ahash = ICRC1.ahash;

  /// InitArgs represents the initialization arguments for setting up an ICRC1 token canister that includes ICRC2 standards.
  public type InitArgs = {
      max_approvals_per_account : ?Nat;
      max_allowance : ?MaxAllowance;
      fee : ?Fee;
      /// Optional advanced settings for additional initialization aspects.
      advanced_settings: ?AdvancedSettings;
      max_approvals: ?Nat;
      settle_to_approvals: ?Nat;
  };

  /// Balance represents numerical token balance.
  public type Balance = Nat;

  /// AdvancedSettings allows specifying existing approvals for migration into a new token canister in [InitArgs](#type.InitArgs).
  public type AdvancedSettings = {
      /// This array contains existing approvals for migration purposes and should not be manipulated otherwise.
      existing_approvals: [((Account, Account), ApprovalInfo)]; //only used for migration

  };

  /// Transaction is a record that logs a transaction action.
  public type Transaction = ICRC1.Transaction;

  /// TokenApprovalNotification captures the necessary information for a token approval event.
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

  /// TransferFromResponse represents the outcome of a transfer from operation.
  public type TransferFromResponse = { #Ok : Nat; #Err : TransferFromError };

  /// ApprovalInfo contains all details of a specific approval setting.
  public type ApprovalInfo = {
    from_subaccount : ?Blob;
    spender : Account;
    amount : Nat;
    expires_at : ?Nat64;
  };

  /// approvalEquals is a function that checks the equality of two account approval mappings.
  public func approvalEquals(x: (Account, Account), y: (Account, Account)) : Bool{
    // Compare the approval mappings between accounts.
    if(x!=y) return false;
    return ICRC1.account_eq(x.1, y.1);
  };

  /// approvalHash32 hashes approval mappings to a 32-bit value.
  public func approvalHash32(x : (Account, Account)) : Nat32 {
    // Hash the approval mapping of two accounts to produce a 32-bit hash.
    var accumulator = ICRC1.ahash.0(x.1);
    accumulator +%= ICRC1.ahash.0(x.1);
    return accumulator;
  };

  /// apphash is a pair comprising the approvalHash32 hash function and the approvalEquals equality checker.
  public let apphash = ( approvalHash32, approvalEquals);

  /// TransferFromListener is a callback type used to listen to transfer events.
  public type TransferFromListener = <system>(TransferFromNotification, trxid: Nat) -> ();

  /// TokenApprovalListener is a callback type used to listen to approval events.
  public type TokenApprovalListener = <system>(TokenApprovalNotification, trxid: Nat) -> ();

  /// LedgerInfo contains mutable configurations for the ledger.
  public type LedgerInfo = {
    var max_approvals_per_account : Nat;
    var max_approvals : Nat;
    var max_allowance : ?MaxAllowance;
    var settle_to_approvals : Nat;
    var fee : Fee;
    var metadata : ?Value;
  };

  /// Indexes contains structures that index approvals by spender or owner.
  public type Indexes = {
    spender_to_approval_account : Map.Map<Account, Set.Set<Account>>;
    owner_to_approval_account : Map.Map<Account, Set.Set<(Account)>>;
  };

  /// State represents the entire state of the ledger, containing ledger configurations, approvals, and indices.
  public type State = {
    ledger_info : LedgerInfo;
    token_approvals : Map.Map<(Account, Account), ApprovalInfo>;
    indexes: Indexes;
  };


};