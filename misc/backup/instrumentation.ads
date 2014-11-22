--ASIS
with
  Asis;
--RORG
with
  Bit_Operations,
  Binary_Tree,
  Determining_Test_Set,
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;
package Instrumentation is
   type Coverage_Information is
      record
         Clause : Asis.Element;
      end record;

   procedure InputFileName(Input : Wide_String);
   procedure CloseFile;

   procedure PushInsertionPoint(Line : Text_Line_Number; Column : Text_Column_Number);
   procedure PushPredicateExpression(Expr : Asis.Expression);

   package Coverage_Tree is new Binary_Tree (Coverage_Information);

   procedure Clear;

   procedure Generate_With_Clause;

   procedure Generate_RORG_Mark_Function_Declaration(Predicate_Pairs : Determining_Test_Set.Test_Pairs.Stack);

   procedure Generate_RORG_Mark_Calls;

   procedure Add_Test_Coverage(Pair : Determining_Test_Set.Test_Pair);
end Instrumentation;
