with
  Asis;

with
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;

with
  Stack_Array;

package Predicate_Loop_Variables is

   package Rorg_Mark_Arguments is new Stack_Array(Asis.Expression);
   Call_Arguments : Rorg_Mark_Arguments.Stack(STACK_SIZE);

   generic
      with function Is_The_Same(Var1 : Asis.Expression; Var2 : Asis.Expression) return Boolean;
   procedure Is_Used(Identifier : Asis.Expression);

   function Has_Used_Variable return Boolean;
   procedure Set_Predicate(Predicate_Id : Integer);
   procedure Store_Used_Variables;
   procedure Clear_Used_Variables;
   procedure Reset_Used_Variables;

   generic
      with procedure Put_Delimiter;
      with procedure Put_Parameter(Identifier : Asis.Expression);
   procedure Put_As_Parameters;
end Predicate_Loop_Variables;
