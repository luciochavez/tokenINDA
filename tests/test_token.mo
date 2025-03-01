import Debug "mo:base/Debug";
import Token "mo:contracts/Token";

actor {
  public func testBalance() : async () {
    let balance = await Token.balanceOf("aaaaa-aa");
    Debug.print("Saldo: " # debug_show(balance));
  };
};
