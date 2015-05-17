procedure A_Function_Call is
   function Func(A : Boolean) return Boolean is
   begin
      return A;
   end Func;

   I, J : Integer;
begin
   if Func(True) and I<J then
      null;
   end if;
end A_Function_Call;
