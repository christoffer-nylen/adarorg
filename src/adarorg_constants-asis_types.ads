----------------------------------------------------------------------
--  AdaRORG_Constants - Package specification                       --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

with
  Asis,
  Asis.Text;
use
  Asis;

package Adarorg_Constants.Asis_Types is

   subtype A_Relational_Operator is Operator_Kinds Range
     An_Equal_Operator ..
     A_Greater_Than_Or_Equal_Operator;

   Additional_Test_For_Boolean : array (A_Relational_Operator) of Boolean :=
     (False,--An_Equal_Operator
      True,--A_Not_Equal_Operator
      False,--A_Less_Than_Operator
      True,--A_Less_Than_Or_Equal_Operator
      False,--A_Greater_Than_Operator
      True);--A_Greater_Than_Or_Equal_Operator
   Additional_Test_For_Relop : array (A_Relational_Operator) of A_Relational_Operator :=
     (A_Less_Than_Operator, --An_Equal_Operator
      A_Less_Than_Operator,--A_Not_Equal_Operator
      An_Equal_Operator,--A_Less_Than_Operator
      An_Equal_Operator,--A_Less_Than_Or_Equal_Operator
      An_Equal_Operator,--A_Greater_Than_Operator
      An_Equal_Operator);--A_Greater_Than_Or_Equal_Operator
   Implicit_Additional_Test_For_Relop : array (A_Relational_Operator) of A_Relational_Operator :=
     (A_Greater_Than_Operator, --An_Equal_Operator
      A_Greater_Than_Operator,--A_Not_Equal_Operator
      A_Greater_Than_Operator,--A_Less_Than_Operator
      A_Less_Than_Operator,--A_Less_Than_Or_Equal_Operator
      A_Less_Than_Operator,--A_Greater_Than_Operator
      A_Greater_Than_Operator);--A_Greater_Than_Or_Equal_Operator
   Implicit_Test_For_Relop : array (A_Relational_Operator) of A_Relational_Operator :=
     (An_Equal_Operator,--An_Equal_Operator
      An_Equal_Operator,--A_Not_Equal_Operator
      A_Less_Than_Operator,--A_Less_Than_Operator
      A_Greater_Than_Operator,--A_Less_Than_Or_Equal_Operator
      A_Greater_Than_Operator,--A_Greater_Than_Operator
      A_Less_Than_Operator);--A_Greater_Than_Or_Equal_Operator

   RELATIONAL_OP_TOK : constant array (A_Relational_Operator) of String_Type(1..2) :=
     (" =",--An_Equal_Operator
      "/=",--A_Not_Equal_Operator
      " <",--A_Less_Than_Operator
      "<=",--A_Less_Than_Or_Equal_Operator
      " >",--A_Greater_Than_Operator
      ">=");--A_Greater_Than_Or_Equal_Operator

   subtype Text_Line_Number is Asis.Text.Line_Number;
   subtype Text_Column_Number is Positive;

end Adarorg_Constants.Asis_Types;
