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

package body Adarorg_Types.Asis_Types is

   function To_Ada_Kind_Type(Kind : Asis.Type_Kinds) return Ada_Type_Kind is
      use Asis, Asis.Elements, Asis.Expressions;
   begin
      case Kind is
         when Not_A_Type_Definition                 => return Adarorg_Types.No_Type;
         when A_Derived_Type_Definition             => return Adarorg_Types.Derived_Type;
         when A_Derived_Record_Extension_Definition => return Adarorg_Types.Derived_Record_Extension;
         when An_Enumeration_Type_Definition        => return Adarorg_Types.Enumeration_Type;
         when A_Signed_Integer_Type_Definition      => return Adarorg_Types.Signed_Integer_Type;
         when A_Modular_Type_Definition             => return Adarorg_Types.Modular_Type;
         when A_Root_Type_Definition                => return Adarorg_Types.Root_Type;
         when A_Floating_Point_Definition           => return Adarorg_Types.Floating_Point;
         when An_Ordinary_Fixed_Point_Definition    => return Adarorg_Types.Ordinary_Fixed_Point;
         when A_Decimal_Fixed_Point_Definition      => return Adarorg_Types.Decimal_Fixed_Point;
         when An_Unconstrained_Array_Definition     => return Adarorg_Types.Unconstrained_Array;
         when A_Constrained_Array_Definition        => return Adarorg_Types.Constrained_Array;
         when A_Record_Type_Definition              => return Adarorg_Types.Record_Type;
         when A_Tagged_Record_Type_Definition       => return Adarorg_Types.Tagged_Record_Type;
         when An_Interface_Type_Definition          => return Adarorg_Types.Interface_Type;
         when An_Access_Type_Definition             => return Adarorg_Types.Access_Type;
      end case;
   end To_Ada_Kind_Type;

   function To_Ada_Relational_Operator(Relop : A_Relational_Operator) return Ada_Relational_Operator is
      use Asis, Asis.Elements, Asis.Expressions;
   begin
      case Relop is
         when An_Equal_Operator                => return Adarorg_Types.Equal_Operator;
         when A_Not_Equal_Operator             => return Adarorg_Types.Not_Equal_Operator;
         when A_Less_Than_Operator             => return Adarorg_Types.Less_Than_Operator;
         when A_Less_Than_Or_Equal_Operator    => return Adarorg_Types.Less_Than_Or_Equal_Operator;
         when A_Greater_Than_Operator          => return Adarorg_Types.Greater_Than_Operator;
         when A_Greater_Than_Or_Equal_Operator => return Adarorg_Types.Greater_Than_Or_Equal_Operator;
      end case;
   end To_Ada_Relational_Operator;

end Adarorg_Types.Asis_Types;
