procedure Expr_8 is
   Arr : array (1..4) of Integer := (others => 0);
begin
   for R in Arr'Range loop
      for I in Arr'Range loop
         if Arr(I)=0 and Arr(R)<5 then
            null;
         elsif (Arr(R)=1) then
            null;
         end if;
      end loop;
   end loop;
end Expr_8;
