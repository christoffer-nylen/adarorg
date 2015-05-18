with
  Adarorg_Constants;
use
  Adarorg_Constants;
package Adarorg_Types is

   type Ada_Relational_Operator is (Equal_Operator,                  -- =
                                    Not_Equal_Operator,              -- /=
                                    Less_Than_Operator,              -- <
                                    Less_Than_Or_Equal_Operator,     -- <=
                                    Greater_Than_Operator,           -- >
                                    Greater_Than_Or_Equal_Operator); -- >=

   RELATIONAL_OP_STR : constant array (Ada_Relational_Operator) of String_Type(1..2) :=
     ("= ",--An_Equal_Operator
      "/=",--A_Not_Equal_Operator
      "< ",--A_Less_Than_Operator
      "<=",--A_Less_Than_Or_Equal_Operator
      "> ",--A_Greater_Than_Operator
      ">=");--A_Greater_Than_Or_Equal_Operator

   type Ada_Type_Kind is (No_Type,
                          Derived_Type,
                          Derived_Record_Extension,
                          Enumeration_Type,
                          Signed_Integer_Type,
                          Modular_Type,
                          Root_Type,
                          Floating_Point,
                          Ordinary_Fixed_Point,
                          Decimal_Fixed_Point,
                          Unconstrained_Array,
                          Constrained_Array,
                          Record_Type,
                          Tagged_Record_Type,
                          Interface_Type,
                          Access_Type);

   type Relop_Counter is
     array (Ada_Type_Kind, Ada_Relational_Operator) of Natural;

   function Sum(Elem : Relop_Counter) return Natural;
   function Sum(I : Ada_Type_Kind; Elem : Relop_Counter) return Natural;

--   Enumeration_Type,
--   Integer_Type,
--   Real_Type,
--   Access_Type,
--   Composite_Type,
--   Unknown_Type);

   type Static_Data is
      record
         Relops_Total : Relop_Counter;
         Relops_Tested : Relop_Counter;
         Predicates_Total : Natural;
         Predicates_Tested : Natural;
      end record;
end Adarorg_Types;
