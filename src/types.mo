import Blob "mo:base/Blob";
import Principal "mo:base/Principal";

module {
  public type Account = {
    owner : Principal;
    subaccount : ?Blob;
  };

  public type HolderCategory = {
    categoryName : Text; // Nombre opcional para identificación (por ejemplo: "Comunidad", "Equipo")
    holders : [Account]; // Lista de cuentas que recibirán esta asignación
    allocatedAmount : Nat; // Monto que recibirá cada holder (puede dividirse manualmente si quieres que sea distinto)
    blockingDays : Nat; // Días que deben pasar antes de que los tokens se desbloqueen
  };

  public type FeeAllocationPercentages = {
    name : Text; // Por ejemplo: "pool de desarrollo", "DAO", etc.
    to : Account; // Cuenta receptora del porcentaje
    percentage : Nat; // Porcentaje multiplicado por 100 (ej. 225 para 2.25%)
  };
};
