package body Bit_Operations is
   function Bit_At(Pos : Positive; I : Bit_Set) return Boolean is
   begin
      return (Shift_Right(I, Pos-1) and 1)=1;
   end;

   procedure Switch_Bit(Pos : Positive; I : in out Bit_Set) is
   begin
      I := (Shift_Left(1, Pos-1) xor I);
   end Switch_Bit;

   procedure Set_Bit(Pos : Positive; I : in out Bit_Set) is
   begin
      I := (Shift_Left(1, Pos-1) or I);
   end Set_Bit;

end Bit_Operations;
