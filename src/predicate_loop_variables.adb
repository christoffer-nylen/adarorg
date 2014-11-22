with
  Statistics;
package body Predicate_Loop_Variables is

   type Index_Span is
      record
         Predicate_Id : Integer;
         Start_Index : Positive;
         Offset : Natural;
      end record;

   package Expression_Loop_Variables is new Stack_Array(Index_Span);
   Loop_Variables : Expression_Loop_Variables.Stack(STACK_SIZE);

   Current_Span : Index_Span := (Predicate_Id => 0, Start_Index => 1, Offset => 0);

   procedure Is_Used(Identifier : Asis.Expression) is
      Tmp : Asis.Expression;
      --Length : Natural := Rorg_Mark_Arguments.Length(Call_Arguments);
      Last_Index : constant Natural := Current_Span.Start_Index-1+Current_Span.Offset;
   begin
      --for I in 1..Length loop
      for I in Current_Span.Start_Index..Last_Index loop
         Rorg_Mark_Arguments.Get(Tmp, I, Call_Arguments);
         if Is_The_Same(Identifier, Tmp) then
            return;
         end if;
      end loop;
      Current_Span.Offset := Current_Span.Offset+1;
      Rorg_Mark_Arguments.Push(Identifier, Call_Arguments);
   end;

   function Has_Used_Variable return Boolean is
   begin
      return Current_Span.Offset>0;
      --return Rorg_Mark_Arguments.Length(Call_Arguments)>0;
   end Has_Used_Variable;

   procedure Set_Predicate(Predicate_Id : Integer) is
      use Expression_Loop_Variables;

      function Is_Equal (Arg1 : in Index_Span;
                         Arg2 : in Index_Span) return Boolean is
      begin
         return Arg1.Predicate_Id=Arg2.Predicate_Id;
      end Is_Equal;
      function Get_Predicate_Loop_Variables is new Expression_Loop_Variables.Get_Corresponding_Element(Is_Equal);
   begin
      Current_Span := Get_Predicate_Loop_Variables((Predicate_Id, 1, 0), Loop_Variables);
   exception
      when Element_Not_Found =>
         Current_Span := (0, 1, 0);
   end Set_Predicate;

   procedure Store_Used_Variables is
   begin
      if(Current_Span.Offset>0) then
         Current_Span.Predicate_Id := Statistics.Data.Predicates_Tested;
         Expression_Loop_Variables.Push(Current_Span, Loop_Variables);
      end if;
      Current_Span.Start_Index := Current_Span.Start_Index+Current_Span.Offset;
      Current_Span.Offset := 0;
   end Store_Used_Variables;

   procedure Clear_Used_Variables is
   begin
      for I in 1..Current_Span.Offset loop
         Rorg_Mark_Arguments.Pop(Call_Arguments);
      end loop;
      Current_Span.Offset := 0;
   end Clear_Used_Variables;

   procedure Reset_Used_Variables is
   begin
      Current_Span.Start_Index := 1;
      Current_Span.Offset := 0;
      Rorg_Mark_Arguments.Make_Empty(Call_Arguments);
   end Reset_Used_Variables;

   procedure Put_As_Parameters is
      Tmp : Asis.Expression;
      --Length : Natural := Rorg_Mark_Arguments.Length(Call_Arguments);
      Last_Index : constant Natural := Current_Span.Start_Index-1+Current_Span.Offset;
   begin
      for I in Current_Span.Start_Index..Last_Index loop
         Rorg_Mark_Arguments.Get(Tmp, I, Call_Arguments);
         Put_Parameter(Tmp);
         if I/=Last_Index then
            Put_Delimiter;
         end if;
      end loop;
   end Put_As_Parameters;
end Predicate_Loop_Variables;
