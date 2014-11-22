package Rorg is
   subtype String_Type is Wide_String;
   type A_Relational_Operator is (An_Equal_Operator,                 -- =
                                  A_Not_Equal_Operator,              -- /=
                                  A_Less_Than_Operator,              -- <
                                  A_Less_Than_Or_Equal_Operator,     -- <=
                                  A_Greater_Than_Operator,           -- >
                                  A_Greater_Than_Or_Equal_Operator); -- >=
   RELATIONAL_OP_TOK : constant array (A_Relational_Operator) of String_Type(1..2) :=
     (" =",--An_Equal_Operator
      "/=",--A_Not_Equal_Operator
      " <",--A_Less_Than_Operator
      "<=",--A_Less_Than_Or_Equal_Operator
      " >",--A_Greater_Than_Operator
      ">=");--A_Greater_Than_Or_Equal_Operator
   type Conditional_Relops is ('=','<','>');
   Is_Covered : array (1..1000, Conditional_Relops'Range) of Integer := (others => (others => 0));

   procedure Report_Analysis;
end Rorg;
