with Ada.Text_IO; use Ada.Text_IO;

procedure Expr_9 is
   a : Boolean := True;
   b : Boolean := True;
   c : Boolean := True;

   d : Boolean := True;
   e : Boolean := True;
   f : Boolean := True;

begin
   if (A and B) or (C and E) or (B and F) then
      Put_Line("hej");
   end if;
end Expr_9;
