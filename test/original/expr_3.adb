procedure Expr_3 is
   type week is(monday, tuesday, wednesday);
   A : week := monday;
   B : Boolean := True;
   C : Week := Tuesday;

begin
   if A<=monday and (B or C=Tuesday) then
      null;
   end if;
end Expr_3;
