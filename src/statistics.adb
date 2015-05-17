-- ASIS
with
  Asis.Elements;

-- AdaRORG
with
  Adarorg_Constants;

package body Statistics is

   --type Predicate_Index is range 1..Adarorg_Constants.PREDICATE_SIZE;
   --Number_Of_Clauses : array (Predicate_Index) of Natural := (others => 0);

   function Get_Relops_Tested_Count return Integer is
   begin
      return Data.Relops_Tested;
   end Get_Relops_Tested_Count;

   function Get_Predicates_Tested_Count return Integer is
   begin
      return Data.Predicates_Tested;
   end Get_Predicates_Tested_Count;

   procedure Process_Tested_Relational_Operator (Expr : in Asis.Expression) is
   begin
      Data.Relops_Tested := Data.Relops_Tested+1;

   end Process_Tested_Relational_Operator;

   procedure Process_Relational_Operator (Expr : in Asis.Expression) is
   begin
      Data.Relops_Total := Statistics.Data.Relops_Total+1;
   end Process_Relational_Operator;

   procedure Process_Tested_Condition_Expression (Expr : in Asis.Expression) is
   begin
      Data.Predicates_Tested := Data.Predicates_Tested+1;
   end Process_Tested_Condition_Expression;

   procedure Process_Condition_Expression (Expr : in Asis.Expression) is
   begin
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

end Statistics;
