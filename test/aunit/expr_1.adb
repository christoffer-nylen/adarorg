procedure Expr_1 is
   A : Boolean := True;
   B : Boolean := False;
   I : Integer := 1;
   J : Integer := 2;
begin
   if (A or (B and (I < 2))) then
      null;
   end if;
end Expr_1;
