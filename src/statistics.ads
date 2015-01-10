with
  Asis;

-- AdaRORG
with Adarorg_Types;

package Statistics is

   Data : Adarorg_Types.Static_Data := (Relops_Total => 0,
                                        Relops_Tested => 0,
                                        Predicates_Total => 0,
                                        Predicates_Tested => 0);

   procedure Process_Condition_Expression (Expr : in Asis.Expression);

   procedure Process_Application_Unit(Unit_Name : in Wide_String); --TODO: Change to process compilation_unit or something?

   procedure Post_Process_Application_Unit;

   procedure Post_Process_Expression(Expr : in Asis.Expression);

end Statistics;
