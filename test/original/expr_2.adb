package body Expr_2 is
   procedure Init is
      type week is(mon, tue, wed);
      A : week := tue;
      B : Week := Mon;
      C : Integer := 1;
      D : Integer := 2;
      E : Integer := 2;

      function Wee(Hej : Boolean) return Boolean is
      begin
         return Hej;
      end Wee;
   begin
      if not Wee(True) and A = Week'First then
         null;
      end if;

   end Init;
end Expr_2;
