-- ASIS
with
  Asis.Elements,
  Asis.Expressions;

with
  Stack_Array;

--Adalog
with
  Utilities,
  Thick_Queries;

--RORG
with
  Predicate_Queries;

package body Predicate is

   package Element_Stack is new Stack_Array(Predicate.Predicate_Tree.Node_Access);
   Stack_Elements : Element_Stack.Stack(STACK_SIZE);

   procedure Push(Node : in Predicate_Tree.Node_Access) is
      use Utilities;
   begin
      Trace("Predicate.adb.Push : ", Node.Data.Element);
      Element_Stack.Push(Node, Stack_Elements);
   end Push;

   procedure Pop(Node : out Predicate_Tree.Node_Access) is
      use Utilities;
   begin
      Element_Stack.Pop(Stack_Elements, Node);
      Trace("Predicate.adb.Pop : ", Node.Data.Element);
   end Pop;

   function Peek return Predicate_Tree.Node_Access is
   begin
      return Element_Stack.Peek(Stack_Elements);
   end Peek;

   procedure Clear is
   begin
      Element_Stack.Make_Empty(Stack_Elements);
   end Clear;

   function Has_Relop_Id(Data : Clause_Information) return Boolean is
   begin
      return Data.Absolute_Id /= NO_ID;
   end Has_Relop_Id;

   procedure Assign_Relop_Id(Data : in out Clause_Information; Id : in Integer) is
   begin
      Data.Absolute_Id := Id;
   end Assign_Relop_Id;

   procedure Set_Relop_Kind(Data : in out Clause_Information; Relop_Kind : Ada_Type_Kind) is
   begin
      Data.Relop_Kind := Relop_Kind;
   end Set_Relop_Kind;

   function Is_Comparable(Data : Predicate.Clause_Information) return Boolean is
      use Predicate_Queries;
   begin
      return
        not (Data.Contains_Range_First or Data.Contains_Range_Last);
   end Is_Comparable;

   function Make_Clause(Elem : Asis.Element;
                        Relop_Kind : Ada_Type_Kind := No_Type;
                        Value : Boolean := False;
                        Absolute_Id : Integer := NO_ID;
                        Relative_Id : Integer := NO_ID;
                        Contains_Function_Call : Boolean := False;
                        Contains_Range_First : Boolean := False;
                        Contains_Range_Last : Boolean := False;
                        Number_Of_Equal_Clauses : Natural := 0) return Clause_Information is
   begin
      return (Elem, Relop_Kind, Value, Absolute_Id, Relative_Id, Contains_Function_Call, Contains_Range_First, Contains_Range_Last, Number_Of_Equal_Clauses);
   end Make_Clause;

   --Function used to avoid dangling pointer when freeing clauses
   --  returns true if clause is unique/can be destroyed
   procedure Decrement_Copies(Clause : in out Clause_Information) is
   begin
      Clause.Number_Of_Equal_Clauses := Clause.Number_Of_Equal_Clauses-1;
   end Decrement_Copies;
   function Is_Last_Copy(Clause : in Clause_Information) return Boolean is
   begin
      return Clause.Number_Of_Equal_Clauses=0;
   end Is_Last_Copy;

   function Is_Equal (N1 : Predicate.Predicate_Tree.Node_Access;
                      N2 : Predicate.Predicate_Tree.Node_Access) return Boolean is
      use Predicate_Queries;
      use Utilities;
      use Asis.Expressions;
      use Asis.Elements;
      use Asis;

      --TODO: FIX THIS!
      function Recursive_Is_Equal(Elem1 : Asis.Element; Elem2 : Asis.Element) return Boolean is

         Expr_Kind : constant Asis.Expression_Kinds := Expression_Kind (Elem1);
      begin
         if not (Expr_Kind=Expression_Kind (Elem2)) then
            --Trace("Not Same_Expr_Kind!");
            return False;
         end if;
         --Trace("Same_Expr_Kind!");

         --Trace("Elem1:",Elem1);
         --Trace("Elem2:",Elem1);

         case Expr_Kind is
            --when A_Function_Call =>
            when An_Integer_Literal =>
               return Thick_Queries.Same_Value(Elem1, Elem2);
            when An_Indexed_Component =>
               --Put_Line("hej");
               --TODO: FIX!!!!!!!!!!!!!!!!!
               return False;
               if not Is_Same_Corresponding_Declaration(Prefix(Elem1), Prefix(Elem2)) then
                  return False;
               else
                  --Put_Line("Same_Prefix");
                  declare
                     Indexes1 : constant Asis.Expression_List := Index_Expressions (Elem1);
                     Indexes2 : constant Asis.Expression_List := Index_Expressions (Elem2);
                  begin
                     if not (Indexes1'Length=Indexes2'Length) then
                        return False;
                     end if;
                     for I in Indexes1'Range loop
                        --TODO: Handle static content??
                        if not Recursive_Is_Equal(Indexes1(I), Indexes2(I)) then
                           return False;
                        end if;
                     end loop;
                     return True;
                  end;
               end if;
               --TODO:
               --when A_Selected_Component =>
               --if Selector(Elem1)=Selector(Elem2);

               --when An_Attribute_Reference
            when others =>
               return Is_Same_Corresponding_Declaration(Elem1, Elem2);
         end case;
      end Recursive_Is_Equal;
   begin
      return Recursive_Is_Equal(N1.Data.Element, N2.Data.Element);
   end Is_Equal;

   function Eval(N : Predicate_Tree.Node_Access) return Boolean is
      use Asis, Asis.Elements;
      use Utilities;
      Result : Boolean := False;
   begin
      --Trace("Elem:",N.Data.Element);
      --TODO: Big Case
      case Expression_Kind (N.Data.Element) is
         when An_Identifier | An_Indexed_Component => -- (A Clause)
            Result := N.Data.Value;
            --Put_Line("->" & Boolean'Wide_Image(N.Data.Value));
         when An_Operator_Symbol =>
            case Operator_Kind(N.Data.Element) is
               when An_And_Operator =>
                  Result := Eval(N.Left) and Eval(N.Right);
               when An_Or_Operator =>
                  Result := Eval(N.Left) or Eval(N.Right);
               when An_Xor_Operator =>
                  Result := Eval(N.Left) xor Eval(N.Right);
               when An_Equal_Operator =>
                  Result := N.Data.Value;
               when A_Not_Equal_Operator =>
                  Result := N.Data.Value;
               when A_Less_Than_Operator =>
                  Result := N.Data.Value;
               when A_Less_Than_Or_Equal_Operator =>
                  Result := N.Data.Value;
               when A_Greater_Than_Operator =>
                  Result := N.Data.Value;
               when A_Greater_Than_Or_Equal_Operator =>
                  Result := N.Data.Value;
               when
                 A_Plus_Operator |
                 A_Minus_Operator |
                 A_Concatenate_Operator |
                 A_Multiply_Operator |
                 A_Divide_Operator |
                 A_Mod_Operator |
                 A_Rem_Operator |
                 An_Exponentiate_Operator =>
                  --TODO: FAIL
                  --borde vara precis som för when A_Function_Call?:
                  --Result := N.Data.Value;
                  null;
               when A_Not_Operator =>
                  Result := not Eval(N.Right);
               when
                 A_Unary_Plus_Operator |
                 A_Unary_Minus_Operator |
                 An_Abs_Operator =>
                  --TODO: FAIL
                  --borde vara precis som för when A_Function_Call?:
                  null;
               when Not_An_Operator =>
                  Trace("predicate.adb : Not_An_Operator: ", N.Data.Element);
            end case;
         when A_Parenthesized_Expression =>
            Result := Eval(N.Right);
         when A_Function_Call =>
            --TODO: Fail?
            Result := N.Data.Value;
         when others =>
            Result := N.Data.Value;
            Trace("predicate.adb : complicated_clause: ", N.Data.Element);
      end case;
      return Result;
   end Eval;

   procedure Update_Left_Clause(New_Clause : Predicate_Tree.Node_Access; Parent : Predicate_Tree.Node_Access) is
      use Predicate_Tree;
   begin
      Destroy_Tree(Parent.Left);
      New_Clause.Data.Number_Of_Equal_Clauses := New_Clause.Data.Number_Of_Equal_Clauses+1;
      Parent.Left := New_Clause; --Use get node instead
   end Update_Left_Clause;

   procedure Update_Right_Clause(New_Clause : Predicate_Tree.Node_Access; Parent : Predicate_Tree.Node_Access) is
      use Predicate_Tree;
   begin
      Destroy_Tree(Parent.Right);
      New_Clause.Data.Number_Of_Equal_Clauses := New_Clause.Data.Number_Of_Equal_Clauses+1;
      Parent.Right := New_Clause;
   end Update_Right_Clause;

   procedure Print_Tree_Element (C : Clause_Information) is
   begin
      Utilities.Trace("Element:", C.Element);
   end Print_Tree_Element;

end Predicate;
