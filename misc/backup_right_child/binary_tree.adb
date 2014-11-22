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
      if Is_Unique(N.Data) then
         Free(N);
      else
         Subtract_Copy(N.Data);
      end if;
   end Destroy_Tree;

   function Tree(Value : Element_Type; Left : Node_Access; Right : Node_Access) return Node_Access is
      Temp : Node_Access := new Node;
   begin
      Temp.Data := Value;
      Temp.Left := Left;
      Temp.Right := Right;
      return Temp;
   end Tree;

   procedure Connect(Parent : in out Node_Access;
                     Left : in Node_Access;
                     Right : in Node_Access) is
   begin
      Parent.Left := Left;
      Parent.Right := Right;
   end Connect;

   procedure Iterate(N : in Node_Access) is
      procedure Iter_Iterate(N : in Node_Access; I : in Integer) is
      begin
         --for R in Integer range 1 .. I loop
         --   Put("-");
         --end loop;
         Action(N.Data);
         --Put_Line("");

         if N.Left /= null then
            Iter_Iterate(N.Left, I+1);
         end if;
         if N.Right /= null then
            Iter_Iterate(N.Right, I+1);
         end if;
      end Iter_Iterate;
   begin
      Iter_Iterate(N, 0);
   end;

end Binary_Tree;
