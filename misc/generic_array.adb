package body Generic_Array is

   procedure Push (X : in Element_Type; A : in out Generic_Array) is
   begin
      if Is_Full(A) then
         raise Overflow;
      end if;

      A.Current_Index:=A.Current_Index+1;
      A.Element_Array(A.Current_Index):=X; --TODO: Wrong??
   end Push;

   procedure Insert
     (X : in Element_Type;
      I : in Positive;
      A : in out Generic_Array)
   is
   begin
      A.Element_Array(I):=X; --TODO: Wrong??
   end Insert;

   function Get
     (I : in Positive;
      A : in Generic_Array)
      return Element_Type
   is
   begin
      return A.Element_Array(I);
   end Get;

   function Is_Full( A : in Generic_Array) return Boolean is
   begin
      return A.Current_Index = A.Element_Array'Last;
   end Is_Full;

   procedure Make_Empty (A : in out Generic_Array) is
   begin


      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Make_Empty unimplemented");
      raise Program_Error;
   end Make_Empty;

end Generic_Array;
