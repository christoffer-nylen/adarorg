-- ASIS
with
  Asis.Elements,
  Asis.Declarations,
  Asis.Expressions,
  Asis.Statements,
  Asis.Text;

-- ADA
with
  Ada.Wide_Text_Io;
use
  Ada.Wide_Text_Io;

-- Adalog/Debug
with
  Asis_Debug,
  Utilities;

--RORG
with
  Active_Clauses,
  Adarorg_Constants,
  Determining_Test_Set,
  Instrumentation,
  Predicate,
  Predicate_Analysis,
  Predicate_Complicated_Clause,
  Predicate_Loop_Variables,
  Statistics;
use
  Adarorg_Constants,
  Predicate_Complicated_Clause;

package body Element_Processing is

   Inside_A_Predicate : Boolean;
   Predicate_Expression : Asis.Expression;

   procedure Process_Application_Unit(Unit_Name : Wide_String) is
   begin
      Inside_A_Predicate := False;
   end Process_Application_Unit;

   ------------------------------------------------------------------
   --                      PRE PROCESSING                          --
   ------------------------------------------------------------------
   procedure Post_Process_For_Loop_Statement is
   begin
      null;
   end Post_Process_For_Loop_Statement;

   procedure Process_Identifier (Ident : in Asis.Expression) is
      use Asis, Asis.Declarations, Asis.Elements, Asis.Expressions;
      use Utilities;
      use Predicate.Predicate_Tree;

      Clause : constant Predicate.Clause_Information := Predicate.Make_Clause(Ident);
      Node_Clause : constant Node_Access := Tree(Clause, null, null);
      type_decl : Asis.Declaration;
      Type_Def : Asis.Definition;

      Decl : Asis.Declaration;
      function Same_Name_Definition(Var1 : Asis.Expression; Var2 : Asis.Expression) return Boolean is
      begin
         return Is_Equal(Corresponding_Name_Definition(Var1), Corresponding_Name_Definition(Var2));
      end Same_Name_Definition;
      procedure Use_Of_Loop_Variable is new Predicate_Loop_Variables.Is_Used(Same_Name_Definition);
   begin

      if not Inside_A_Predicate then
         return;
      end if;

      type_decl := Corresponding_Expression_Type(Ident);
      case Declaration_Kind(type_decl) is
         when An_Ordinary_Type_Declaration =>
            Decl := Corresponding_Name_Declaration(Ident);
            if Declaration_Kind(Decl) = A_Loop_Parameter_Specification then
               Use_Of_Loop_Variable(Ident);
            end if;
         when others =>
            null;
      end case;

      if Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
   end Process_Identifier;

   procedure Process_Literal (Lit : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : constant Predicate.Clause_Information := Predicate.Make_Clause(Lit);
      Node_Clause : constant Node_Access := Tree(Clause, null, null);
   begin

      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
   end Process_Literal;

   procedure Process_Operator (Oper : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : constant Predicate.Clause_Information := Predicate.Make_Clause(Oper);
      Node_Clause : constant Node_Access := Tree(Clause, null, null);
   begin
      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;
      Predicate.Push(Node_Clause);
   end Process_Operator;

   procedure Process_Complicated_Element (Expr : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : constant Predicate.Clause_Information := Predicate.Make_Clause(Expr);
      Node_Clause : constant Node_Access := Tree(Clause, null, null);
   begin
      if not Inside_A_Predicate then
         return;
      end if;

      --Only push the parent node
      if not Is_Inside_A_Complicated_Clause then
         Predicate.Push(Node_Clause);
      end if;

      -- Tells element processing to ignore any children except for loop variables
      Enter_Complicated_Clause;
   end Process_Complicated_Element;

   procedure Post_Process_Complicated_Element is
   begin
      if not Inside_A_Predicate then
         return;
      end if;

      Leaving_Complicated_Clause;
   end Post_Process_Complicated_Element;

   procedure Process_Condition_Expression (Expr : in Asis.Expression) is
      use Asis, Asis.Elements;
      use Utilities;

   begin
      Inside_A_Predicate := True;
      Predicate_Expression := Expr;
   end Process_Condition_Expression;

   ------------------------------------------------------------------
   --                      POST PROCESSING                         --
   ------------------------------------------------------------------
   procedure Post_Process_Expression(Expr : in Asis.Expression) is
      use Asis.Elements;
      use Predicate.Predicate_Tree;
      use Utilities;

      Parent_Node : Node_Access;
   begin

      if Is_Equal(Expr, Predicate_Expression) then

         Parent_Node := Predicate.Peek;

         Active_Clauses.Find_Clauses(Parent_Node);
         --Print_Stack(Array_Of_Clauses);

         Put_Line("------------------------------------------------------------");
         Put("Predicate: ");
         Asis_Debug.Source_Print(Predicate_Expression);
         Put_Line("------------------------------------------------------------");

         Predicate_Analysis.Populate_Truth_Table(Parent_Node);

         declare
            Predicate_Pairs : Determining_Test_Set.Test_Pairs.Stack(2**PREDICATE_SIZE);
            procedure Build_Test_Coverage_Tree is new Determining_Test_Set.Test_Pairs.Iterate(Instrumentation.Add_Test_Coverage);
         begin
            Predicate_Analysis.Identify_Test_Set(Predicate_Pairs);
            if Determining_Test_Set.Test_Pairs.Length(Predicate_Pairs)>0 then
               Instrumentation.Clear;
               Build_Test_Coverage_Tree(Predicate_Pairs);
               Instrumentation.Push_Predicate_Expression(Expr);
               Instrumentation.Generate_RORG_Mark_Function_Declaration(Predicate_Pairs);
               --Predicate.Increment_Predicate_Counter;
               Predicate_Loop_Variables.Store_Used_Variables;
               Statistics.Data.Predicates_Tested := Statistics.Data.Predicates_Tested+1;

               --Clean
               Determining_Test_Set.Test_Pairs.Make_Empty(Predicate_Pairs);
               Instrumentation.Clear;
            else
               Predicate_Loop_Variables.Clear_Used_Variables;
            end if;
         end;

         --Clean
         --Predicate.Print_Tree(Parent_Node);
         Predicate.Destroy_Tree(Parent_Node);
         Predicate.Clear;
         Active_Clauses.Clear;
         Predicate_Analysis.Clear;

         Inside_A_Predicate := False;
      end if;
   end Post_Process_Expression;

   procedure Post_Process_Function_Call (Call : in Asis.Expression) is
      use Asis, Asis.Elements, Asis.Expressions;
      use Utilities;
      use Predicate.Predicate_Tree;

      Unknown_Operator : exception;

      Left_Child_Node, Parent_Node, Right_Child_Node : Node_Access;
      Left_Operand, Operator, Right_Operand : Asis.Element;

      procedure Pop_Node (E : out Asis.Element;
                          N : out Predicate.Predicate_Tree.Node_Access) is
      begin
         Predicate.Pop(N);
         E := N.Data.Element;
      end Pop_Node;
   begin

      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Pop_Node(Right_Operand, Right_Child_Node);
      Pop_Node(Operator, Parent_Node);

      case Operator_Kind(Operator) is
         when An_And_Operator | An_Or_Operator | An_Xor_Operator =>
            Pop_Node(Left_Operand, Left_Child_Node);
         when A_Relational_Operator =>
            Pop_Node(Left_Operand, Left_Child_Node);
         when A_Not_Operator | A_Unary_Plus_Operator | A_Unary_Minus_Operator | An_Abs_Operator =>
            Left_Child_Node := null;
         when
           A_Plus_Operator |
           A_Minus_Operator |
           A_Concatenate_Operator |
           A_Multiply_Operator |
           A_Divide_Operator |
           A_Mod_Operator |
           A_Rem_Operator |
           An_Exponentiate_Operator =>
            Pop_Node(Left_Operand, Left_Child_Node);
         when Not_An_Operator =>
            Trace("element_processing.adb : Unknown_Operator: ", Operator);
            raise Unknown_Operator;
      end case;

      Connect(Parent_Node, Left_Child_Node, Right_Child_Node);
      Predicate.Push(Parent_Node);

   end Post_Process_Function_Call;

   procedure Post_Process_Parenthesis (Parenthesis : in Asis.Expression) is
      use Asis.Declarations, Asis.Expressions;
      use Predicate.Predicate_Tree;
      use Utilities;
      Clause : constant Predicate.Clause_Information := Predicate.Make_Clause(Parenthesis);
      Right_Child_Node : Node_Access;
      Parent_Node : Node_Access := Tree(Clause, null, null);
   begin
      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Pop(Right_Child_Node);
      Connect(Parent_Node, null, Right_Child_Node);
      Predicate.Push(Parent_Node);
   end Post_Process_Parenthesis;
end Element_Processing;
