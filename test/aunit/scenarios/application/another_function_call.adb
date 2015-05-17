procedure Another_Function_Call is
   function Func(A : Boolean) return Boolean is
   begin
      return A;
   end Func;

   function Wee(C : Integer) return Integer is
   begin
      return C;
   end Wee;

   I, J : Integer;
begin
   if Func(True) and Wee(I)<J then
      null;
   end if;
end Another_Function_Call;
