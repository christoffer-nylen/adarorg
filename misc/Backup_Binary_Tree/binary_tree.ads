package Binary_Tree is

   type Propositional_Logic_Kinds is
     (A_Negation, A_Conjunction, A_Disjunction, A_Clause);

   type Node;
   type Node_Access is access Node;
   type Node is record
      Data : Propositional_Logic_Kinds;
      Left : Node_Access := null;
      Right : Node_Access := null;
   end record;

   procedure Destroy_Tree(N : in out Node_Access);

   function Tree(Value : Propositional_Logic_Kinds; Left : Node_Access; Right : Node_Access) return Node_Access;

   function Eval(N : Node_Access) return Boolean;
end Binary_Tree;
