----------------------------------------------------------------------
--  AdaRORG_Constants - Package specification                       --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

with
  Adarorg_Constants.Asis_Types;
use
  Adarorg_Constants.Asis_Types;

with
  Asis,
  Asis.Elements,
  Asis.Expressions;

package Adarorg_Types.Asis_Types is

   function To_Ada_Kind_Type(Kind : Asis.Type_Kinds) return Ada_Type_Kind is
      use Asis, Asis.Elements, Asis.Expressions;
   begin
      case Kind is
         Not_A_Type_Definition                 => return No_Type;
         A_Derived_Type_Definition             => return Derived_Type;
         A_Derived_Record_Extension_Definition => return Derived_Record_Extension;
         An_Enumeration_Type_Definition        => return Enumeration_Type;
         A_Signed_Integer_Type_Definition      => return Signed_Integer_Type;
         A_Modular_Type_Definition             => return Modular_Type;
         A_Root_Type_Definition                => return Root_Type;
         A_Floating_Point_Definition           => return Floating_Point;
         An_Ordinary_Fixed_Point_Definition    => return Ordinary_Fixed_Point;
         A_Decimal_Fixed_Point_Definition      => return Decimal_Fixed_Point;
         An_Unconstrained_Array_Definition     => return Unconstrained_Array;
         A_Constrained_Array_Definition        => return Constrained_Array;
         A_Record_Type_Definition              => return Record_Type;
         A_Tagged_Record_Type_Definition       => return Tagged_Record_Type;
         An_Interface_Type_Definition          => return Interface_Type;
         An_Access_Type_Definition             => return Access_Type;
      end case;
   end To_Ada_Kind_Type;

   function To_Ada_Relational_Operator(Relop : A_Relational_Operator) return Ada_Relational_Operator is
      use Asis, Asis.Elements, Asis.Expressions;
   begin
      case Relop is
         when An_Equal_Operator                => return Adarorg_Type.Equal_Operator;
         when A_Not_Equal_Operator             => return Adarorg_Type.Not_Equal_Operator;
         when A_Less_Than_Operator             => return Adarorg_Type.Less_Than_Operator;
         when A_Less_Than_Or_Equal_Operator    => return Adarorg_Type.Less_Than_Or_Equal_Operator;
         when A_Greater_Than_Operator          => return Adarorg_Type.Greater_Than_Operator;
         when A_Greater_Than_Or_Equal_Operator => return Adarorg_Type.Greater_Than_Or_Equal_Operator;
      end case;
   end To_Ada_Relational_Operator;

end Adarorg_Types.Asis_Types;
