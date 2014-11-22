with
  Predicate,
  Stack_Array;
package Active_Clauses is
   package Element_Stack is new Stack_Array(Predicate.Predicate_Tree.Node_Access);
   function Exists is new Element_Stack.Is_Present(Predicate.Is_Equal);
   function Get_Node(Node : Predicate.Predicate_Tree.Node_Access) return Predicate.Predicate_Tree.Node_Access;
   function Number_Of_Clauses return Natural;

   procedure Clear;
   procedure Get(X : out Predicate.Predicate_Tree.Node_Access; I : in Positive);

   procedure Find_Clauses(N : Predicate.Predicate_Tree.Node_Access);
end Active_Clauses;
