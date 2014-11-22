generic
   type Element_Type is private;
package Generic_Array is
   --type Element_Access is access Element_Type;
   type Generic_Array( Array_Size: Positive ) is limited private;

   procedure Push(X : in Element_Type; A : in out Generic_Array);
   procedure Insert(X : in Element_Type; I : in Positive; A : in out Generic_Array);
   function Get(I : in Positive; A : in Generic_Array) return Element_Type;
   function Is_Full( A : in Generic_Array) return Boolean;
   procedure Make_Empty(A : in out Generic_Array);

   Overflow : exception;

private
   type Array_Of_Element_Type is array( Positive range <> ) of Element_Type;

   type Generic_Array( Array_Size: Positive ) is
      record
         Current_Index : Natural := 0;
         Element_Array : Array_Of_Element_Type( 1..Array_Size );
      end record;
end Generic_Array;
