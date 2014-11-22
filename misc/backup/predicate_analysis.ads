with
  Asis;

with
  Stack_Array,
  Binary_Map,
  Binary_Tree,
  Bit_Operations,
  Determining_Test_Set,
  Predicate;

package Predicate_Analysis is

   procedure Clear;

   procedure Populate_Truth_Table (Eval_Tree : in Predicate.Predicate_Tree.Node_Access);

   procedure Identify_Test_Set (Predicate_Pairs : out Determining_Test_Set.Test_Pairs.Stack);

end Predicate_Analysis;
