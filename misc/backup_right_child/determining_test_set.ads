with
  Stack_Array,
  Bit_Operations;

package Determining_Test_Set is

   type Test_Pair is
      record
         Predicate : Integer;
         Determining_Clauses : Bit_Operations.Bit_Set;
         Outcome : Boolean;
      end record;

   function Is_Determining_Clause(Pair : Test_Pair;
                                  Clause_Index : Positive)
                                 return boolean;

   function Clause_Boolean_Value(Pair : Test_Pair;
                                 Clause_Index : Positive)
                                 return Boolean;

   package Test_Pairs is new Stack_Array (Test_Pair);
end Determining_Test_Set;
