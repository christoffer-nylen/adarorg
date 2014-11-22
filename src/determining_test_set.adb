package body Determining_Test_Set is

   function Is_Determining_Clause(Pair : Test_Pair;
                                  Clause_Index : Positive)
                                 return boolean
   is
   begin
      return Bit_Operations.Bit_At(Clause_Index, Pair.Determining_Clauses);
   end Is_Determining_Clause;

   function Clause_Boolean_Value(Pair : Test_Pair;
                                 Clause_Index : Positive)
                                return boolean
   is
   begin
      --TODO: FAIL???
      return Bit_Operations.Bit_At(Clause_Index, Bit_Operations.To_Bit_Set(Pair.Predicate-1));
   end Clause_Boolean_Value;

end Determining_Test_Set;
