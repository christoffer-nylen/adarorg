-- ASIS
with
  Asis.Elements;

-- AdaRORG
with
  Adarorg_Constants,
  Predicate;

package body Statistics is

   type Predicate_Index is range 1..Adarorg_Constants.PREDICATE_SIZE;

   Number_Of_Clauses : array (Predicate_Index) of Natural := (others => 0);

   procedure Process_Condition_Expression (Expr : in Asis.Expression) is
      use Asis, Asis.Elements;
   begin
      Predicate_Expression := Expr;
      Data.Predicates_Total := Data.Predicates_Total+1;
   end Process_Condition_Expression;

   procedure Post_Process_Application_Unit is
      use Predicate;
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

   procedure Add_Predicate(Expr : in Asis.Expression; Determining_Clauses : in Natural) is
   begin
      null;
   end Add_Predicate;
end Statistics;
