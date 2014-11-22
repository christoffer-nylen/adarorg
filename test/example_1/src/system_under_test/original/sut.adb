package body Sut is
   function XYBC(X : Integer;
                 Y : Integer;
                 B : Boolean;
                 C : Boolean) return Boolean is
   begin
      if (X>Y or B) and C then
         return True;
      end if;
      return False;
   end XYBC;
end Sut;
