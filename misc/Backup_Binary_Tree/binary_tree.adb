with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body Binary_Tree is

   procedure Destroy_Tree(N : in out Node_Access) is
      procedure free is new Ada.Unchecked_Deallocation(Node, Node_Access);
   begin
      if N.Left /= null then
         Destroy_Tree(N.Left);
      end if;
      if N.Right /= null then
         Destroy_Tree(N.Right);
      end if;
      Free(N);
   end Destroy_Tree;

   function Tree(Value : Propositional_Logic_Kinds; Left : Node_Access; Right : Node_Access) return Node_Access is
      Temp : Node_Access := new Node;
   begin
      Temp.Data := Value;
      Temp.Left := Left;
      Temp.Right := Right;
      return Temp;
   end Tree;

   function Eval(N : Node_Access) return Boolean is
      Result : Boolean := False;
   begin
      case N.Data is
         when A_Negation =>
            Put("(~ ");
            Result := not Eval(N.Left);
         when A_Conjunction =>
            Put("(and ");
            Result := Eval(N.Left) and Eval(N.Right);
         when A_Disjunction =>
            Put("(or ");
            Result := Eval(N.Left) or Eval(N.Right);
         when A_Clause =>
            Put("(T");
            Result := True;
      end case;
      Put(")");
      return Result;
   end Eval;

end Binary_Tree;
