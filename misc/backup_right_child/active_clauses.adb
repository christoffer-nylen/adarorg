-- ASIS
with
  Asis,
  Asis.Elements,
  Asis.Expressions;

--Adalog
with
  Utilities,
  Thick_Queries;

-- Rorg
with
  Predicate_Queries,
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;
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

                     if not (N.Right=null) and then Is_Regular_Clause(N.Right.Data.Element)
                       and then Exists(N.Right, Array_Of_Clauses) then
                        Predicate.Update_Right_Clause(Get_Node(N.Right, Array_Of_Clauses), N);
                     else
                        Iter(N.Right);
                     end if;

                     if not (N.Left=null) and then Is_Regular_Clause(N.Left.Data.Element)
                       and then Exists(N.Left, Array_Of_Clauses) then
                        Predicate.Update_Left_Clause(Get_Node(N.Left, Array_Of_Clauses), N);
                     else
                        Iter(N.Left);
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
         end case;
      end Iter;
   begin
      Iter(N);
   end Find_Clauses;
end Active_Clauses;
