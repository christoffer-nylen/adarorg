with
  Ada.Wide_Text_Io;

-- ASIS
with
  Asis,
  Asis.Declarations,
  Asis.Elements,
  Asis.Expressions;

-- Adalog
with
  Utilities,
  Thick_Queries;

-- Rorg
with
  Predicate_Queries,
  Adarorg_Constants,
  Adarorg_Constants.Asis_Types;
use
  Adarorg_Constants,
  Adarorg_Constants.Asis_Types;
package body Active_Clauses is
   Array_Of_Clauses : Element_Stack.Stack(STACK_SIZE);

   function Get_Node is new Element_Stack.Get_Corresponding_Element(Predicate.Is_Equal);
   function Get_Node(Node : Predicate.Predicate_Tree.Node_Access) return Predicate.Predicate_Tree.Node_Access is
   begin
      return Get_Node(Node, Array_Of_Clauses);
   end Get_Node;

   function Number_Of_Clauses return Natural is
   begin
      return Element_Stack.Length(Array_Of_Clauses);
   end Number_Of_Clauses;

   procedure Clear is
   begin
      Element_Stack.Make_Empty(Array_Of_Clauses);
   end Clear;

   procedure Get(X : out Predicate.Predicate_Tree.Node_Access; I : in Positive) is
   begin
      Element_Stack.Get(X, I, Array_Of_Clauses);
   end Get;
   procedure Find_Clauses(N : Predicate.Predicate_Tree.Node_Access) is

      Current_Relative_Id : Integer := 1;

      procedure Iter(N : Predicate.Predicate_Tree.Node_Access) is
         use Asis, Asis.Elements, Asis.Expressions;
         use Utilities;
         use Predicate.Predicate_Tree;
         use Predicate_Queries;

         procedure Push(N : Predicate.Predicate_Tree.Node_Access) is
         begin
            N.Data.Relative_Id := Current_Relative_Id;
            Element_Stack.Push(N, Array_Of_Clauses);
            Current_Relative_Id := Current_Relative_Id+1;
         end Push;

         procedure Check_Comparability(Elem : Asis.Element; Data : in out Predicate.Clause_Information) is
            use Asis.Declarations;
            use Thick_Queries;
         begin
            case Expression_Kind(Elem) is
               when An_Integer_Literal .. A_String_Literal =>
                  null;
               when A_Null_Literal =>
                  --TODO: null is neither upper or lower, also check if "operand has an access type" instead
                  Data.Contains_Range_Last := True; -- TODO: Fix..
                  N.Data.Contains_Range_First := True;
                  N.Data.Contains_Range_Last := True;
               when A_Character_Literal =>
                  null;
               when An_Enumeration_Literal =>
                  declare
                     Representation_Value : constant Integer := Integer'Wide_Value(Representation_Value_Image(Corresponding_Name_Definition(Elem)));
                     Type_Decl : constant Asis.Declaration := Corresponding_Expression_Type(Elem);
                     Bounds : constant Asis.Element_List := Discrete_Constraining_Bounds (Type_Decl);
                     Is_Minimum_Value : Boolean := True;
                     Is_Maximum_Value : Boolean := True;
                  begin
                     --Put_Line("Value/Pos: " & Integer'Wide_Image(Representation_Value));
                     for I in Bounds'Range loop
                        if Integer'Wide_Value(Representation_Value_Image(Bounds(I))) < Representation_Value then
                           Is_Minimum_Value := False;
                        end if;
                        if Integer'Wide_Value(Representation_Value_Image(Bounds(I))) > Representation_Value then
                           Is_Maximum_Value := False;
                        end if;
                     end loop;
                     if Is_Minimum_Value then
                        Data.Contains_Range_First := Is_Minimum_Value;
                        N.Data.Contains_Range_First := Is_Minimum_Value;
                     end if;
                     if Is_Maximum_Value then
                        Data.Contains_Range_Last := Is_Maximum_Value;
                        N.Data.Contains_Range_Last := Is_Maximum_Value;
                     end if;
                     --if Is_Minimum_Value then
                     --   Put_Line(Element_Image(Elem)&"IS_MIN");
                     --end if;
                     --if Is_Maximum_Value then
                     --   Put_Line(Element_Image(Elem)&"IS_MAX");
                     --end if;
                     --return not Is_Minimum_Value and not Is_Maximum_Value;
                  end;
               when An_Identifier =>
                  null;
               when An_Indexed_Component=>
                  null;
               when A_Selected_Component =>
                  Check_Comparability(Selector(Elem), Data);
               when An_Attribute_Reference =>
                  null;
               when A_Function_Call =>
                  null;
               when others =>
                  Trace("predicate_analysis.adb : Strange Operand:", Elem);
            end case;
         end Check_Comparability;

      begin
         if N=null then
            return;
         end if;
         --Trace("Find_Clauses:Node:", N.Data.Element);

         case Expression_Kind (N.Data.Element) is
            when An_Identifier | An_Indexed_Component =>
               Push(N);
            when An_Operator_Symbol =>
               case Operator_Kind(N.Data.Element) is
                  when A_Relational_Operator =>
                     Ada.Wide_Text_Io.New_Line;
                     Ada.Wide_Text_Io.New_Line;
                     Ada.Wide_Text_Io.New_Line;
                     Ada.Wide_Text_Io.Put_Line("Relop operand kinds:");
                     Ada.Wide_Text_Io.Put_Line("--------------------");
                     Ada.Wide_Text_Io.Put_Line(Asis.Type_Kinds'Wide_Image(Thick_Queries.Expression_Type_Kind(N.Left.Data.Element)));
                     Ada.Wide_Text_Io.Put_Line(Asis.Type_Kinds'Wide_Image(Thick_Queries.Expression_Type_Kind(N.Right.Data.Element)));
                     Ada.Wide_Text_Io.Put_Line("--------------------");
                     Ada.Wide_Text_Io.New_Line;
                     Ada.Wide_Text_Io.New_Line;
                     Ada.Wide_Text_Io.New_Line;
                     --Predicate.Set_Relop_Kind(N.Left.Data,Thick_Queries.Expression_Type_Kind(N.Left.Data.Element));
                     --Predicate.Set_Relop_Kind(N.Right.Data,Thick_Queries.Expression_Type_Kind(N.Right.Data.Element));
                     Check_Comparability(N.Left.Data.Element, N.Left.Data);
                     Check_Comparability(N.Right.Data.Element, N.Right.Data);
                     Push(N);
                     --Destroy_Tree(N.Left);
                     --Destroy_Tree(N.Right);
                  when
                    An_And_Operator | An_Or_Operator | An_Xor_Operator |
                    A_Not_Operator |
                    A_Unary_Plus_Operator |
                    A_Unary_Minus_Operator |
                    An_Abs_Operator |
                    A_Plus_Operator |
                    A_Minus_Operator |
                    A_Concatenate_Operator |
                    A_Multiply_Operator |
                    A_Divide_Operator |
                    A_Mod_Operator |
                    A_Rem_Operator |
                    An_Exponentiate_Operator =>
                     --TODO: FAIL
                     --Behövs ej för aritmetiska funktioner?
                     --null

                     if not (N.Left=null) and then Is_Regular_Clause(N.Left.Data.Element)
                       and then Exists(N.Left, Array_Of_Clauses) then
                        Predicate.Update_Left_Clause(Get_Node(N.Left, Array_Of_Clauses), N);
                     else
                        Iter(N.Left);
                     end if;

                     if not (N.Right=null) and then Is_Regular_Clause(N.Right.Data.Element)
                       and then Exists(N.Right, Array_Of_Clauses) then
                        Predicate.Update_Right_Clause(Get_Node(N.Right, Array_Of_Clauses), N);
                     else
                        Iter(N.Right);
                     end if;

                  when Not_An_Operator =>
                     Trace("active_clauses.adb : Unknown operator: ", N.Data.Element);
               end case;
            when A_Parenthesized_Expression =>
               if Is_Regular_Clause(N.Right.Data.Element)
                 and then Exists(N.Right, Array_Of_Clauses) then
                  Predicate.Update_Right_Clause(Get_Node(N.Right, Array_Of_Clauses), N);
               else
                  Iter(N.Right);
               end if;
            when A_Function_Call =>
               --TODO: Fail??
               N.Data.Contains_Function_Call := True;
               Push(N);
            when others =>
               Trace("active_clauses.adb : Unknown Element:", N.Data.Element);
               --TODO: This is not a function call, but perhaps it will work
               --      Short circuits will be treated this way:
               --      N.Data.Contains_Function_Call := True;
               --TODO: This is a clause so set return type boolean?
               Push(N);
         end case;
      end Iter;
   begin
      Iter(N);
   end Find_Clauses;
end Active_Clauses;
