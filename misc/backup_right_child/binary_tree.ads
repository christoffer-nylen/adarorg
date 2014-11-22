generic
   type Element_Type is private;
package Binary_Tree is

   type Node;
   type Node_Access is access Node;

   type Node is record
      Data : Element_Type;
      Left : Node_Access := null;
      Right : Node_Access := null;
   end record;

   generic
      with procedure Subtract_Copy(Elem : in out Element_Type);
      with function Is_Unique(Elem : in Element_Type) return Boolean;
   procedure Destroy_Tree(N : in out Node_Access);

   function Tree(Value : Element_Type; Left : Node_Access; Right : Node_Access) return Node_Access;

   procedure Connect(Parent : in out Node_Access;
                     Left : in Node_Access;
                     Right : in Node_Access);

   --Debug
   generic
      with procedure Action (Data : in Element_Type);
   procedure Iterate(N : in Node_Access);

end Binary_Tree;
