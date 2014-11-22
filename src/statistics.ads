with
  Asis;

-- AdaRORG
with Adarorg_Types;

package Statistics is

   Data : Adarorg_Types.Static_Data := (Relops_Total => 0,
                                        Relops_Tested => 0,
                                        Predicates_Total => 0,
                                        Predicates_Tested => 0);
   Predicate_Expression : Asis.Expression;

   procedure Process_Condition_Expression (Expr : in Asis.Expression);

   procedure Post_Process_Application_Unit;

   procedure Post_Process_Expression(Expr : in Asis.Expression);

   procedure Add_Predicate(Expr : in Asis.Expression; Determining_Clauses : in Natural);
end Statistics;
