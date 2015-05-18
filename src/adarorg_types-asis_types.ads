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
  Asis;

package Adarorg_Types.Asis_Types is

   function To_Ada_Kind_Type(Kind : Asis.Type_Kinds) return Ada_Type_Kind;
   function To_Ada_Relational_Operator(Relop : A_Relational_Operator) return Ada_Relational_Operator;

end Adarorg_Types.Asis_Types;
