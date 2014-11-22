-- ASIS
with
  Asis,
  Asis.Elements,
  Asis.Declarations,
  Asis.Definitions,
  Asis.Expressions,
  Asis.Statements,
  Asis.Text;

-- ADA
with
  Ada.Unchecked_Conversion,
  Ada.Text_IO,
  Ada.Wide_Text_Io,
  Interfaces;
use
  Ada.Wide_Text_Io,
  Interfaces;

-- Stack (TODO: Källa)
with
  Stack_Array,
  Binary_Tree;

-- Adalog/Debug
with
  Asis_Debug,
  Utilities,
  Thick_Queries;

--RORG
with
  Active_Clauses,
  Determining_Test_Set,
  Instrumentation,
  Predicate,
  Predicate_Analysis,
  Predicate_Complicated_Clause,
  Predicate_Loop_Variables,
  Predicate_Queries,
  Rorg_Analysis_Constants;
use
  Predicate_Complicated_Clause,
  Rorg_Analysis_Constants;

package body Element_Processing is

   Inside_A_Predicate : Boolean;
   Predicate_Expression : Asis.Expression;

   procedure Process_Compilation_Unit(Unit_Name : Wide_String) is
   begin
      Inside_A_Predicate := False;
      Instrumentation.InputFileName(Unit_Name);
      Instrumentation.Generate_With_Clause;
   end Process_Compilation_Unit;

   procedure Post_Process_Compilation_Unit is
   begin
      Instrumentation.CloseFile;
   end Post_Process_Compilation_Unit;

   ------------------------------------------------------------------
   --                      PRE PROCESSING                          --
   ------------------------------------------------------------------
   procedure Process_Body_Declaration (Decl : in Asis.Declaration) is
      use Asis.Declarations;
   begin
      Process_Block_Statement(Body_Block_Statement(Decl));
   end;

   procedure Process_Block_Statement(Stmt : in Asis.Statement) is
      use Asis.Statements, Asis.Text;
      use Utilities;
      Items : Asis.Declarative_Item_List := Block_Declarative_Items(Stmt);
      Expr_Span : Span;
   begin
      if Items'Length=0 then
         --Put_Line("--No declarative items!");
         --Put_Line("-->Insert RORGCover after:" & Natural'Wide_Image(First_Line_Number(Stmt)));
         Expr_Span := Element_Span(Stmt);
         Instrumentation.PushInsertionPoint(Expr_Span.First_Line,Expr_Span.First_Column+INDENT_SIZE);
         --Instrumentation.PushInsertionPoint(First_Line_Number(Stmt),1);
      else
         --Put_Line("--Declarative items!");
         --Put_Line("-->Insert RORGCover after:" & Natural'Wide_Image(Last_Line));
         Expr_Span := Element_Span(Items(Items'Last));
         Instrumentation.PushInsertionPoint(Expr_Span.Last_Line,Expr_Span.First_Column);
      end if;
   end;

   procedure Process_For_Loop_Statement (Stmt : in Asis.Statement) is
      use Asis.Statements;
   begin
      null;
   end Process_For_Loop_Statement;

   procedure Post_Process_For_Loop_Statement is
   begin
      null;
   end Post_Process_For_Loop_Statement;

   procedure Post_Process_Body_Declaration is
   begin
      Instrumentation.Generate_RORG_Mark_Calls;
      Predicate_Loop_Variables.Reset_Used_Variables;
   end;

   procedure Process_Identifier (Ident : in Asis.Expression) is
      use Asis, Asis.Declarations, Asis.Elements, Asis.Expressions;
      use Utilities;
      use Predicate.Predicate_Tree;

      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Ident);
      Node_Clause : Node_Access := Tree(Clause, null, null);
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

      --Trace("Ident:", Ident);

      type_decl := Corresponding_Expression_Type(Ident);
      case Declaration_Kind(type_decl) is
         when An_Ordinary_Type_Declaration =>
            Decl := Corresponding_Name_Declaration(Ident);
            if Declaration_Kind(Decl) = A_Loop_Parameter_Specification then
               Use_Of_Loop_Variable(Ident);

               declare
                  Expr : Asis.Definition := Specification_Subtype_Definition(Corresponding_Name_Declaration(Ident));
               begin
                  case Discrete_Range_Kind(Expr) is
                     when A_Discrete_Subtype_Indication =>
                        Trace("Expr (Discrete_Subtype_Indication):", Expr);
                     when A_Discrete_Range_Attribute_Reference =>
                        Trace("Expr (Range_Attribute):", Expr);
                        Trace("->Prefix:", Prefix(Asis.Definitions.Range_Attribute(Expr)));
                        --Trace("Range_Attribute: ",Asis.Definitions.Range_Attribute(Expr));

                        --declare
                        --   Type_Decl2 : Asis.Declaration := Corresponding_Name_Declaration(Prefix(Asis.Definitions.Range_Attribute(Expr)));
                        --begin
                        --   Trace("Type_Decl2", Type_Decl2);
                          -- case Declaration_Kind(Type_Decl2) is
                          --    when An_Ordinary_Type_Declaration =>
                           --      Put_Line("-->An_Ordinary_Type_Declaration");
                          --    when A_Variable_Declaration =>
                           --      Put_Line("-->A_Variable_Declaration");
                           --when A_Subtype_Declaration =>
                        --null;
                        --when A_Constant_Declaration =>
                        --null;
                         --     when others =>
                         --        Put_Line("-->Others...");
                        --   end case;
                        --   end;

                     when A_Discrete_Simple_Expression_Range =>
                        Trace("Expr (Simple_Expr_Range):", Expr);
                     when Not_A_Discrete_Range =>
                        null;
                  end case;
               end;
            end if;
         when others =>
            --Put_Line("OTHERS!!");
            null;
      end case;

      if Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);
      --Trace("Pushed1: ", Node_Clause.Data.Element);

      type_decl := Corresponding_Expression_Type(Ident);

      case Declaration_Kind(type_decl) is
         when An_Ordinary_Type_Declaration =>
            --Put_Line ("-An_Ordinary_Type_Declaration");
            Type_Def := Type_Declaration_View(type_decl);
            case Type_Kind(Type_Def) is
               when An_Enumeration_Type_Definition =>
                  --Put_Line ("--An_Enumeration_Type_Declaration");
                  --Range?
                  --TODO:
                  null;
                  --Generate code
               when others =>
                  null;
            end case;
         when A_Subtype_Declaration =>
            --TODO: Låna ultimate fulhack ifrån adacontrol..
            null;
         when A_Variable_Declaration =>
            --Potential_Use_Of_Loop_Variable(Ident);
            null;
         when others =>
            null;
      end case;
   end Process_Identifier;

   procedure Process_Integer_Literal (Int : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Int);
      Node_Clause : Node_Access := Tree(Clause, null, null);
   begin

      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);
   end Process_Integer_Literal;

   procedure Process_Real_Literal (Real : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Real);
      Node_Clause : Node_Access := Tree(Clause, null, null);
   begin

      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);
   end Process_Real_Literal;

   procedure Process_String_Literal (Str : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Str);
      Node_Clause : Node_Access := Tree(Clause, null, null);
   begin

      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);
   end Process_String_Literal;

   procedure  Process_Character_Literal (Char : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Char);
      Node_Clause : Node_Access := Tree(Clause, null, null);
   begin

      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);
   end Process_Character_Literal;

   procedure Process_Enumeration_Literal (Enum : in Asis.Expression) is
      use Asis.Declarations, Asis.Expressions;
      use Predicate.Predicate_Tree;
      use Utilities;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Enum);
      Node_Clause : Node_Access := Tree(Clause, null, null);

      pos : Integer;
   begin
      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;

      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);

      pos := Integer'Wide_Value(Position_Number_Image(Corresponding_Name_Definition(Enum)));
      --Put_Line ("Number:" & Integer'Wide_Image(pos));
      --TODO:
   end Process_Enumeration_Literal;

   procedure Process_Operator (Oper : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Oper);
      Node_Clause : Node_Access := Tree(Clause, null, null);
   begin
      if not Inside_A_Predicate or Is_Inside_A_Complicated_Clause then
         return;
      end if;
      Predicate.Push(Node_Clause);
      --Element_Stack.Push(Node_Clause, Stack_Elements);
   end Process_Operator;

   procedure Process_Function_Call is
   begin
      null;
   end Process_Function_Call;

   procedure Process_Complicated_Element (Expr : in Asis.Expression) is
      use Predicate.Predicate_Tree;
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Expr);
      Node_Clause : Node_Access := Tree(Clause, null, null);
   begin
      if not Inside_A_Predicate then
         return;
      end if;

      --Only push the parent node
      if not Is_Inside_A_Complicated_Clause then
         Predicate.Push(Node_Clause);
         --Element_Stack.Push(Node_Clause, Stack_Elements);
         --Utilities.Trace("Pushed2:", Node_Clause.Data.Element);
      end if;

      -- Tells element processing to ignore any children except for loop variables
      Enter_Complicated_Clause;
      Utilities.Trace("Complicated_Expr:", Expr);
   end Process_Complicated_Element;

   procedure Post_Process_Complicated_Element is
   begin
      if not Inside_A_Predicate then
         return;
      end if;

      Leaving_Complicated_Clause;
   end Post_Process_Complicated_Element;

   procedure Process_Parenthesis (Parenthesis : in Asis.Expression) is
   begin
      null;
   end Process_Parenthesis;

   procedure Process_Path (Path : in Asis.Path) is
      use Asis, Asis.Elements, Asis.Statements;
      use Utilities;

      Condition : Asis.Expression;
   begin
      Inside_A_Predicate := True;
      Predicate_Expression := Condition_Expression(Path);
      Put_Line("Entering predicate...");
      Trace("Pred:", Predicate_Expression);
   end Process_Path;

   ------------------------------------------------------------------
   --                      POST PROCESSING                         --
   ------------------------------------------------------------------
   procedure Post_Process_Expression(Expr : in Asis.Expression) is
      use Asis.Elements;
      use Predicate.Predicate_Tree;
      use Utilities;

      Parent_Node : Node_Access;

      --procedure Print_Stack_Element (N : Predicate.Predicate_Tree.Node_Access) is
      --begin
      --   Utilities.Trace("Element:", N.Data.Element);
      --end Print_Stack_Element;
      --procedure Print_Stack is new Element_Stack.Iterate(Action => Print_Stack_Element);
   begin

      if Is_Equal(Expr, Predicate_Expression) then

         Parent_Node := Predicate.Peek;
         --Put_Line("----------------------------START REDUCE----------------------------------");
         --Predicate.Print_Tree(Parent_Node);
         --Put_Line("-----------------------------END REDUCE-----------------------------------");
         --Print_Stack(Stack_Elements);

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
            --TODO: Move to top?
            Output_File_Handle : File_Type;
         begin
            Predicate_Analysis.Identify_Test_Set(Predicate_Pairs);
            if Determining_Test_Set.Test_Pairs.Length(Predicate_Pairs)>0 then
               Instrumentation.Clear;
               Build_Test_Coverage_Tree(Predicate_Pairs);
               Instrumentation.PushPredicateExpression(Expr);
               Instrumentation.Generate_RORG_Mark_Function_Declaration(Predicate_Pairs);
               --Instrumentation.PushPredicateExpression(Expr);
               --Predicate.Increment_Predicate_Counter;
               Predicate_Loop_Variables.Store_Used_Variables;
               Predicate.Increment_Predicate_Counter;

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
         --Predicate.Destroy_Tree(Parent_Node);
         Active_Clauses.Clear;
         Predicate_Analysis.Clear;

         Inside_A_Predicate := False;
         Put_Line("Leaving Predicate...");
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

      Trace("Right:", Right_Operand);
      Trace("Operator:", Operator);

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
      Clause : Predicate.Clause_Information := Predicate.Make_Clause(Parenthesis);
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
