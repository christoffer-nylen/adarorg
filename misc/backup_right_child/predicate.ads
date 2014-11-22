with
  Asis;

with
  Stack_Array,
  Binary_Map,
  Binary_Tree,
  Bit_Operations,
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;

package Predicate is

   --TODO: make clause.ad[bs]
   --Tree Data
   type Clause_Information is
      record
         Element : Asis.Element;
         Value : Boolean;
         Absolute_Id : Integer;
         Relative_Id : Integer;
         Contains_Function_Call : Boolean;
         Number_Of_Equal_Clauses : Natural; --Needed to avoid dangling pointer
      end record;

   Predicate_Counter : Integer := 0;
   Current_Id : Integer := 1;

   function Has_Id(Data : Clause_Information) return Boolean;
   procedure Generate_Id(Data : in out Clause_Information);

   function Make_Clause(Elem : Asis.Element;
                        Value : Boolean := False;
                        Absolute_Id : Integer := NO_ID;
                        Relative_Id : Integer := NO_ID;
                        Contains_Function_Call : Boolean := False;
                        Number_Of_Equal_Clauses : Natural := 0) return Clause_Information;

   procedure Increment_Predicate_Counter;

   package Predicate_Tree is new Binary_Tree (Clause_Information);

   procedure Push(Node : in Predicate_Tree.Node_Access);
   procedure Pop(Node : out Predicate_Tree.Node_Access);
   function Peek return Predicate_Tree.Node_Access;
   procedure Clear;

   --Function used to avoid dangling pointer when freeing clauses
   --  returns true if clause is unique/can be destroyed
   procedure Decrement_Copies(Clause : in out Clause_Information);
   function Is_Last_Copy(Clause : in Clause_Information) return Boolean;
   procedure Destroy_Tree is new Predicate.Predicate_Tree.Destroy_Tree(Decrement_Copies, Is_Last_Copy);

   function Is_Equal (N1 : Predicate.Predicate_Tree.Node_Access;
                      N2 : Predicate.Predicate_Tree.Node_Access) return Boolean;
   function Eval(N : Predicate_Tree.Node_Access) return Boolean;
   procedure Update_Left_Clause(New_Clause : Predicate_Tree.Node_Access; Parent : Predicate_Tree.Node_Access);
   procedure Update_Right_Clause(New_Clause : Predicate_Tree.Node_Access; Parent : Predicate_Tree.Node_Access);

   procedure Print_Tree_Element (C : Clause_Information);
   procedure Print_Tree is new Predicate_Tree.Iterate(Action => Print_Tree_Element);

end Predicate;
