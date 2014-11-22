with Binary_Tree; use Binary_Tree;
with Ada.Text_Io; use Ada.Text_Io;

procedure Test_Tree is
   N : Node_Access;
begin
   N := Tree(A_Conjunction,
             Tree(A_Disjunction,
                  Tree(A_Clause, null, null),
                  Tree(A_Clause, null, null)),
             Tree(A_Clause, null, null));

   if Eval(N) then
      Put("->T");
   else
      Put("->F");
   end if;

   Destroy_Tree(N);
end;
