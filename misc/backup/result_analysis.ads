--Kolla adactrl/src/binary_map.ads
generic
   type Operand_Type is private;
   with function "<" (Left, Right : Operand_Type) return Boolean is <>;
   with function ">" (Left, Right : Operand_Type) return Boolean is <>;
   with function "=" (Left, Right : Operand_Type) return Boolean is <>; --Beh�vs enbart f�r enums??
package result_analysis is

end result_analysis;
