with
  Ada.Unchecked_Conversion,
  Interfaces;
use
  Interfaces;

package Bit_Operations is
   --TODO: change to subtype
   type Bit_Set is new Unsigned_32;
   function Bit_At(Pos : Positive; I : Bit_Set) return Boolean;
   procedure Switch_Bit(Pos : Positive; I : in out Bit_Set);
   procedure Set_Bit(Pos : Positive; I : in out Bit_Set);
   --procedure Clear_Bit
   function To_Integer is new Ada.Unchecked_Conversion (Source => Bit_Set,
                                                        Target => Integer);
   function To_Bit_Set is new Ada.Unchecked_Conversion (Source => Integer,
                                                        Target => Bit_Set);
end Bit_Operations;
