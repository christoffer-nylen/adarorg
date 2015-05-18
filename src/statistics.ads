with
  Asis;

-- AdaRORG
with Adarorg_Types;

package Statistics is

   function Get_Data return Adarorg_Types.Static_Data;

   function Get_Relops_Tested_Count return Integer;

   function Get_Predicates_Tested_Count return Integer;

   procedure Process_Relational_Operator (Expr : in Asis.Expression);

   procedure Process_Condition_Expression (Expr : in Asis.Expression);

   procedure Process_Tested_Relational_Operator (Expr : in Asis.Expression);

   procedure Process_Tested_Condition_Expression (Expr : in Asis.Expression);

   procedure Process_Application_Unit(Unit_Name : in Wide_String); --TODO: Change to process compilation_unit or something?

   procedure Post_Process_Application_Unit;

end Statistics;
