-- ASIS
with
  Asis.Elements;

-- AdaRORG
with
  Adarorg_Constants;

package body Statistics is

   type Predicate_Index is range 1..Adarorg_Constants.PREDICATE_SIZE;
   Number_Of_Clauses : array (Predicate_Index) of Natural := (others => 0);
   Predicate_Expression : Asis.Expression;

   procedure Process_Condition_Expression (Expr : in Asis.Expression) is
      use Asis, Asis.Elements;
   begin
      Predicate_Expression := Expr;
      Data.Predicates_Total := Data.Predicates_Total+1;
   end Process_Condition_Expression;

   procedure Process_Application_Unit(Unit_Name : in Wide_String) is --TODO: Change to process compilation_unit or something?
   begin
      null;
   end Process_Application_Unit;

   procedure Post_Process_Application_Unit is
   begin
      null;
   end Post_Process_Application_Unit;

   procedure Post_Process_Expression (Expr : in Asis.Expression) is
      use Asis, Asis.Elements;
   begin
      if Is_Equal(Expr, Predicate_Expression) then
         null;
      end if;
   end Post_Process_Expression;

end Statistics;
