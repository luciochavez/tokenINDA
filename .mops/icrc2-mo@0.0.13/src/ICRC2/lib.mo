import Blob "mo:base/Blob";
import D "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";

import ICRC1 "mo:icrc1-mo/ICRC1/";
import RepIndy "mo:rep-indy-hash";
import Star "mo:star/star";
import Vec "mo:vector";

import Migration "./migrations";
import MigrationTypes "./migrations/types";

/// The ICRC2 class with all the functions for creating an
/// ICRC2 token on the Internet Computer
module {

    let debug_channel = {
      announce = false;
      transfer = false;
      approve = false;
    };

    /// # State
    ///
    /// Encapsulates the entire ledger state across versions, facilitating data migration.
    /// It is a variant that includes possible format versions of the ledger state, enabling seamless upgrades to the system.
    ///
    /// ## Example
    ///
    /// ```
    /// let initialState = ICRC2.initialState();
    /// let currentState = #v0_1_0(#data(initialState));
    /// ```
    public type State =               MigrationTypes.State;

    /// # CurrentState
    ///
    /// Represents the current version of the ledger state, including all necessary data like token approvals, ledger information, and indexes.
    /// This is the state format that the ledger operates on at runtime.
    ///
    /// ## Members
    ///
    /// The data structure typically includes fields such as:
    /// - `ledger_info`: General information about the ledger, fees, and approval limits.
    /// - `token_approvals`: A map tracking the current approval allowances between accounts.
    /// - `indexes`: Various indexes to speed up operations like looking up token approvals.
    public type CurrentState =        MigrationTypes.Current.State;
    public type Environment =         MigrationTypes.Current.Environment;

    public type Account =             MigrationTypes.Current.Account;
    public type Balance =             MigrationTypes.Current.Balance;
    public type Value =               MigrationTypes.Current.Value;
    public type Subaccount =          MigrationTypes.Current.Subaccount;
  

    public type Fee =                 MigrationTypes.Current.Fee;
    public type TransferFromArgs =        MigrationTypes.Current.TransferFromArgs;

    public type InitArgs =            MigrationTypes.Current.InitArgs;
    public type AdvancedSettings =    MigrationTypes.Current.AdvancedSettings;

    /// # TransferFromListener
    ///
    /// Defines the signature for listener callbacks that are triggered after a successful `transfer_from` operation.
    /// Listeners are used to execute additional logic tied to token transfer events, such as updating external systems or logs.
    ///
    /// ## Parameters
    ///
    /// - `notification`: `TransferFromNotification` - The details about the transfer that has occurred.
    /// - `transaction_id`: `Nat` - The unique identifier for the transfer transaction.
    public type TransferFromListener = MigrationTypes.Current.TransferFromListener;

    /// # TransferFromNotification
    ///
    /// Contains detailed information about a `transfer_from` operation that has been performed, enabling listeners to react accordingly.
    ///
    /// ## Members
    ///
    /// - `spender`: `Account` - The account that initiated the transfer.
    /// - `from`: `Account` - The source account from which tokens were transferred.
    /// - `to`: `Account` - The destination account to which tokens were transferred.
    /// - `amount`: `Nat` - The quantity of tokens transferred.
    /// - Additional fields may include `fee`, `memo`, and timestamps.
    public type TransferFromNotification = MigrationTypes.Current.TransferFromNotification;
    public type TokenApprovalListener = MigrationTypes.Current.TokenApprovalListener;

    public type LedgerInfo = MigrationTypes.Current.LedgerInfo;
    public type Indexes = MigrationTypes.Current.Indexes;
    public type Stats = MigrationTypes.Current.Stats;

    public type ApproveArgs = MigrationTypes.Current.ApproveArgs;
    public type ApproveError = MigrationTypes.Current.ApproveError;
    public type ApprovalInfo = MigrationTypes.Current.ApprovalInfo;
    public type ApproveResponse = MigrationTypes.Current.ApproveResponse;
    public type ApproveStar = MigrationTypes.Current.ApproveStar;
    public type AllowanceArgs = MigrationTypes.Current.AllowanceArgs;
    public type Allowance = MigrationTypes.Current.Allowance;
    public type TransferFromResponse = MigrationTypes.Current.TransferFromResponse;
   
    public type CanTransferFrom = MigrationTypes.Current.CanTransferFrom;
    public type CanApprove = MigrationTypes.Current.CanApprove;

    public type UpdateLedgerInfoRequest = MigrationTypes.Current.UpdateLedgerInfoRequest;
    public type MetaDatum = ICRC1.MetaDatum;

    /// # Transaction
    ///
    /// Models the details of a ledger transaction, capturing all relevant data including sender, receiver, amounts, and optional metadata.
    ///
    /// ## Members
    ///
    /// - `operation`: `Operation` - The operation performed, e.g., a transfer or burn.
    /// - `from`: `Account` - The account from which tokens are debited.
    /// - `to`: `Account` - The account to which tokens are credited.
    /// - `amount`: `Nat` - The amount of tokens involved in the transaction.
    /// - And more fields for additional details such as fees, timestamps, and memo information.
    public type Transaction = MigrationTypes.Current.Transaction;

    /// # TokenApprovalNotification
    ///
    /// Contains detailed information about changes to token approval settings, providing context for listeners to process approval events.
    ///
    /// ## Members
    ///
    /// The structure typically includes fields like:
    /// - `owner`: `Principal` - The principal of the account owner who set the approval.
    /// - `spender`: `Account` - The spender who is given allowance to transfer tokens.
    /// - And other related fields detailing the approved amount, expiration, and metadata.
    public type TokenApprovalNotification = MigrationTypes.Current.TokenApprovalNotification;

    /// # `initialState`
    ///
    /// Creates and returns the initial state of the ICRC-2 ledger.
    ///
    /// ## Returns
    ///
    /// `State`: The initial state object based on the `v0_0_0` version specified by the `MigrationTypes.State` variant.
    ///
    /// ## Example
    ///
    /// ```
    /// let state = ICRC2.initialState();
    /// ```
    public func initialState() : State {#v0_0_0(#data)};

    /// # currentStateVersion
    ///
    /// Indicates the current version of the ledger state that this ICRC-2 implementation is using.
    /// It is used for data migration purposes to ensure compatibility across different ledger state formats.
    ///
    /// ## Value
    ///
    /// `#v0_1_0(#id)`: A unique identifier representing the version of the ledger state format currently in use, as defined by the `State` data type.
    public let currentStateVersion = #v0_1_0(#id);

    public let init = Migration.migrate;
    public let Map = MigrationTypes.Current.Map;
    public let Set = MigrationTypes.Current.Set;
    public let Vector = MigrationTypes.Current.Vector;
    public let ahash = MigrationTypes.Current.ahash;
    public let account_eq = MigrationTypes.Current.account_eq;
    public let apphash = MigrationTypes.Current.apphash;

  /// #class ICRC2
  /// Initializes the state of the ICRC2 class.
  /// - Parameters:
  ///     - stored: `?State` - An optional initial state to start with; if `null`, the initial state is derived from the `initialState` function.
  ///     - canister: `Principal` - The principal of the canister where this class is used.
  ///     - environment: `Environment` - The environment settings for various ICRC standards-related configurations.
  /// - Returns: No explicit return value as this is a class constructor function.
  ///
  /// The `ICRC2` class encapsulates the logic for managing approvals and transfers of tokens.
  /// Within the class, we have various methods such as `get_ledger_info`, `approve_transfers`, 
  /// `is_approved`, `get_token_approvals`, `revoke_collection_approvals`, and many others
  /// that assist in handling the ICRC-2 standard functionalities like getting and setting 
  /// approvals, revoking them, and performing transfers of tokens.
  ///
  /// The methods often utilize helper functions like `testMemo`, `testExpiresAt`, `testCreatedAt`, 
  /// `revoke_approvals`, `cleanUpApprovals`, `update_ledger_info`, `revoke_collection_approval`, 
  /// `approve_transfer`, `transfer_token`, `revoke_token_approval` and others that perform 
  /// specific operations such as validation of data and performing the necessary changes to the approvals 
  /// and the ledger based on the token transactions.
  ///
  /// Event listeners and clean-up routines are also defined to maintain the correct state 
  /// of approvals after transfers and to ensure the system remains within configured limitations.
  ///
  /// The `ICRC2` class allows for detailed ledger updates using `update_ledger_info`, 
  /// querying for different approval states, and managing the transfer of tokens.
  ///    
  /// Additional functions like `get_stats` provide insight into the current state of  approvals.
  public class ICRC2(stored: ?State, canister: Principal, environment: Environment){

    /// # State
    ///
    /// Encapsulates the entire ledger state across versions, facilitating data migration.
    /// It is a variant that includes possible format versions of the ledger state, enabling seamless upgrades to the system.
    ///
    /// ## Example
    ///
    /// ```
    /// let initialState = ICRC2.initialState();
    /// let currentState = #v0_1_0(#data(initialState));
    /// ```
    var state : CurrentState = switch(stored){
      case(null) {
        let #v0_1_0(#data(foundState)) = init(initialState(),currentStateVersion, null, canister);
        foundState;
      };
      case(?val) {
        let #v0_1_0(#data(foundState)) = init(val,currentStateVersion, null, canister);
        foundState;
      };
    };

    /// # token_approved_listeners
    ///
    /// Holds the registered listeners for the `TokenApprovalListener` event. Listeners are functions that
    /// are executed in response to changes in token approval settings triggered by `approve_transfers` and other related operations.
    ///
    /// ## Type
    ///
    /// `Vec<(Text, TokenApprovalListener)>`: A vector of pairs, where each pair consists of a namespace identifier
    /// as `Text` and the `TokenApprovalListener` callback function. The namespace allows for easy identification
    /// and potential removal of listeners.
    ///
    /// ## Example
    ///
    /// ```
    /// // To register a new listener:
    /// let namespace = "my_listener_namespace";
    /// let listener: TokenApprovalListener = func (notification: TokenApprovalNotification, transaction_id: Nat) {
    ///     // Custom logic here
    /// };
    /// ICRC2Instance.register_token_approved_listener(namespace, listener);
    /// ```
    private let token_approved_listeners = Vec.new<(Text, TokenApprovalListener)>();
    
    private let transfer_from_listeners = Vec.new<(Text, TransferFromListener)>();

    public let migrate = Migration.migrate;


    /// # `get_ledger_info`
    ///
    /// Retrieves the current ledger information for the ICRC-2 ledger, which contains parameters such as fee
    /// configurations and approval limits that apply to the entire token ledger.
    ///
    /// ## Returns
    ///
    /// `LedgerInfo`: A record that contains data about the ledger itself, such as fee structure (fixed or
    /// based on ICRC-1 standard), max number of approvals per account, and max allowance amounts.
    ///
    /// ## Example
    ///
    /// ```
    /// let ledgerInfo = myICRC2Instance.get_ledger_info();
    /// ```
    public func get_ledger_info() :  LedgerInfo {
      return state.ledger_info;
    };

    /// # `get_indexes`
    ///
    /// Fetches the indexing information from the token ledger, particularly focusing on relationships
    /// between owners and their set approvals. This helps expedite queries about token approvals.
    ///
    /// ## Returns
    ///
    /// `Indexes`: A record with the current indexing status of approvals, providing a crucial performance
    /// optimization for querying various forms of approvals set by token owners.
    ///
    /// ## Example
    ///
    /// ```
    /// let indexes = myICRC2Instance.get_indexes();
    /// ```
    public func get_indexes() :  Indexes {
      return state.indexes;
    };

    /// # `get_state`
    ///
    /// Acquires the current state of the ledger, which reflects all the approvals and the setup of the ledger,
    /// along with any other metadata maintained.
    ///
    /// ## Returns
    ///
    /// `CurrentState`: All encompassing state structure that includes account balances, approval mappings,
    /// and ledger configuration, as defined in `MigrationTypes.Current.State`.
    ///
    /// ## Example
    ///
    /// ```
    /// let currentState = myICRC2Instance.get_state();
    /// ```
    public func get_state() :  CurrentState {
      return state;
    };

    
      /// `metadata`
      ///
      /// Retrieves all metadata associated with the token ledger, such as the symbol, name, and other relevant data.
      /// If no metadata is found, the method initializes default metadata based on the state and the canister Principal.
      ///
      /// Returns:
      /// `MetaData`: A record containing all metadata entries for this ledger.
      public func metadata() : [ICRC1.MetaDatum] {
         switch(state.ledger_info.metadata){
          case(?val){};
          case(null) {
            let newdata = init_metadata();
            state.ledger_info.metadata := ?newdata;
          };
         };

         switch(state.ledger_info.metadata){
          case(?val){
            switch(val){
              case(#Map(val)) val;
              case(_) D.trap("malformed metadata");
            };
          };
          case(null){D.trap("unreachable metadata");}
         };
      };


      /// Creates a Stable Buffer with the default metadata and returns it.
      public func init_metadata() : MigrationTypes.Current.Value {
          
          let md = switch(state.ledger_info.metadata){
            case(?val){
              switch(val){
                case(#Map(val)) val;
                case(_) [];
              };
            };
            case(null)[];
          };

          let results = Map.new<Text, ICRC1.MetaDatum>();
          
          
          for(thisItem in md.vals()){
            ignore Map.put(results, Map.thash, thisItem.0, thisItem);
          };

          ignore Map.put(results, Map.thash, "icrc2:max_approvals_per_account",("icrc2:max_approvals_per_account", #Nat(state.ledger_info.max_approvals_per_account)));
          ignore Map.put(results, Map.thash,"icrc2:max_approvals", ("icrc2:max_approvals", #Nat(state.ledger_info.max_approvals)));
          ignore Map.put(results, Map.thash,"icrc2:settle_to_approvals", ("icrc2:settle_to_approvals", #Nat(state.ledger_info.settle_to_approvals)));
          switch(state.ledger_info.max_allowance){
            case(?val){
              switch(val){
                case(#Fixed(fixed)) ignore Map.put(results, Map.thash, "icrc2:max_allowance", ("icrc2:max_allowance", #Nat(fixed)));
                case(#TotalSupply) ignore Map.put(results, Map.thash, "icrc2:max_allowance", ("icrc2:max_allowance", #Text("total_supply")));
              };
            };
            case(null){};
          };

          ignore Map.put(results, Map.thash, "icrc2:fee", ("icrc2:fee", switch(state.ledger_info.fee){
                case(#ICRC1) #Text("icrc1"); 
                case(#Fixed(val)) #Nat(val);
                case(#Environment) #Nat(10000); //a lie as it is determined at runtime.
          }));

          let final_result = Iter.toArray(Map.vals(results));

          state.ledger_info.metadata := ?#Map(final_result);
          ignore environment.icrc1.register_metadata(final_result);

          #Map(final_result);
      };

    /// # get_fee
    ///
    /// Calculates the fee required for approving transfers.
    ///
    /// ## Parameters
    ///
    /// - `request`: `ApproveArgs` - The parameters for the approval request, which includes information
    ///   such as the account from which to approve transfers, the spender account, amount of tokens to allow,
    ///   and the optional fee preferred by the user initiating the request.
    ///
    /// ## Returns
    ///
    /// `Nat` - The calculated fee based on the approval request parameters and the ledger's fee policy.
    /// This function ensures that the fee is never below the required minimum set by the ledger configuration.
    ///
    /// ## Remarks
    ///
    /// This function will return the maximum fee between the ledger's fixed or environment-determined fee
    /// and any user-provided fee amount. If no user fee is provided, the ledger's fee policy will be used.
    public func get_fee(request: ApproveArgs) : Nat {
      
      switch(state.ledger_info.fee){
        case(#Fixed(val)){
          switch(request.fee){
            case(null) val;
            case(?user_fee){
              Nat.max(val,user_fee);
            };
          };
        };
        case(#ICRC1){
          environment.icrc1.get_fee({
            from_subaccount = request.from_subaccount;
            to = request.spender;
            amount = request.amount;
            fee = request.fee;
            memo  = request.memo;
            created_at_time = request.created_at_time;
          });
        };
        case(#Environment){
          switch(environment.get_fee){
            case(?get_fee_env){
              let val = get_fee_env(state, environment, request);
              switch(request.fee){
                case(null) val;
                case(?user_fee){
                  Nat.max(val,user_fee);
                };
              };
            };
            case(_){
              10000;
            };
          };
        };
      
      };
    };

    /// # validate_fee
    ///
    /// Ensures the fee provided in the transfer or approval operation meets or exceeds the required fee.
    ///
    /// ## Parameters
    ///
    /// - `calculated_fee`: `Balance` - The fee amount calculated by the ledger as necessary for the operation.
    /// - `opt_fee`: `?Balance` - An optional override fee provided by the user. If provided, it must be
    ///   greater than or equal to the `calculated_fee`.
    ///
    /// ## Returns
    ///
    /// `Bool` - A boolean indicating whether the provided fee (if any) is valid, i.e., it meets or exceeds the required fee.
    public func validate_fee(
        calculated_fee : MigrationTypes.Current.Balance,
        opt_fee : ?MigrationTypes.Current.Balance,
    ) : Bool {
        switch (opt_fee) {
            case (?tx_fee) {
                if (tx_fee < calculated_fee) {
                    return false;
                };
            };
            case (null) {};
        };

        true;
    };

    /// # validate_approval
    ///
    /// Validates the parameters and the state of the ledger for an approval request.
    ///
    /// ## Parameters
    ///
    /// - `from`: `Account` - The source account from which tokens can be spent upon approval.
    /// - `approval`: `ApproveArgs` - The detailed approval request including the spender information and the amount.
    /// - `calculated_fee`: `Balance` - The required fee for processing the approval request.
    /// - `system_override`: `Bool` - A flag indicating whether system-level validation is overridden, allowing for internal processing.
    ///
    /// ## Returns
    ///
    /// `Star<ApproveResponse, Text>` - A Star type result that contains either an approval response indicating success
    /// or an error message if the validation fails.
    ///
    /// ## Remarks
    ///
    /// This function performs a series of checks, including account validation, fee sufficiency, and allowance
    /// exactness (if `expected_allowance` is provided), along with tests for memo size, expiration, and creation
    /// timestamp validity.
    public func validate_approval(from: Account, approval : ApproveArgs,
          calculated_fee : MigrationTypes.Current.Balance,
          system_override : Bool): Star.Star<ApproveResponse, Text>{

            

            if (not ICRC1.AccountHelper.validate(from)) {
                return #err(#trappable("Invalid account entered for from. "));
            };

            if (not ICRC1.AccountHelper.validate(approval.spender)) {
                return #err(#trappable("Invalid account entered for spender. "));
            };

            let balance = environment.icrc1.balance_of(from);

            if(calculated_fee > balance){
              return #trappable(#Err(#InsufficientFunds({balance = balance})));
            };

            //check the expected allowance
            switch(Map.get(state.token_approvals, apphash, (from, approval.spender))){
              case(null) {};
              case(?val) {
                switch(approval.expected_allowance){
                  case(null) {};
                  case(?expected){
                    if(expected != val.amount){
                      return #trappable(#Err(#AllowanceChanged({current_allowance = val.amount})));
                    };
                  }
                };
              };
            };

            //test that the memo is not too large
            let ?(memo) = environment.icrc1.testMemo(approval.memo) else return #err(#trappable("invalid memo. must be less than " # debug_show(environment.icrc1.get_state().max_memo) # " bits"));

            //test that the expires is not in the past
            let ?(expires_at) = testExpiresAt(approval.expires_at) else return #trappable(#Err(#Expired({ledger_time = environment.icrc1.get_time64()})));

            //check from and spender account not equal
            if(account_eq(from, approval.spender)){
              return #err(#trappable("cannot approve tokens to same account"));
            };

            let current_approvals = switch(Map.get(state.indexes.owner_to_approval_account, ahash, from)){
              case(?val){
                Set.size(val);
              };
              case(null) 0;
            };

            debug if(debug_channel.approve) D.print("number of approvals" # debug_show(current_approvals));

            if(current_approvals >= state.ledger_info.max_approvals_per_account){
              return #err(#trappable("Too many approvals from account" # debug_show(from)))
            };

            //make sure the approval is not too old or too far in the future
            switch(environment.icrc1.testCreatedAt(approval.created_at_time)){
              case(#ok(val)) {};
              case(#Err(#TooOld)) return #trappable(#Err(#TooOld));
              case(#Err(#InTheFuture(val))) return  #trappable(#Err(#CreatedInFuture({ledger_time = environment.icrc1.get_time64()})));
            };


            if(approval.spender.owner == from.owner) return #err(#trappable("cannot spend yourself")); //can't make yourself a spender;

            //validate the fee
            if(not validate_fee(calculated_fee, approval.fee)){
              return #trappable(#Err(#BadFee({expected_fee = calculated_fee})));
            };

            return #trappable(#Ok(0));

          };

    /// # validate_transfer_from
    ///
    /// Validates the parameters and the state of the ledger for a transfer request made on behalf of a spender.
    ///
    /// ## Parameters
    ///
    /// - `spender`: `Account` - The account that has been authorized to spend tokens from the `from` account.
    /// - `transfer`: `TransferFromArgs` - The transfer request details, including the source, destination, amount, and fees.
    /// - `calculated_fee`: `Balance` - The required fee for processing the transfer request.
    /// - `clean`: `Bool` - A flag indicating whether to clean up (remove) expired approvals.
    ///
    /// ## Returns
    ///
    /// `Star<TransferFromResponse, Text>, ?ApprovalInfo` - A tuple with a Star type result that contains either a transfer response indicating success or an error message, paired with an optional ApprovalInfo object reflecting the spender's current approval.
    ///
    /// ## Remarks
    ///
    /// This function performs similar validations as `validate_approval` but specific to the transfer-from action.
    /// It also checks that the spender's allowance is sufficient and decreases it by the transfer amount and fees if the operation proceeds.
    public func validate_transfer_from(spender: Account, transfer : TransferFromArgs,
    calculated_fee : MigrationTypes.Current.Balance, clean : Bool): (Result.Result<TransferFromResponse, Text>, ?ApprovalInfo){

      if (not ICRC1.AccountHelper.validate(transfer.from)) {
          return (#err("Invalid account entered for from. "), null);
      };

      if (not ICRC1.AccountHelper.validate(spender)) {
          return (#err("Invalid account entered for spender. "), null);
      };

      let balance = environment.icrc1.balance_of(transfer.from);

      if(calculated_fee + transfer.amount > balance){
        return (#ok(#Err(#InsufficientFunds({balance = balance}))), null);
      };

      debug if(debug_channel.transfer) D.print("about to validate approval" # debug_show((transfer, Iter.toArray(Map.entries(state.token_approvals)))));

      //check the expected allowance
      let currentApproval = switch(Map.get(state.token_approvals, apphash, (transfer.from, spender))){
        case(null) return (#ok(#Err(#InsufficientAllowance({allowance = 0}))), null);
        case(?val) {
          if(val.amount < transfer.amount + calculated_fee){
            return (#ok(#Err(#InsufficientAllowance({allowance = val.amount}))), null);
          };
            val;
        };
      };

      //test that the memo is not too large
      let ?(memo) = environment.icrc1.testMemo(transfer.memo) else return (#err("invalid memo. must be less than " # debug_show(environment.icrc1.get_state().max_memo) # " bits"), null);

      //test that the expires is not in the past
      let ?(expires_at) = testExpiresAt(currentApproval.expires_at) else{
        if(clean){
          ignore Map.remove<(Account,Account), ApprovalInfo>(state.token_approvals, apphash, (transfer.from, spender));
          unIndex(transfer.from, spender);
        };
        return (#ok(#Err(#InsufficientAllowance({allowance = 0}))), null)
      };

      //check from and spender account not equal
      if(account_eq(transfer.from, spender)){
        return (#err("cannot approve tokens to same account"), null);
      };

      //make sure the transfer from is not too old or too far in the future
      switch(environment.icrc1.testCreatedAt(transfer.created_at_time)){
        case(#ok(val)) {};
        case(#Err(#TooOld)) return (#ok(#Err(#TooOld)), null);
        case(#Err(#InTheFuture(val))) return  (#ok(#Err(#CreatedInFuture({ledger_time = environment.icrc1.get_time64()}))), null);
      };


      if(spender.owner == transfer.from.owner) return (#err("cannot spend yourself"), null); //can't make yourself a spender;

      //validate the fee
      if(not validate_fee(calculated_fee, transfer.fee)){
        return (#ok(#Err(#BadFee({expected_fee = calculated_fee}))), null);
      };

      //validate a burn
      switch(environment.icrc1.get_state().min_burn_amount){
        case(?min_burn_amount){
          if(ICRC1.account_eq(transfer.from, environment.icrc1.minting_account())){
            if(transfer.amount < min_burn_amount){
              return (#ok(#Err(#BadBurn({min_burn_amount = min_burn_amount}))), null);
            };
          };
        };
        case(_){};
      };

      return ((#ok(#Ok(0)), ?currentApproval));

    };

    
    /// # `approve`
    /// Warning: This functions traps and we highly recommend using transfer_tokens_from instead to manage trapping and awaiting behavior
    ///
    /// Approves a given spender to transfer up to a specified number of tokens from the caller's account,
    /// with the possibility of expiry, based on the ICRC-2 standards.
    ///
    /// ## Parameters
    ///
    /// - `caller`: `Principal` - The principal of the user invoking the approve.
    /// - `approval`: `ApproveArgs` - The approval request arguments.
    /// - `system_override`: `Bool` - A flag indicating whether the approval constraints should be enforced.
    ///
    /// ## Returns
    ///
    /// `Star<ApproveResponse, Text>`: Returns either Ok with a Nat representing the transaction id or an
    /// error text if the approval could not be processed.
    ///
    /// ## Example
    ///
    /// ```
    /// let callerPrincipal = Principal.fromText("your-principal-here");
    /// let targetSpenderAccount = {owner = targetPrincipal, subaccount = null};
    /// let approveArgs = {spender = targetSpenderAccount, amount = 10_000, ...};
    ///
    /// let result = await myICRC2Instance.approve_transfers(callerPrincipal, approveArgs, false);
    /// ```
    public func approve(caller: Principal, approval: ApproveArgs) : async* ApproveResponse{
      switch( await* approve_transfers(caller, approval, false,  null)){
          case(#trappable(val)) val;
          case(#awaited(val)) val;
          case(#err(#trappable(err))) D.trap(err);
          case(#err(#awaited(err))) D.trap(err);
        };

    };
    

    /// # `approve_transfers`
    ///
    /// Approves a given spender to transfer up to a specified number of tokens from the caller's account,
    /// with the possibility of expiry, based on the ICRC-2 standards.
    ///
    /// ## Parameters
    ///
    /// - `caller`: `Principal` - The principal of the user invoking the approve.
    /// - `approval`: `ApproveArgs` - The approval request arguments.
    /// - `system_override`: `Bool` - A flag indicating whether the approval constraints should be enforced.
    ///
    /// ## Returns
    ///
    /// `Star<ApproveResponse, Text>`: Returns either Ok with a Nat representing the transaction id or an
    /// error text if the approval could not be processed.
    ///
    /// ## Example
    ///
    /// ```
    /// let callerPrincipal = Principal.fromText("your-principal-here");
    /// let targetSpenderAccount = {owner = targetPrincipal, subaccount = null};
    /// let approveArgs = {spender = targetSpenderAccount, amount = 10_000, ...};
    ///
    /// let result = await myICRC2Instance.approve_transfers(callerPrincipal, approveArgs, false);
    /// ```
    public func approve_transfers(caller: Principal, approval: ApproveArgs, system_override: Bool, canApprove : CanApprove) : async* Star.Star<ApproveResponse, Text> {

      let from = {owner= caller; subaccount = approval.from_subaccount};


      //check the caller has enough for the fee
      let fee = get_fee(approval);

      switch(Star.toResult(validate_approval(from, approval, fee, system_override))){
        case(#ok(val)){
          switch(val){
            case(#Ok(_)){};
            case(#Err(err)){
              return #trappable(#Err(err));
            };
          };
        };
        case(#err(err)){
          return #err(#trappable(err));
        }
      };

      let trx = Vec.new<(Text, Value)>();
      let trxtop = Vec.new<(Text, Value)>();

      let amount_to_use = switch(state.ledger_info.max_allowance){
        case(null){
          Vec.add(trx,("amt", #Nat(approval.amount)));
          approval.amount;
        };
        case(?#TotalSupply){
          let total_supply = environment.icrc1.total_supply();
          debug if(debug_channel.approve) D.print("limiting by total supply" # debug_show(total_supply));
          if(approval.amount > total_supply){
            let next_total_supply = total_supply - fee;
            Vec.add(trx,("amt", #Nat(approval.amount)));
            Vec.add(trxtop,("amt", #Nat(next_total_supply)));
            next_total_supply;
          } else {
            Vec.add(trx,("amt", #Nat(approval.amount)));
            approval.amount;
          };
        };
        case(?#Fixed(val)){
          if(approval.amount > val){
            Vec.add(trx,("amt", #Nat(approval.amount)));
            Vec.add(trxtop,("amt", #Nat(val)));
            val;
          } else {
            Vec.add(trx,("amt", #Nat(approval.amount)));
            approval.amount;
          };
        };
      };

      

      
      switch(environment.icrc1.testMemo(approval.memo)){
        case(?null){};
        case(??val){
          Vec.add(trx,("memo", #Blob(val)));
        };
        case(_){}; //unreachable if called from approve_transfers
      };

      //test that the expires is not in the past
      switch(testExpiresAt(approval.expires_at)){
        case(?null){};
        case(??val){
          Vec.add(trx,("expires_at", #Nat(Nat64.toNat(val))));
        };
        case(_){}; //unreachable if called from approve_transfers
      };

      switch(approval.expected_allowance){
        case(null){};
        case(?val){
          Vec.add(trx,("expected_allowance", #Nat(val)));
        };
      };

      //test that the expires is not in the past
      switch(approval.created_at_time){
        case(null){};
        case(?val){
          Vec.add(trx,("ts", #Nat(Nat64.toNat(val))));
        };
      };

      Vec.add(trx,("op", #Text("approve")));

      Vec.add(trxtop,("ts", #Nat(Nat64.toNat(environment.icrc1.get_time64()))));
      Vec.add(trxtop,("btype", #Text("2approve")));

      Vec.add(trx,("from", ICRC1.UtilsHelper.accountToValue({owner = caller; subaccount = approval.from_subaccount})));

      Vec.add(trx,("spender",  ICRC1.UtilsHelper.accountToValue(approval.spender)));

      //check for duplicate
      let pretrxhash = Blob.fromArray(RepIndy.hash_val(#Map(Vec.toArray(trx))));

      debug if(debug_channel.approve) D.print("trying dedupe for " # debug_show(trx, pretrxhash));

      switch(environment.icrc1.find_dupe(pretrxhash)){
        case(?found){
          return #trappable(#Err(#Duplicate({duplicate_of = found})));
        };
        case(null){};
      };

      let txMap = #Map(Vec.toArray(trx));
      let txTopMap = #Map(Vec.toArray(trxtop));

      

      var bAwaited = false;

      let(finaltx, finaltxtop, tokenApprovalNotification) : (Value, ?Value, TokenApprovalNotification) = do{
          let preNotification : TokenApprovalNotification = {
            spender = approval.spender;
            amount = amount_to_use;
            requested_amount = approval.amount;
            expected_allowance = approval.expected_allowance;
            from = {
              owner = caller; 
              subaccount = approval.from_subaccount
            };
            fee = approval.fee;
            calculated_fee = fee;
            created_at_time = approval.created_at_time;
            memo = approval.memo;
            expires_at = approval.expires_at;
          };

          switch(canApprove){
            case(null){
              (txMap, ?txTopMap, preNotification);
            };
            case(?#Sync(remote_func)){
              switch(remote_func<system>(txMap, ?txTopMap, preNotification)){
                case(#ok(val)) val;
                case(#err(tx)){
                  return #trappable(#Err(#GenericError({error_code = 100; message=tx})));
                };
              };
            };
            case(?#Async(remote_func)){
              //we need to temporarily add this in case of await....have to put trx id 0 since it isn't finalized
              ignore Map.put<Blob, (Nat64,Nat)>(environment.icrc1.get_state().recent_transactions, Map.bhash, pretrxhash, (environment.icrc1.get_time64(), 0));

              bAwaited := true;
              switch(await* remote_func(txMap, ?txTopMap, preNotification)){
                case(#trappable(val)) val;
                case(#awaited(val)){
                  //revalidate 
                  let override_fee = val.2.calculated_fee;
                  switch (Star.toResult(validate_approval(from, {
                    amount = val.2.amount;
                    requested_amount = val.2.requested_amount;
                    created_at_time = val.2.created_at_time;
                    fee = val.2.fee;
                    spender = val.2.spender;
                    expected_allowance = val.2.expected_allowance;
                    expires_at = val.2.expires_at;
                    from_subaccount = val.2.from.subaccount;
                    memo = val.2.memo;
                    }, override_fee, system_override))) {
                      case (#err(errorType)) {
                          return #err(#awaited(errorType));
                      };
                      case (#ok(val)) {
                          switch(val){
                            case(#Err(err)){
                              return #awaited(#Err(err));
                            };
                            case(#Ok(_)){};
                          };
                      };
                     
                    };
                  val;
                };
                case(#err(#awaited(tx))){
                  return #awaited(#Err(#GenericError({error_code= 100; message=tx})));
                };
                case(#err(#trappable(tx))){
                  return #trappable(#Err(#GenericError({error_code= 100; message=tx})));
                };
              };
            };
          };
      };

      var finaltxtop_var = finaltxtop;

      let final_fee = tokenApprovalNotification.calculated_fee;

      let icrc1state = environment.icrc1.get_state();

      // burn fee
      if(final_fee > 0){
        switch(icrc1state.fee_collector){
          case(null){
            ICRC1.UtilsHelper.burn_balance(icrc1state, from, final_fee);
          };
          case(?val){
              
            if(fee > 0){
              if(icrc1state.fee_collector_emitted){
                finaltxtop_var := switch(ICRC1.UtilsHelper.insert_map(finaltxtop, "fee_collector_block", #Nat(icrc1state.fee_collector_block))){
                  case(#ok(val)) ?val;
                  case(#err(err)) return if(bAwaited){
                    #err(#awaited("unreachable map addition"));
                  } else {
                    #err(#trappable("unreachable map addition"));
                  };
                };
              } else {
                finaltxtop_var := switch(ICRC1.UtilsHelper.insert_map(finaltxtop, "fee_collector", ICRC1.UtilsHelper.accountToValue(val))){
                  case(#ok(val)) ?val;
                  case(#err(err)) return if(bAwaited){
                    #err(#awaited("unreachable map addition"));
                  } else {
                    #err(#trappable("unreachable map addition"));
                  };
                };
              };
            };

            ICRC1.UtilsHelper.transfer_balance(icrc1state,{
              tokenApprovalNotification with
              kind = #transfer;
              to = val;
              amount = final_fee;
            });
          };
        };
      };

      let transaction_id = switch(environment.icrc1.get_environment().add_ledger_transaction){
        case(null){
          // warning: local ledgers do not support transfer from details and ledger state may be lost.
            let tx = ICRC1.UtilsHelper.req_to_tx({
              //icrc1 doesn't have a transfer from so we have to fake it
              kind = #transfer;
              from = tokenApprovalNotification.from;
              calculated_fee = final_fee;
              to = tokenApprovalNotification.spender;
              amount = 0;
              fee = tokenApprovalNotification.fee;
              memo = approval.memo;
              created_at_time = tokenApprovalNotification.created_at_time;
            }, Vec.size(environment.icrc1.get_state().local_transactions));

            environment.icrc1.add_local_ledger(tx);
          };
          case(?val) val(finaltx, finaltxtop);
      };

      //approvals overwrite
      debug if(debug_channel.approve) D.print("overwritting approval - " # debug_show(tokenApprovalNotification, Iter.toArray(Map.entries(state.token_approvals))));

      ignore Map.put<(Account,Account),ApprovalInfo>(state.token_approvals, apphash, (tokenApprovalNotification.from, tokenApprovalNotification.spender), {
        from_subaccount = tokenApprovalNotification.from.subaccount;
        spender = tokenApprovalNotification.spender;
        amount = tokenApprovalNotification.amount;
        expires_at = tokenApprovalNotification.expires_at;
      });

      debug if(debug_channel.approve) D.print("after overwrite - " #debug_show(tokenApprovalNotification, Iter.toArray(Map.entries(state.token_approvals))));

      //populate the index
      let existingIndex = switch(Map.get<Account, Set.Set<Account>>(state.indexes.owner_to_approval_account, ahash, tokenApprovalNotification.from)){
        case(null){
          debug if(debug_channel.approve) D.print("adding new index " # debug_show(tokenApprovalNotification.from));
          let newIndex = Set.new<Account>();
          ignore Map.put<Account,Set.Set<Account>>(state.indexes.owner_to_approval_account, ahash, tokenApprovalNotification.from, newIndex);
          newIndex;
        };
        case(?val) val;
      };

      Set.add<Account>(existingIndex, ahash, approval.spender);
      

      //populate the index
      let existingIndex2 = switch(Map.get<Account, Set.Set<Account>>(state.indexes.spender_to_approval_account, ahash, tokenApprovalNotification.spender)){
        case(null){
          debug if(debug_channel.approve) D.print("adding new index " # debug_show(tokenApprovalNotification.spender));
          let newIndex = Set.new<Account>();
          ignore Map.put<Account,Set.Set<Account>>(state.indexes.spender_to_approval_account, ahash, tokenApprovalNotification.from, newIndex);
          newIndex;
        };
        case(?val) val;
      };

      Set.add<Account>(existingIndex2, ahash, tokenApprovalNotification.from);

      let posttrxhash = Blob.fromArray(RepIndy.hash_val(finaltx));
      

      ignore Map.put<Blob, (Nat64,Nat)>(environment.icrc1.get_state().recent_transactions, Map.bhash, posttrxhash, (environment.icrc1.get_time64(), transaction_id));

      if(bAwaited){
        ignore Map.put<Blob, (Nat64,Nat)>(environment.icrc1.get_state().recent_transactions, Map.bhash, pretrxhash, (environment.icrc1.get_time64(), transaction_id));
      };
      
  
  
      for(thisEvent in Vec.vals(token_approved_listeners)){
        thisEvent.1<system>(tokenApprovalNotification, transaction_id);
      };
      

      environment.icrc1.cleanUpRecents();
      debug if(debug_channel.approve) D.print("Done Cleaning ");
      cleanUpApprovalsRoutine<system>();
      debug if(debug_channel.approve) D.print("Done clean up approvals " );

      debug if(debug_channel.approve) D.print("Finished putting approval " # debug_show(approval));

      if(bAwaited == true){
        return(#awaited(#Ok(transaction_id)));
      } else {
        return(#trappable(#Ok(transaction_id)));
      };

    };

    /// # testExpiresAt
    ///
    /// Verifies that a given expiration timestamp is not in the past relative to the ledger's current time.
    ///
    /// ## Parameters
    ///
    /// - `val`: `?Nat64` - An optional expiration timestamp to be validated. Can be `null` to indicate the absence of an expiration time.
    ///
    /// ## Returns
    ///
    /// `??Nat64` - An optional optional Nat64 which will return `null` if the provided timestamp is in the past, 
    /// or the timestamp itself if it's a valid future timestamp.
    ///
    /// ## Remarks
    ///
    /// This function checks the expiration timestamp against the ledger's current time, accessed via the environment's `icrc1` interface.
    ///
    private func testExpiresAt(val : ?Nat64) : ??Nat64{
      switch(val){
        case(null) return ?null;
        case(?val){
          if(val < environment.icrc1.get_time64()){
            return null;
          };
          return ??val;
        };
      };
    };

    


    /// Checks if the specified account is approved for the provided amount.
    /// - Parameters:
    ///     - spender: `Account` - The account whose approval status is being queried.
    ///     - from: `Account` - The account tha has approved the amount
    ///     - clean: Bool - For update queries use this set to true to remove expired items
    /// - Returns: `Bool` - A boolean indicating if the spender is approved for the specified token.
    public func allowance(spender : Account, from: Account, clean: Bool) : Allowance {

      debug if(debug_channel.announce) D.print("is_approved " # debug_show(spender, from));

      switch(Map.get<(Account,Account), ApprovalInfo>(state.token_approvals, apphash, (from, spender))){
        case(null){ return { allowance = 0; expires_at = null}};
        case(?val){
          switch(val.expires_at){
            case(?expires_at){
              if(environment.icrc1.get_time64() > expires_at){
                if(clean){
                  ignore Map.remove<(Account,Account), ApprovalInfo>(state.token_approvals, apphash, (from, spender));
                  unIndex(from,spender);
                };
                return {allowance = 0; expires_at = null};
              } else {
                return {allowance = val.amount; expires_at = val.expires_at};
              }
            };
            case(null) {
              return {allowance = val.amount; expires_at = val.expires_at};
            };
          };
        };
      };
    };

    

    

    /// # cleanUpApprovalsRoutine
    ///
    /// Triggers the cleanup process for approvals, removing expired approvals and ensuring the total count stays within the configured limits.
    ///
    /// ## Remarks
    ///
    /// This routine is invoked to manage the state of the ledger's approvals. If the map of token approvals exceeds the maximum configured approval count, it first attempts to delete expired approvals and, if necessary, other approvals until the count is at the desired threshold.
    public func cleanUpApprovalsRoutine<system>() : () {
      if(Map.size(state.token_approvals) > state.ledger_info.max_approvals){
        cleanUpExpiredApprovals(state.ledger_info.settle_to_approvals);
      };
      if(Map.size(state.token_approvals) > state.ledger_info.max_approvals){
        cleanUpApprovals<system>(state.ledger_info.settle_to_approvals);
      };
    };

    /// # unIndex
    ///
    /// Removes index entries mapped from the `from` account to the spender account, and from the spender account to the `from` account.
    ///
    /// ## Parameters
    ///
    /// - `from`: `Account` - The account from which approvals will be removed.
    /// - `spender`: `Account` - The spender's account related to the approval entries to be removed.
    ///
    /// ## Remarks
    ///
    /// The function modifies two internal maps, `owner_to_approval_account` and `spender_to_approval_account`,
    /// effectively disassociating the `spender` from the `from` account and vice versa.
    ///
    func unIndex(from: Account, spender: Account) : (){
      switch(Map.get(state.indexes.owner_to_approval_account, ahash, from)){
        case(?set){
          ignore Set.remove(set, ahash, spender)
        };
        case(null){}; //unreachable
      };
      switch(Map.get(state.indexes.spender_to_approval_account, ahash, spender)){
        case(?set){
          ignore Set.remove(set, ahash, from)
        };
        case(null){}; //unreachable
      };
    };

    /// # cleanUpExpiredApprovals
    ///
    /// Iterates over current token approvals and removes any that have expired based on their set expiration time.
    ///
    /// ## Parameters
    ///
    /// - `remaining`: `Nat` - The target number of approvals to retain. The clean-up process will stop once this count is reached or goes below.
    ///
    /// ## Remarks
    ///
    /// The function will remove the oldest expired approvals first, and it is triggered when the total number of approvals
    /// exceeds a defined threshold.
    ///
    public func cleanUpExpiredApprovals(remaining: Nat) : (){
      //this naievly delete the oldest items until the collection is equal or below the remaining value
    
      label clean for(thisItem in Map.entries<(Account,Account), ApprovalInfo>(state.token_approvals)){

        switch(thisItem.1.expires_at){
          case(?val){
            if(val < environment.icrc1.get_time64()){
              ignore Map.remove(state.token_approvals, apphash, thisItem.0);
              //unindex
              unIndex(thisItem.0.0, thisItem.0.1);
            };
          };
          case(null) continue clean;
        };

        //do not have to log the removal of expired items
        if(Map.size(state.token_approvals) <= remaining) break clean;
      };
    
    };

    /// # cleanUpApprovals
    ///
    /// Iterates over current token approvals and removes them, reducing the collection to a specified target size.
    ///
    /// ## Parameters
    ///
    /// - `remaining`: `Nat` - The target number of approvals to retain. The clean-up process will stop once this count is reached or goes below.
    ///
    /// ## Remarks
    ///
    /// This method does not consider the expiry of approvals and should be used to reduce the total number of current approvals
    /// to a manageable size, regardless of their expiration status.
    ///
    public func cleanUpApprovals<system>(remaining: Nat) : (){
      //this naievly delete the oldest items until the collection is equal or below the remaining value
      let memo = Text.encodeUtf8("icrc2_system_clean");
    
      label clean for(thisItem in Map.entries<(Account,Account), ApprovalInfo>(state.token_approvals)){

      
            
        ignore Map.remove(state.token_approvals, apphash, thisItem.0);
        //unindex
        unIndex(thisItem.0.0, thisItem.0.1);
          
        let trx = Vec.new<(Text, Value)>();
        let trxtop = Vec.new<(Text, Value)>();
        Vec.add(trx, ("op", #Text("approve")));
        Vec.add(trxtop,("btype", #Text("2approve")));
        Vec.add(trxtop, ("ts", #Nat(Nat64.toNat(environment.icrc1.get_time64()))));
        Vec.add(trx, ("from", ICRC1.UtilsHelper.accountToValue(thisItem.0.0)));
        Vec.add(trx, ("spender", ICRC1.UtilsHelper.accountToValue(thisItem.0.1)));
        Vec.add(trxtop, ("memo", #Blob(memo)));
        let txMap = #Map(Vec.toArray(trx));
        let txTopMap = #Map(Vec.toArray(trxtop));
        let preNotification =  {
              spender = thisItem.1.spender;
              amount = 0;
              requested_amount =0;
              expected_allowance = null;
              from = thisItem.0.0;
              fee = null;
              calculated_fee = 0;
              created_at_time = null;
              memo = ?memo;
              expires_at = null;
            };

        //implment ledger;
        let transaction_id = switch(environment.icrc1.get_environment().add_ledger_transaction){
          case(null){
            // warning: local ledgers do not support transfer from details and ledger state may be lost.
            let tx = ICRC1.UtilsHelper.req_to_tx({
              
              kind = #transfer;
              from = preNotification.from;
              to = preNotification.spender;
              calculated_fee = 0;
              amount = 0;
              fee = preNotification.fee;
              memo = preNotification.memo;
              created_at_time = preNotification.created_at_time;
            }, Vec.size(environment.icrc1.get_state().local_transactions));

            //use local ledger. This will not scale
            environment.icrc1.add_local_ledger(tx);
          };
          case(?val) val(txMap, ?txTopMap);
        };

        for(thisEvent in Vec.vals(token_approved_listeners)){
          thisEvent.1<system>(preNotification, transaction_id);
        };
          

        if(Map.size(state.token_approvals) <= remaining) break clean;
      };
    
    };

    // events

    type Listener<T> = (Text, T);

    /// Generic function to register a listener.
    ///
    /// Parameters:
    ///     namespace: Text - The namespace identifying the listener.
    ///     remote_func: T - A callback function to be invoked.
    ///     listeners: Vec<Listener<T>> - The list of listeners.
    public func register_listener<T>(namespace: Text, remote_func: T, listeners: Vec.Vector<Listener<T>>) {
      let listener: Listener<T> = (namespace, remote_func);
      switch(Vec.indexOf<Listener<T>>(listener, listeners, func(a: Listener<T>, b: Listener<T>) : Bool {
        Text.equal(a.0, b.0);
      })){
        case(?index){
          Vec.put<Listener<T>>(listeners, index, listener);
        };
        case(null){
          Vec.add<Listener<T>>(listeners, listener);
        };
      };
    };



    /// # register_token_approved_listener
    ///
    /// Registers a listener that will be triggered after a successful token approval operation.
    ///
    /// ## Parameters
    ///
    /// - `namespace`: `Text` - A unique name identifying the listener.
    /// - `remote_func`: `TokenApprovalListener` - A callback function that will be invoked with token approval notifications.
    ///
    /// ## Remarks
    ///
    /// The registered listener callback function receives notifications containing details about the token approval operation and the corresponding transaction ID. It is useful for tracking delegation events as token owners grant spend permissions to third parties.
    public func register_token_approved_listener(namespace: Text, remote_func : TokenApprovalListener){
      register_listener<TokenApprovalListener>(namespace, remote_func, token_approved_listeners);
    };


    /// # register_transfer_from_listener
    ///
    /// Registers a listener that will be triggered after a successful transfer-from operation.
    ///
    /// ## Parameters
    ///
    /// - `namespace`: `Text` - A unique name identifying the listener.
    /// - `remote_func`: `TransferFromListener` - A callback function that will be invoked with transfer-from notifications.
    ///
    /// ## Remarks
    ///
    /// The registered listener callback function receives notifications containing details about the transfer-from operation and the corresponding transaction ID. It is useful for client applications or other canisters to react to state changes due to token transfers on behalf of a spender.
    public func register_transfer_from_listener(namespace: Text, remote_func : TransferFromListener){
      register_listener<TransferFromListener>(namespace, remote_func, transfer_from_listeners);
    };

    

    //ledger mangement

    /// Updates ledger information such as approval limitations with the provided request.
    /// - Parameters:
    ///     - request: `[UpdateLedgerInfoRequest]` - A list of requests containing the updates to be applied to the ledger.
    /// - Returns: `[Bool]` - An array of booleans indicating the success of each update request.
    public func update_ledger_info(request: [UpdateLedgerInfoRequest]) : [Bool]{
      
      //todo: Security at this layer?

      let results = Vec.new<Bool>();
      for(thisItem in request.vals()){
        switch(thisItem){
          
          case(#MaxApprovalsPerAccount(val)){state.ledger_info.max_approvals_per_account := val};
          case(#MaxApprovals(val)){state.ledger_info.max_approvals := val};
          case(#MaxAllowance(val)){state.ledger_info.max_allowance := val};
          case(#SettleToApprovals(val)){state.ledger_info.settle_to_approvals := val};
          
          case(#Fee(fee)){
            state.ledger_info.fee := fee;
          }
        };
        Vec.add(results, true);
      };

      ignore init_metadata();
      return Vec.toArray(results);
    };

    /// Event callback that is triggered post token transfer, used to revoke any approvals upon ownership change.
    /// - Parameters:
    ///     - from: `?Account` - The previous owner's account.
    ///     - to: `Account` - The new owner's account.
    ///     - trx_id: `Nat` - The unique identifier for the transfer transaction.
    private func token_transferred<system>(transfer: Transaction, trx_id: Nat) : (){
      //todo: nothing now but maybe we remove approvals of balances that go to 0?
    };

    //registers the private token_transfered event with the ICRC7 component so that approvals can be cleared when a token is transfered.
    environment.icrc1.register_token_transferred_listener("icrc2", token_transferred);


    /// # transfer_token
    ///
    /// Processes token transfers under the ICRC-2 standard, including fee validation and actually moving tokens.
    ///
    /// ## Parameters
    ///
    /// - `caller`: `Principal` - The principal of the user (or canister) initiating the transfer.
    /// - `transferFromArgs`: `TransferFromArgs` - The arguments detailing the transfer-from operation.
    ///
    /// ## Returns
    ///
    /// `Star<TransferFromResponse, Text>` - A response type capturing the outcome of the transfer operation which may include a transaction ID on success or an error message.
    ///
    /// ## Remarks
    ///
    /// This function combines validation with actual state changes, fee deductions, and transaction logging. When the transfer is complete, event listeners are notified of the change, and the internal approval state is updated to reflect the new balances.
    private func transfer_token<system>(caller: Principal, transferFromArgs: TransferFromArgs, canTransferFrom : CanTransferFrom) : async* Star.Star<TransferFromResponse, Text> {

        let spender = {owner = caller; subaccount = transferFromArgs.spender_subaccount};

        let fee = environment.icrc1.get_fee({
          from_subaccount = transferFromArgs.from.subaccount;
          to = transferFromArgs.to;
          amount = transferFromArgs.amount;
          fee = transferFromArgs.fee;
          memo = transferFromArgs.memo;
          created_at_time = transferFromArgs.created_at_time;
        });

        debug if(debug_channel.transfer) D.print("fee will be " # debug_show(fee));

        var current_approval = switch(validate_transfer_from(spender, transferFromArgs, fee, true)){
          case((#ok(val), approval)){
            switch(val){
              case(#Ok(_)){
                switch(approval){
                  case(null) return #err(#trappable("unreachable"));//unreachable;
                  case(?val) val;
                }
              };
              case(#Err(err)){
                return #trappable(#Err(err));
              };
            };
          };
          case((#err(err), _)){
            return #err(#trappable(err));
          };
        };

        debug if(debug_channel.transfer) D.print("have current approval " # debug_show(current_approval));

        let trx = Vec.new<(Text, Value)>();
        let trxtop = Vec.new<(Text, Value)>();

        switch(transferFromArgs.memo){
          case(null){};
          case(?val){
            Vec.add(trx,("memo", #Blob(val)));
          };
        };

        switch(transferFromArgs.created_at_time){
          case(null){};
          case(?val){
            Vec.add(trx,("ts", #Nat(Nat64.toNat(val))));
          };
        };

        Vec.add(trx,("ts", #Nat(Nat64.toNat(environment.icrc1.get_time64()))));
        Vec.add(trx,("op", #Text("xfer")));
        Vec.add(trxtop,("btype", #Text("2xfer")));
        
        Vec.add(trx,("from", ICRC1.UtilsHelper.accountToValue(transferFromArgs.from)));
        Vec.add(trx,("to", ICRC1.UtilsHelper.accountToValue(transferFromArgs.to)));

        Vec.add(trx,("amt", #Nat(transferFromArgs.amount)));
     
        Vec.add(trx,("spender", ICRC1.UtilsHelper.accountToValue(spender)));

        let txMap = #Map(Vec.toArray(trx));
        let txTopMap = #Map(Vec.toArray(trxtop));
        let preNotification : TransferFromNotification = {
          spender = spender;
          from = transferFromArgs.from;
          to = transferFromArgs.to;
          calculated_fee = fee;
          fee = transferFromArgs.fee;
          amount = transferFromArgs.amount;
          created_at_time = transferFromArgs.created_at_time;
          memo = transferFromArgs.memo;
        };

        //check for duplicate
        var pretrxhash = Blob.fromArray(RepIndy.hash_val(#Map(Vec.toArray(trx))));

        debug if(debug_channel.approve) D.print("trying dedupe for " # debug_show(trx, pretrxhash));

        switch(environment.icrc1.find_dupe(pretrxhash)){
          case(?found){
            return #trappable(#Err(#Duplicate({duplicate_of = found})));
          };
          case(null){};
        };

         debug if(debug_channel.transfer) D.print("ready with a prenotification " # debug_show(preNotification));

        var bAwaited = false;

        let(finaltx, finaltxtop, notification) : (Value, ?Value, TransferFromNotification) = switch(canTransferFrom){
          case(null){
            (txMap, ?txTopMap, preNotification);
          };
          case(?#Sync(remote_func)){
              switch(remote_func<system>(txMap, ?txTopMap, preNotification)){
                case(#ok(val)) val;
                case(#err(tx)){
                  return #trappable(#Err(#GenericError({error_code = 100; message=tx})));
                };
              };
          };
          case(?#Async(remote_func)){
            ignore Map.put<Blob, (Nat64,Nat)>(environment.icrc1.get_state().recent_transactions, Map.bhash, pretrxhash, (environment.icrc1.get_time64(), 0));
            bAwaited := true;
            switch(await* remote_func(txMap, ?txTopMap, preNotification)){
              case(#trappable(val)) val;
              case(#awaited(val)){

                let override_fee = val.2.calculated_fee;
                //revalidate 
                current_approval := switch (validate_transfer_from(spender, {
                  amount = val.2.amount;
                  created_at_time = val.2.created_at_time;
                  fee = val.2.fee;
                  spender_subaccount = val.2.spender.subaccount;
                  from = val.2.from;
                  to = val.2.to;
                  memo = val.2.memo;
                  }, override_fee, true)) {
                    case((#ok(val), approval)){
                      switch(val){
                        case(#Ok(_)){
                          switch(approval){
                            case(null) return #err(#awaited("unreachable"));//unreachable;
                            case(?val) val;
                          }
                        };
                        case(#Err(err)){
                          return #awaited(#Err(err));
                        };
                      };
                    };
                    case((#err(err), _)){
                      return #err(#awaited(err));
                    };
                    
                  };
                val;
              };
              case(#err(#awaited(tx))){
                return #awaited(#Err(#GenericError({error_code= 100; message=tx})));
              };
              case(#err(#trappable(tx))){
                return #trappable(#Err(#GenericError({error_code= 100; message=tx})));
              };
            };
          };
        };

        //if we have reached this point, we are ready to move the tokens and add to the transaction log

        debug if(debug_channel.transfer) D.print("ready to move tokens " # debug_show(preNotification));

        let final_fee = notification.calculated_fee;
        var finaltxtop_var = finaltxtop;

        let icrc1state = environment.icrc1.get_state();

        let tx_req = if(account_eq(environment.icrc1.minting_account(), notification.to)){
            ICRC1.UtilsHelper.burn_balance(icrc1state, notification.from, notification.amount);
             {
                kind = #burn;
                from = notification.from;
                to = notification.to;
                amount = notification.amount;
                fee = notification.fee;
                calculated_fee = final_fee;
                memo = notification.memo;
                created_at_time = notification.created_at_time;
            }
        } else {
          
            
            let this_transfer = {
                kind = #transfer;
                from = notification.from;
                to = notification.to;
                amount = notification.amount;
                fee = notification.fee;
                calculated_fee = final_fee;
                memo = notification.memo;
                created_at_time = notification.created_at_time;
            };

            debug if(debug_channel.transfer) D.print("making the transfer " # debug_show(this_transfer));

            ICRC1.UtilsHelper.transfer_balance(environment.icrc1.get_state(), this_transfer);


            // burn fee
            if(final_fee > 0){
              switch(icrc1state.fee_collector){
                case(null){
                  ICRC1.UtilsHelper.burn_balance(icrc1state, this_transfer.from, final_fee);
                };
                case(?val){
                    
                  finaltxtop_var := switch(environment.icrc1.handleFeeCollector(final_fee, val, this_transfer, finaltxtop_var)){
                    case(#ok(val)) val;
                    case(#err(err)){
                      if(bAwaited){
                        return #awaited(#Err(#GenericError({error_code= 6453; message=err})));
                      } else {
                        return #trappable(#Err(#GenericError({error_code= 6453; message=err})));
                      };
                    };
                  };

                  ICRC1.UtilsHelper.transfer_balance(icrc1state,{
                    this_transfer with
                    kind = #transfer;
                    to = val;
                    amount = final_fee;
                  });
                };
              };
            };
            this_transfer
        };

        //remove the approved amount.
        if(current_approval.amount > notification.amount + fee){
          ignore Map.put(state.token_approvals, apphash, (notification.from, notification.spender), {
            current_approval with
            amount = current_approval.amount - (notification.amount + final_fee);
          });
        } else {
          ignore Map.remove(state.token_approvals, apphash, (notification.from, notification.spender));
          unIndex(notification.from, notification.spender);
        };  


        // store transaction
        let index = environment.icrc1.handleAddRecordToLedger(finaltx,finaltxtop_var, {amount = notification.amount;
                          calculated_fee = notification.calculated_fee;
                          created_at_time = notification.created_at_time;
                          fee = notification.fee;
                          from = notification.from;
                          kind = #transfer;
                          memo = notification.memo;
                          to = notification.to;});


        switch(icrc1state.fee_collector){
          case(?val){
            if(fee > 0){
              if(icrc1state.fee_collector_emitted){} else {
                icrc1state.fee_collector_block := index;
                icrc1state.fee_collector_emitted := true;
              };
            };
          };
          case(null){
          };
        };

        //add trx for dedupe
        let posttrxhash = Blob.fromArray(RepIndy.hash_val(finaltx));

        debug if (debug_channel.transfer) D.print("attempting to add recent" # debug_show(posttrxhash, finaltx));

        ignore Map.put<Blob, (Nat64, Nat)>(icrc1state.recent_transactions, Map.bhash, posttrxhash, (environment.icrc1.get_time64(), index));
        if(bAwaited){
          ignore Map.put<Blob, (Nat64,Nat)>(environment.icrc1.get_state().recent_transactions, Map.bhash, pretrxhash, (environment.icrc1.get_time64(), index));
        };

        for(thisItem in Vec.vals(transfer_from_listeners)){
          thisItem.1<system>(notification, index);
        };

        debug if(debug_channel.approve) D.print("cleaning " );
        environment.icrc1.cleanUpRecents();
        debug if(debug_channel.approve) D.print("Done clean up approvals " );
        
        switch(icrc1state.cleaning_timer){
          case(null){ //only need one active timer
            debug if(debug_channel.transfer) D.print("setting clean up timer");
            icrc1state.cleaning_timer := ?Timer.setTimer<system>(#seconds(0), environment.icrc1.checkAccounts);
          };
          case(_){}
        };

        debug if (debug_channel.transfer) D.print("done transfer");
        if(bAwaited){
          #awaited(#Ok(index));
        } else {
          #trappable(#Ok(index));
        };
    };


    /// Transfers tokens to a new owner as specified in the transferFromArgs.
    /// Warning: This functions traps and we highly recommend using transfer_tokens_from instead to manage trapping and awaiting behavior
    /// - Parameters:
    ///     - caller: `Principal` - The principal of the user initiating the transfer.
    ///     - transferFromArgs: `TransferFromArgs` - The arguments specifying the transfer details.
    /// - Returns: `Result<TransferFromResponse, Text>` - The result of the transfer operation, containing either a successful response or an error text.
    ///
    /// Example:
    /// ```motoko
    /// let transferResult = myICRC2Instance.transfer_from(
    ///   caller,
    ///   {
    ///     from = { owner = ownerPrincipal; subaccount = null };
    ///     to = { owner = recipientPrincipal; subaccount = null };
    ///     amount = 789;
    ///     memo = ?Blob.fromArray(Text.toArray("TransferMemo"));
    ///     created_at_time = ?1_615_448_461_000_000_000;
    ///     spender_subaccount = null;
    ///   }
    /// );
    /// ```
    ///
    public func transfer_from<system>(caller: Principal, transferFromArgs: TransferFromArgs) : async* TransferFromResponse {
      switch( await* transfer_tokens_from<system>(caller, transferFromArgs, null)){
          case(#trappable(val)) val;
          case(#awaited(val)) val;
          case(#err(#trappable(err))) D.trap(err);
          case(#err(#awaited(err))) D.trap(err);
        };
    };

    /// # `transfer_tokens_from`
    ///
    /// Initiates a token transfer from one account to another using the spender's account that has been given
    /// an allowance. It debits tokens from the 'from' account and credits them to the 'to' account,
    /// adjusting allowances as necessary, in accordance with the ICRC-2 standards.
    ///
    /// ## Parameters
    ///
    /// - `caller`: `Principal` - The principal of the spender attempting to transfer the tokens.
    /// - `transferFromArgs`: `TransferFromArgs` - The arguments specifying the transfer, including the
    /// accounts involved, the amount, and any applicable fees or memos.
    ///
    /// ## Returns
    ///
    /// `Star<TransferFromResponse, Text>`: Returns either Ok with a Nat representing the transaction id or
    /// an error text if the transfer could not be processed.
    ///
    /// ## Example
    ///
    /// ```
    /// let spenderPrincipal = Principal.fromText("spender-principal-here");
    /// let fromAccount = {owner = ownerPrincipal, subaccount = null};
    /// let toAccount = {owner = recipientPrincipal, subaccount = null};
    /// let transferArgs = {spender_subaccount = null, from = fromAccount, to = toAccount, amount = 1_000, ...};
    ///
    /// let result = await myICRC2Instance.transfer_from(spenderPrincipal, transferArgs);
    /// ```
    public func transfer_tokens_from<system>(caller: Principal, transferFromArgs: TransferFromArgs, canTransferFrom: CanTransferFrom) : async* Star.Star<TransferFromResponse, Text> {

      //check to and from account not equal
      if(account_eq(transferFromArgs.to, transferFromArgs.from)){
        return #err(#trappable("cannot transfer tokens to same account"));
      };

      //test that the memo is not too large
      let ?(memo) = environment.icrc1.testMemo(transferFromArgs.memo) else return #err(#trappable("invalid memo. must be less than " # debug_show(environment.icrc1.get_state().max_memo) # " bits"));

      
      //make sure the approval is not too old or too far in the future
      switch(environment.icrc1.testCreatedAt(transferFromArgs.created_at_time)){
        case(#ok(val)) {};
        case(#Err(#TooOld)) return #trappable(#Err(#TooOld));
        case(#Err(#InTheFuture(val))) return  #trappable(#Err(#CreatedInFuture({ledger_time = environment.icrc1.get_time64()})));
      };

      debug if(debug_channel.transfer) D.print("passed checks and calling token transfer");

      
      return await* transfer_token<system>(caller, transferFromArgs, canTransferFrom);
    };

    /// # `get_stats`
    ///
    /// Provides statistics that summarize the current ledger state, including the number of approvals,
    /// the limits that are set, and the overall ledger setup.
    ///
    /// ## Returns
    ///
    /// `Stats`: A snapshot structure representing ledger statistics like the number of approvals set up,
    /// the configurations of the ledger, as well as the indexing status for quick lookup.
    ///
    /// ## Example
    ///
    /// ```
    /// let statistics = myICRC2Instance.get_stats();
    /// ```
    public func get_stats() : Stats {
      return {
        ledger_info = {
          max_approvals_per_account  = state.ledger_info.max_approvals_per_account;
          fee = state.ledger_info.fee;
          max_approvals = state.ledger_info.max_approvals;
          settle_to_approvals = state.ledger_info.settle_to_approvals;
          max_allowance = state.ledger_info.max_allowance
        };
        token_approvals_count = Map.size(state.token_approvals);
        indexes = {
          spender_to_approval_account_count = Map.size(state.indexes.spender_to_approval_account);
          owner_to_approval_account_count = Map.size(state.indexes.owner_to_approval_account);
        };
      };
    };

    ///register some items with icrc1
    ignore init_metadata();

    ignore environment.icrc1.register_supported_standards({
        name = "ICRC-2";
        url = "https://github.com/dfinity/ICRC-1/blob/main/standards/ICRC-2/";
    });



  };
};
