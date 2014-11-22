with Rorg;
with Ada.Text_IO; use Ada.Text_IO;

procedure Expr_5 is
   a : Boolean := True;
   b : Boolean := True;
   c : Boolean := True;

   D : Boolean := True;

begin
   if (A or B) and not A then
      Put_Line("hello");
      declare
      begin
         null;
      end;
   --elsif (A and D) then
   --   Put_Line("Hej");
   end if;
end Expr_5;
