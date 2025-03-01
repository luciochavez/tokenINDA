import ICRC2 "mo:icrc2-mo";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor Token {
    let token = ICRC2.Token({
        name = "INDA Token";
        symbol = "INDA";
        decimals = 8;
        initialSupply = 1_000_000_000;
        owner = Principal.fromText("aaaaa-aa");
    });

    public query func balanceOf(account : Text) : async Nat {
        token.balanceOf(account)
    };

    public func transfer(from: Text, to: Text, amount: Nat) : async Bool {
        token.transfer(from, to, amount)
    };
}
