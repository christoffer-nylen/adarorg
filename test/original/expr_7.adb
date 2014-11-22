with Ada.Text_IO; use Ada.Text_IO;

procedure Expr_7 is

   Index : Integer := 2;

   Hej : array (1..12) of Boolean := (others=>True);

   A : Boolean := True;

   function Bool_Fun(A : Integer := 2) return Boolean is
   begin
      return True;
   end Bool_Fun;

   function Fun(A : Integer := 2) return Integer is
   begin
      return A;
   end Fun;

begin

   if A=True and not A=False then
      null;
   end if;

   if Hej(1) and not Hej(1) then
      Put_Line("Hej");
   end if;
end Expr_7;
