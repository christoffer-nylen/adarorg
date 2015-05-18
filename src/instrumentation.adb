----------------------------------------------------------------------
--  Instrumentation - Package body                                  --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

-- TODO: The code in this file is horrible,
--       it will be refactorized later..

-- Asis
with
  Asis.Definitions,
  Asis.Declarations,
  Asis.Elements,
  Asis.Expressions,
  Asis.Statements,
  Asis.Text;

-- Ada
with
  Ada.Command_Line,
  Ada.Characters.Handling,
  Ada.Text_IO,
  Ada.Wide_Text_IO,
  Ada.Strings,
  Ada.Strings.Wide_Fixed,
  Ada.Unchecked_Conversion;
use
  Ada.Wide_Text_IO;

-- RORG
with
  Active_Clauses,
  Adarorg_Constants,
  Adarorg_Options,
  Bit_Operations,
  Filelist,
  Predicate,
  Predicate_Loop_Variables,
  Predicate_Queries,
  Stack_Array,
  Statistics;
use
  Adarorg_Constants;

package body Instrumentation is
   Test_Covered : array ( Positive range 1..2**PREDICATE_SIZE) of Boolean;

   File_Name        : String_Type(1..100);
   File_Name_Length : Positive;

   --Previous_In_Stream, Previous_Out_Stream : File_Type;
   Input_File_Handle, Output_File_Handle : File_Type;

   type Text_Position is
      record
         Line   : Text_Line_Number;
         Column : Text_Column_Number;
      end record;

   package Text_Positions is new Stack_Array(Text_Position);
   Corresponding_Declarative_Part : Text_Positions.Stack(STACK_SIZE);

   type Rorg_Marked_Expression is
      record
         Expression : Asis.Expression;
         Id         : Natural;
      end record;

   package Marked_Expressions is new Stack_Array(Rorg_Marked_Expression);
   Predicate_Expressions : Marked_Expressions.Stack(STACK_SIZE);

   -----------------
   -- Set_Streams --
   -----------------

   procedure Set_Streams(Out_File : File_Type := Output_File_Handle) is
   begin
      --Previous_In_Stream := Ada.Wide_Text_IO.Current_Input;
      --Previous_Out_Stream := Ada.Wide_Text_IO.Current_Output;
      Ada.Wide_Text_IO.Set_Input(Input_File_Handle);
      Ada.Wide_Text_IO.Set_Output(Out_File);
   end Set_Streams;

   ---------------------
   -- Restore_Streams --
   ---------------------

   procedure Restore_Streams is
   begin
      Ada.Wide_Text_IO.Set_Input(Standard_Input);
      Ada.Wide_Text_IO.Set_Output(Standard_Output);
   end Restore_Streams;

   --------------------------
   -- Push_Insertion_Point --
   --------------------------

   procedure Push_Insertion_Point(Line : Text_Line_Number; Column : Text_Column_Number) is
   begin
      Text_Positions.Push((Line => Line, Column => Column), Corresponding_Declarative_Part);
   end Push_Insertion_Point;

   -------------------------------
   -- Push_Predicate_Expression --
   -------------------------------

   procedure Push_Predicate_Expression(Expr : Asis.Expression) is
   begin
     Marked_Expressions.Push((Expression => Expr, Id => Statistics.Get_Predicates_Tested_Count), Predicate_Expressions);
   end Push_Predicate_Expression;

   ---------------------
   -- Input_File_Name --
   ---------------------

   procedure Input_File_Name(Input : Wide_String) is
      use Ada.Command_Line;
      use Ada.Characters.Handling;
   begin
      File_Name(Input'Range) := Input(Input'Range);
      File_Name_Length := Input'Length;

      Ada.Wide_Text_IO.Open(Input_File_Handle, In_File, To_String(Input) & ADA_BODY_FILE_EXTENSION); --TODO: Why input?
      Ada.Wide_Text_IO.Create(Output_File_Handle, Out_File, To_String(Adarorg_Options.Get_Unit_Name) & RORG_INSTRUMENTED_FILE_EXTENSION);
   exception
      when others =>
         Ada.Text_IO.Put_Line(Ada.Text_IO.Standard_Error, "Can not open the file '" & To_String(Input) & "'");
         Set_Exit_Status(Failure);
   end Input_File_Name;

   procedure Dos2unix_Put_Line(Str : in Wide_String) is
   begin
      Ada.Wide_Text_IO.Put_Line(Str);
      --Ada.Wide_Text_IO.Put(Str(Str'First..(Str'Last-1)));
      --if Line_End_Char=13 then --Fixes ^M (Vertical Tab)
      --Ada.Wide_Text_IO.New_Line;
      --else
      --   Ada.Wide_Text_IO.Put(Str(Str'Last));
      --end if;
   end Dos2unix_Put_Line;

   function To_Count is new Ada.Unchecked_Conversion (Source => Integer,
                                                      Target => Ada.Wide_Text_IO.Count);

   procedure Copy_Input_To_Output(Line : Text_Line_Number; Column : Natural := 0) is
      Current_Line_Number : Ada.Wide_Text_IO.Count;
   begin
      Current_Line_Number := Ada.Wide_Text_IO.Line(Input_File_Handle);
      for I in Current_Line_Number..To_Count(Line) loop
         if I=To_Count(Line) and Column /= 0 then
            declare
               Text_Line : Wide_String(1..(Column-1));
            begin
               Ada.Wide_Text_IO.Get(Text_Line);
               Ada.Wide_Text_IO.Put(Text_Line);
            end;
         else
            Dos2unix_Put_Line(Ada.Wide_Text_IO.Get_Line);
         end if;
      end loop;
   end Copy_Input_To_Output;

   procedure IgnoreInput(Line : Text_Line_Number; Column : Natural) is
      Skip_Next_Char : Wide_Character;
   begin
      Ada.Wide_Text_IO.Set_Line(Input_File_Handle, To_Count(Line));
      Ada.Wide_Text_IO.Set_Col(Input_File_Handle, To_Count(Column));
      Ada.Wide_Text_IO.Get(Input_File_Handle, Skip_Next_Char);
   end;

   procedure Close_File is
      use Statistics;
      use Filelist;

      procedure Copy_Untill_Eof is
      begin
         while not Ada.Wide_Text_IO.End_Of_File (Input_File_Handle) loop
            Dos2unix_Put_Line(Get_Line(Input_File_Handle));
         end loop;
      end;

      --function Adarorg_Options.Get_Unit_Name return Wide_String renames U_Name;
      --function Adarorg_Options.Get_Path_And_Unit_Name return Wide_String renames F_Name;

      U_Name  : Wide_String(1..100);
      F_Name  : Wide_String(1..100);
      FL_Data : Instrumented_File;
   begin
      Set_Streams;
      Copy_Untill_Eof;
      Restore_Streams;
      Ada.Wide_Text_IO.Close(Input_File_Handle);
      Ada.Wide_Text_IO.Close(Output_File_Handle);

      U_Name(1..Adarorg_Options.Get_Unit_Name'Length) := Adarorg_Options.Get_Unit_Name;
      F_Name(1..Adarorg_Options.Path_And_Unit_Name'Length) := Adarorg_Options.Path_And_Unit_Name;
      FL_Data := (U_Name, Adarorg_Options.Get_Unit_Name'Length, F_Name, Adarorg_Options.Path_And_Unit_Name'Length, Statistics.Get_Data);
      Filelist.Update_Filelist(FL_Data);
   end Close_File;

   procedure Clear is
   begin
      Test_Covered := (others => False);
   end Clear;

   function Left_Child(Index : Positive) return Positive is
   begin
      return 2*Index;
   end Left_Child;

   function Right_Child(Index : Positive) return Positive is
   begin
      return 2*Index+1;
   end Right_Child;

   procedure Generate_With_Clause is
   begin
      Set_Streams;
      Put_Line(WITH_TOK & SPACE_TOK & RORG_PACKAGE & SEMI_COLON_TOK);
      Restore_Streams;
   end Generate_With_Clause;

   procedure Generate_Rorg_Array_Increment(Id : Integer; Operator : Asis.Operator_Kinds) is
      use Ada.Strings, Ada.Strings.Wide_Fixed;
   begin
      Put_Line(RORG_PACKAGE & DOT_TOK & RORG_COVERAGE_ARRAY_TOK & LEFT_PAREN_TOK & Trim(Positive'Wide_Image(Id), Both) &
               COMMA_TOK & SINGLE_QUOTE_TOK &
               Trim(RELATIONAL_OP_TOK(Operator), Both) & SINGLE_QUOTE_TOK & RIGHT_PAREN_TOK &
               ASSIGN_TOK & RORG_PACKAGE & DOT_TOK & RORG_COVERAGE_ARRAY_TOK & LEFT_PAREN_TOK &
               Trim(Integer'Wide_Image(Id), Both) &
               COMMA_TOK & SINGLE_QUOTE_TOK &
               Trim(RELATIONAL_OP_TOK(Operator), Both) & SINGLE_QUOTE_TOK &
               RIGHT_PAREN_TOK & PLUS_ONE_TOK & SEMI_COLON_TOK);
   end Generate_Rorg_Array_Increment;

   function Generate_Operand(Clause_Index : Positive; Data : Predicate.Clause_Information; Arg : String_Type) return String_Type is
      use Asis, Asis.Elements, Asis.Text;
      use Ada.Strings, Ada.Strings.Wide_Fixed;
   begin
      if Data.Contains_Function_Call then
         return
           CLAUSE_ARG &
           Wide_Character'Val(Character'Pos('A')+Clause_Index-1) &
           UNDERSCORE_TOK & Arg;
      else
         return Trim(Element_Image(Enclosing_Element(Data.Element)), Both);
      end if;
   end;

   function Source(Clause_Index : Positive; Operator : Asis.Operator_Kinds := Asis.Not_An_Operator) return String_Type is
      use Asis, Asis.Elements, Asis.Text;
      use Ada.Strings, Ada.Strings.Wide_Fixed;
      use Predicate.Predicate_Tree;
      use Predicate_Queries;

      Clause_Node : Predicate.Predicate_Tree.Node_Access;
      Op : Asis.Operator_Kinds := Asis.Not_An_Operator;

   begin
      Active_Clauses.Get(Clause_Node, Clause_Index);

      if not Is_Relational_Clause(Clause_Node.Data.Element) then
         return Generate_Operand(Clause_Index, Clause_Node.Data, NONE_RELATIONAL_CLAUSE);
      end if;

      if Operator=Not_An_Operator then
         Op := Operator_Kind(Clause_Node.Data.Element);
      else
         Op := Operator;
      end if;

      --if Operator=Not_An_Operator then
         --return Trim(Element_Image(Enclosing_Element(Clause_Node.Data.Element)), Both);
         --return Generate_Operand(Clause_Index, Clause_Node.Data, NONE_RELATIONAL_CLAUSE);
      --else
         --return (Trim(Element_Image(Enclosing_Element(Clause_Node.Left.Data.Element)), Both) &
         --        Trim(RELATIONAL_OP_TOK(Operator), Both) &
         --        Trim(Element_Image(Enclosing_Element(Clause_Node.Right.Data.Element)), Both));
      return (Generate_Operand(Clause_Index, Clause_Node.Left.Data, CLAUSE_ARG_LEFT) &
              Trim(RELATIONAL_OP_TOK(Op), Both) &
              Generate_Operand(Clause_Index, Clause_Node.Right.Data, CLAUSE_ARG_RIGHT));
      --end if;
   end Source;

   procedure Generate_Expression(N : Predicate.Predicate_Tree.Node_Access; Abstract_Mode : Boolean := True) is
      use Ada.Strings, Ada.Strings.Wide_Fixed;
      use Asis.Text;

      Clause : Positive := 1;

      procedure Iter(N : Predicate.Predicate_Tree.Node_Access) is
         use Asis, Asis.Elements;

         procedure Generate_Clause is
            use Predicate_Queries;
         begin
            if Abstract_Mode then
               Put(Wide_Character'Val(Character'Pos('A')+N.Data.Relative_Id-1));
            else
               --Put("X");
               --Active_Clauses.Get_Node(N)
               --if Is_Relational_Clause(N.Data.Element) then
                  Put(Source(N.Data.Relative_Id));
               --else
               --   Put(Trim(Element_Image(N.Data.Element), Both));
               --end if;
            end if;
            Clause := Clause + 1;
         end Generate_Clause;
      begin
         case Expression_Kind (N.Data.Element) is
            when An_Identifier | An_Indexed_Component => -- (A Clause)
               Generate_Clause;
            when An_Operator_Symbol =>
               case Operator_Kind(N.Data.Element) is
                  when An_And_Operator =>
                     Iter(N.Left);
                     Put(SPACE_TOK & AND_TOK & SPACE_TOK);
                     Iter(N.Right);
                  when An_Or_Operator =>
                     Iter(N.Left);
                     Put(SPACE_TOK & OR_TOK & SPACE_TOK);
                     Iter(N.Right);
                  when An_Xor_Operator =>
                     Iter(N.Left);
                     Put(SPACE_TOK & XOR_TOK & SPACE_TOK);
                     Iter(N.Right);
                  when An_Equal_Operator =>
                     Generate_Clause;
                  when A_Not_Equal_Operator =>
                     Generate_Clause;
                  when A_Less_Than_Operator =>
                     Generate_Clause;
                  when A_Less_Than_Or_Equal_Operator =>
                     Generate_Clause;
                  when A_Greater_Than_Operator =>
                     Generate_Clause;
                  when A_Greater_Than_Or_Equal_Operator =>
                     Generate_Clause;
                  when
                    A_Plus_Operator |
                    A_Minus_Operator |
                    A_Concatenate_Operator |
                    A_Multiply_Operator |
                    A_Divide_Operator |
                    A_Mod_Operator |
                    A_Rem_Operator |
                    An_Exponentiate_Operator =>
                     null;
                  when A_Not_Operator =>
                     Put(NOT_TOK & SPACE_TOK);
                     Iter(N.Right);
                  when
                    A_Unary_Plus_Operator |
                    A_Unary_Minus_Operator |
                    An_Abs_Operator =>
                     null;
                  when Not_An_Operator =>
                     Put("predicate.adb : Not_An_Operator");
               end case;
            when A_Parenthesized_Expression =>
               Put(LEFT_PAREN_TOK);
               Iter(N.Right);
               PUT(RIGHT_PAREN_TOK);
            when A_Function_Call =>
               Generate_Clause;
            when others =>
               -- Put("predicate.adb : FAILED_TO_EVAL");
               -- TODO: shall short circuits be treated this way?
               Generate_Clause;
         end case;
      end Iter;
   begin
      Iter(N);
   end Generate_Expression;

   procedure Generate_RORG_Mark_Function_Declaration(Predicate_Pairs : Determining_Test_Set.Test_Pairs.Stack) is
      Test_Pair_Index : Positive := 1;

      --TODO: Take as parameter
      Function_Body_Indentation : Natural := 1;

      --TODO: Ta bort "Function" ifrån namnet
      procedure Generate_Function_Head is
         use Ada.Strings, Ada.Strings.Wide_Fixed;
         use Asis.Text;

         Expr       : constant Asis.Expression := Marked_Expressions.Peek(Predicate_Expressions).Expression;
         Expr_Span  : constant Span := Element_Span(Expr);
         Text_Lines : constant Line_List := Lines(Expr);

         procedure Generate_Parameters is
            procedure Put_Elem(Identifier : Asis.Expression) is
               use Asis;
               use Asis.Definitions;
               use Asis.Declarations;
               use Asis.Expressions;
               use Asis.Elements;
            begin
               Put(Trim(Element_Image(Corresponding_Name_Definition(Identifier)), Both) & SPACE_TOK & COLON_TOK & SPACE_TOK);
               declare
                  Expr : constant Asis.Definition := Specification_Subtype_Definition(Corresponding_Name_Declaration(Identifier));
               begin
                  case Discrete_Range_Kind(Expr) is
                     when A_Discrete_Subtype_Indication =>
                        Put(Trim(Element_Image(Expr), Both));
                     when A_Discrete_Range_Attribute_Reference =>
                        declare
                           Prefix_Expr : constant Asis.Expression := Prefix(Range_Attribute(Expr));
                        begin
                           case Expression_Kind(Prefix_Expr) is
                              when An_Identifier =>
                                 case Declaration_Kind(Corresponding_Name_Declaration(Prefix_Expr)) is
                                    when An_Ordinary_Type_Declaration =>
                                       Put(Trim(Element_Image(Prefix(Range_Attribute(Expr))), Both));
                                    when A_Variable_Declaration =>
                                       Put(LOOP_VARIABLE_TYPE_TOK);
                                    --when A_Subtype_Declaration =>
                                    when A_Constant_Declaration =>
                                       Put(LOOP_VARIABLE_TYPE_TOK);
                                    when others =>
                                       Put(LOOP_VARIABLE_TYPE_TOK);
                                 end case;
                              when An_Indexed_Component =>
                                 Put(LOOP_VARIABLE_TYPE_TOK);
                              when others =>
                                 Put(Trim(Element_Image(Prefix(Range_Attribute(Expr))), Both));
                           end case;
                        end;
                     when A_Discrete_Simple_Expression_Range =>
                        Put(LOOP_VARIABLE_TYPE_TOK);
                     when Not_A_Discrete_Range =>
                        Put_Line("???");
                  end case;
               end;
            end Put_Elem;
            procedure Put_Delim is
            begin
               Put(PARAMETER_DELIMITER_TOK);
            end Put_Delim;
            procedure Put_Parameters is new Predicate_Loop_Variables.Put_As_Parameters(Put_Delim, Put_Elem);
         begin
            if Predicate_Loop_Variables.Has_Used_Variable then
               Put(LEFT_PAREN_TOK);
               Put_Parameters;
               Put(RIGHT_PAREN_TOK);
            end if;
         end;

         procedure Indentation is
         begin
            for I in 1..(Function_Body_Indentation-1) loop
               Put(SPACE_TOK);
            end loop;
         end Indentation;

         procedure Generate_Clauses is
            use Asis.Elements;

            Clause_Node : Predicate.Predicate_Tree.Node_Access;
         begin
            for Clause_Index in 1..Active_Clauses.Number_Of_Clauses loop
               Active_Clauses.Get(Clause_Node, Clause_Index);
               Indentation;
               Put(COMMENT_TOK & SPACE_TOK & CLAUSE_COMMENT & SPACE_TOK);
               Put(Wide_Character'Val(Character'Pos('A')+Clause_Index-1));
               Put(SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK &
                   SPACE_TOK & SPACE_TOK & COLON_TOK & SPACE_TOK);

               --Put(Trim(Element_Image(Enclosing_Element(Clause_Node.Data.Element)), Both));

               declare
                  Text_Lines2 : constant Line_List := Lines(Enclosing_Element(Clause_Node.Data.Element));
               begin
                  Put_Line(Trim(Line_Image(Text_Lines2(Text_Lines2'First)), Both));
                  for I in (Text_Lines2'First+1)..Text_Lines2'Last loop
                     Indentation;
                     Put_Line(COMMENT_TOK & SPACE21_TOK & Trim(Line_Image(Text_Lines2(I)), Both));
                  end loop;
               end;
            end loop;
         end Generate_Clauses;

         procedure Generate_Additional_Info is
            use Predicate_Queries;
            Clause_Node  : Predicate.Predicate_Tree.Node_Access;
            Put_Headline : Boolean := True;
            procedure Put_Clause(Data : Predicate.Clause_Information) is
            begin
               declare
                  Text_Lines2 : constant Line_List := Lines(Data.Element);
               begin
                  Put(SINGLE_QUOTE_TOK & Trim(Line_Image(Text_Lines2(Text_Lines2'First)), Both));
                  for I in (Text_Lines2'First+1)..Text_Lines2'Last loop
                     New_Line;
                     Indentation;
                     Put(COMMENT_TOK & SPACE21_TOK & Trim(Line_Image(Text_Lines2(I)), Both));
                  end loop;
               end;
               Put(SINGLE_QUOTE_TOK & SPACE_TOK);
            end Put_Clause;
            procedure Put_Range_Info(Data : Predicate.Clause_Information) is
            begin
               if Data.Contains_Range_First then
                  Put(IS_FIRST_COMMENT);
               elsif Data.Contains_Range_Last then
                  Put(IS_LAST_COMMENT);
               end if;
            end Put_Range_Info;
         begin
            for Clause_Index in 1..Active_Clauses.Number_Of_Clauses loop
               Active_Clauses.Get(Clause_Node, Clause_Index);
               if
                 not Predicate.Is_Comparable(Clause_Node.Data) or
                 not Is_Relational_Clause(Clause_Node.Data.Element) then
                  if Put_Headline then
                     Indentation;
                     Put_Line(COMMENT_TOK);
                     Indentation;
                     Put_Line(COMMENT_TOK & SPACE_TOK &ADDITIONAL_INFO_COMMENT);
                     Put_Headline := False;
                  end if;
                  Indentation;
                  Put(COMMENT_TOK & SPACE_TOK & CLAUSE_COMMENT & SPACE_TOK);
                  Put(Wide_Character'Val(Character'Pos('A')+Clause_Index-1));
                  Put(SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK &
                      SPACE_TOK & SPACE_TOK & COLON_TOK & SPACE_TOK);
                  if Is_Relational_Clause(Clause_Node.Data.Element) then
                     if not Predicate.Is_Comparable(Clause_Node.Left.Data) then
                        Put_Clause(Clause_Node.Left.Data);
                        Put_Range_Info(Clause_Node.Left.Data);
                     else
                        Put_Clause(Clause_Node.Right.Data);
                        Put_Range_Info(Clause_Node.Right.Data);
                     end if;
                  else
                     Put_Clause(Clause_Node.Data);
                     Put(IS_REGULAR_CLAUSE_COMMENT);
                  end if;
                  Put_Line(SPACE_TOK & NOT_TESTED_COMMENT);
               end if;
            end loop;
         end Generate_Additional_Info;
      begin
         -- RORG MARK COMMENT PART
         New_Line;
         Indentation;
         Put_Line(COMMENT_TOK & SPACE_TOK & FUNCTION_NAME_TOK &
                  Trim(Natural'Wide_Image(Statistics.Get_Predicates_Tested_Count),Both));
         Indentation;
         Put_Line(COMMENT_TOK & SPACE_TOK & LOCATION_COMMENT &
                  SPACE_TOK & File_Name(1..File_Name_Length) & ADA_BODY_FILE_EXTENSION_TOK & COLON_TOK &
                  Trim(Positive'Wide_Image(Expr_Span.First_Line), Both) & COLON_TOK &
                  Trim(Positive'Wide_Image(Expr_Span.First_Column), Both) & COLON_TOK);
         Indentation;
         Put_Line(COMMENT_TOK);
         Indentation;
         Put(COMMENT_TOK & SPACE_TOK & ABSTRACT_EXPRESSION_COMMENT & SPACE_TOK);
         Generate_Expression(Predicate.Peek);
         New_Line;
         Generate_Clauses;
         Generate_Additional_Info;
         Indentation;
         Put_Line(COMMENT_TOK);
         Indentation;
         Put_Line(COMMENT_TOK & SPACE_TOK & RORG_MARK_COMMENT);
         for I in Text_Lines'Range loop
            Indentation;
            Put_Line(COMMENT_TOK & SPACE_TOK & Line_Image(Text_Lines(I)));
         end loop;
         -- RORG MARK FUNCTION HEAD
         Indentation;
         Put(FUNCTION_TOK & SPACE_TOK & FUNCTION_NAME_TOK &
             Trim(Natural'Wide_Image(Statistics.Get_Predicates_Tested_Count),Both));
         Generate_Parameters;
         Put_Line(SPACE_TOK & RETURN_TOK & SPACE_TOK & BOOLEAN_TOK &
                  SPACE_TOK & IS_TOK);
      end Generate_Function_Head;

      procedure Generate_Function_Declaration_Part is
         use Predicate.Predicate_Tree;
         use Predicate_Queries;

         Number_Of_Clauses : constant Natural := Active_Clauses.Number_Of_Clauses;

         procedure Indentation is
         begin
            for I in 1..(INDENT_SIZE+Function_Body_Indentation-1) loop
               Put(SPACE_TOK);
            end loop;
         end Indentation;

         procedure Generate_Declaration(Clause_Index : Positive;
                                        Clause_Node  : Predicate.Predicate_Tree.Node_Access;
                                        Arg          : String_Type) is
            use Asis, Asis.Elements, Asis.Expressions, Asis.Declarations, Asis.Text;
            use Ada.Strings, Ada.Strings.Wide_Fixed;

            Data : constant Predicate.Clause_Information := Clause_Node.Data;

            procedure Generate_Type(Node : Predicate.Predicate_Tree.Node_Access) is
               --Unknown_Kind : exception;
            begin
               case Expression_Kind(Node.Data.Element) is
                  when A_Parenthesized_Expression =>
                     Generate_Type(Node.Right);
                  when A_Function_Call =>
                     declare
                        Decl   : constant Asis.Declaration := Corresponding_Called_Function(Node.Data.Element);
                        Result : constant Asis.Element := Result_Profile(Decl);
                     begin
                        Put(Trim(Element_Image(Result), Both));
                     end;
                  when others =>
                     Put("Unknown_Type");
                     --raise Unknown_Kind;
               end case;
            end Generate_Type;

         begin
            if Data.Contains_Function_Call then
               Indentation;
               Put(Generate_Operand(Clause_Index, Data, Arg) & SPACE_TOK &
                   COLON_TOK & SPACE_TOK);
               Generate_Type(Clause_Node);
               Put_Line(SPACE_TOK &
                        ASSIGN_TOK & SPACE_TOK &
                        Trim(Element_Image(Enclosing_Element(Data.Element)), Both) &
                        SEMI_COLON_TOK);
            end if;
         end;
         Clause_Node : Predicate.Predicate_Tree.Node_Access;

      begin
         for Clause in 1..Number_Of_Clauses loop
            Active_Clauses.Get(Clause_Node, Clause);
            if Is_Relational_Clause(Clause_Node.Data.Element) then
               Generate_Declaration(Clause, Clause_Node.Left, CLAUSE_ARG_LEFT);
               Generate_Declaration(Clause, Clause_Node.Right, CLAUSE_ARG_RIGHT);
            else
               Generate_Declaration(Clause, Clause_Node, NONE_RELATIONAL_CLAUSE);
            end if;
         end loop;
      end;

      procedure Generate_Function_End is
         use Ada.Strings, Ada.Strings.Wide_Fixed;
         procedure Indentation is
         begin
            for I in 1..(Function_Body_Indentation-1) loop
               Put(SPACE_TOK);
            end loop;
         end Indentation;
      begin
         -- RORG MARK RETURN
         if Active_Clauses.Number_Of_Clauses>1 then
            Indentation;
            Put(INDENT_SPACE_TOK & RETURN_TOK & SPACE_TOK);
            Generate_Expression(Predicate.Peek, Abstract_Mode => False);
            Put_Line(SEMI_COLON_TOK);
         end if;

         -- RORG MARK FUNCTION END
         Indentation;
         Put_Line(END_TOK & SPACE_TOK & FUNCTION_NAME_TOK &
                  Trim(Natural'Wide_Image(Statistics.Get_Predicates_Tested_Count),Both) &
                  SEMI_COLON_TOK);
      end;

      procedure Generate_Function_Body(Index : Positive; Depth : Natural) is
         procedure Indentation is
         begin
            for I in 1..(((Depth+1)*INDENT_SIZE)+Function_Body_Indentation-1) loop
               Put(SPACE_TOK);
            end loop;
         end Indentation;

         procedure Generate_Rorg_Coverage(Depth : Natural) is
            use Determining_Test_Set;
            Current_Pair : Determining_Test_Set.Test_Pair;
            Clause_Node : Predicate.Predicate_Tree.Node_Access;

            --TODO: Remove reduncant code
            procedure Indentation is
            begin
               for I in 1..(((Depth+1)*INDENT_SIZE)+Function_Body_Indentation-1) loop
                  Put(SPACE_TOK);
               end loop;
            end Indentation;

            procedure Generate_Relational_Test_Coverage(Clause_Value : Boolean; Clause_Index : Positive) is
               use Ada.Strings, Ada.Strings.Wide_Fixed;
               use Asis.Elements;
               use Asis.Text;

               Op_Kind : constant Asis.Operator_Kinds := Operator_Kind(Clause_Node.Data.Element);

            begin
               --Put_Line("--IF "&Boolean'Wide_Image(Additional_Test_For_Boolean(Op_Kind))&"="&Boolean'Wide_Image(Clause_Value));
               if Additional_Test_For_Boolean(Op_Kind)=Clause_Value then
                  Indentation;
                  Put_Line(IF_TOK & SPACE_TOK &
                           Source(Clause_Index, Additional_Test_For_Relop(Op_Kind)) &
                           SPACE_TOK & THEN_TOK);
                  Indentation;
                  Put(INDENT_SPACE_TOK);
                  Generate_Rorg_Array_Increment(Clause_Node.Data.Absolute_Id, Additional_Test_For_Relop(Op_Kind));
                  Indentation;
                  Put_Line(ELSE_TOK);
                  Indentation;
                  Put(INDENT_SPACE_TOK);
                  Generate_Rorg_Array_Increment(Clause_Node.Data.Absolute_Id, Implicit_Additional_Test_For_Relop(Op_Kind));
                  Indentation;
                  Put_Line(END_IF_TOK & SEMI_COLON_TOK);
               else
                  Indentation;
                  Generate_Rorg_Array_Increment(Clause_Node.Data.Absolute_Id, Implicit_Test_For_Relop(Op_Kind));
               end if;
            end Generate_Relational_Test_Coverage;

         begin
            -- RORG TEST CASE COMMENT
            Determining_Test_Set.Test_Pairs.Get(Current_Pair, Test_Pair_Index, Predicate_Pairs);
            Indentation;
            Put(COMMENT_TOK & SPACE_TOK & TEST_CASE_COMMENT & SPACE_TOK);
            for Clause in 1..Active_Clauses.Number_Of_Clauses loop
               Put(Wide_Character'Val(Character'Pos('A')-1+Clause) & EQUALS_TOK);
               if Clause_Boolean_Value(Current_Pair, Active_Clauses.Number_Of_Clauses-Clause+1) then
                  Put(TRUE_TOK);
                  if Clause /= Active_Clauses.Number_Of_Clauses then
                     Put(COMMA_TOK & SPACE_TOK & SPACE_TOK);
                  end if;
               else
                  Put(FALSE_TOK);
                  if Clause /= Active_Clauses.Number_Of_Clauses then
                     Put(COMMA_TOK & SPACE_TOK);
                  end if;
               end if;
            end loop;
            Put(SPACE_TOK & IMPLIES_TOK & SPACE_TOK);
            if Current_Pair.Outcome then
               Put(TRUE_TOK);
            else
               Put(FALSE_TOK);
            end if;
            New_Line;
            Indentation;
            Put(COMMENT_TOK & SPACE_TOK & DETERMINING_CLAUSES_COMMENT & SPACE_TOK);
            for Clause in 1..Active_Clauses.Number_Of_Clauses loop
               if Is_Determining_Clause(Current_Pair, Active_Clauses.Number_Of_Clauses-Clause+1) then
                  Put(Wide_Character'Val(Character'Pos('A')-1+Clause));
                  if Clause /= Active_Clauses.Number_Of_Clauses then
                     Put(COMMA_TOK);
                  end if;
                  Put(SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK);
               else
                  Put(SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK & SPACE_TOK);
                  if Clause /= Active_Clauses.Number_Of_Clauses then
                     Put(SPACE_TOK);
                  end if;
               end if;
            end loop;
            New_Line;

            for Clause in 1..Active_Clauses.Number_Of_Clauses loop
               if Is_Determining_Clause(Current_Pair, Active_Clauses.Number_Of_Clauses-Clause+1) then
                  -- RORG CLAUSE COMMENT
                  New_Line;
                  Indentation;
                  Put(COMMENT_TOK & SPACE_TOK & CLAUSE_COMMENT & SPACE_TOK &
                      Wide_Character'Val(Character'Pos('A')+Clause-1) &
                      COLON_TOK);
                  New_Line;

                  Active_Clauses.Get(Clause_Node, Clause);
                  Generate_Relational_Test_Coverage(Clause_Boolean_Value(Current_Pair, Active_Clauses.Number_Of_Clauses-Clause+1), Clause);
               end if;
               --if Clause /= Active_Clauses.Number_Of_Clauses then
               --   New_Line;
               --end if;
            end loop;

            New_Line;
            Indentation;
            Put(RETURN_TOK & SPACE_TOK);
            if Current_Pair.Outcome then
               Put(TRUE_TOK);
            else
               Put(FALSE_TOK);
            end if;
            Put_Line(SEMI_COLON_TOK);

            Test_Pair_Index := Test_Pair_Index+1;
         end;
      begin
         if Test_Covered(Left_Child(Index)) then
            Indentation;
            Put_Line(IF_NOT_TOK & SPACE_TOK & LEFT_PAREN_TOK & Source(Depth+1) & RIGHT_PAREN_TOK & SPACE_TOK & THEN_TOK);
            Generate_Function_Body(Left_Child(Index), Depth+1);
            if Test_Covered(Right_Child(Index)) then
               Indentation;
               Put_Line(ELSE_TOK);
               Generate_Function_Body(Right_Child(Index), Depth+1);
            end if;
            Indentation;
            Put_Line(END_IF_TOK & SEMI_COLON_TOK);
         elsif Test_Covered(Right_Child(Index)) then
            Indentation;
            Put_Line(IF_TOK & SPACE_TOK & Source(Depth+1) & SPACE_TOK & THEN_TOK);
            Generate_Function_Body(Right_Child(Index), Depth+1);
            Indentation;
            Put_Line(END_IF_TOK & SEMI_COLON_TOK);
         else
            Generate_Rorg_Coverage(Depth);
         end if;
      end Generate_Function_Body;

      procedure Indentation is
      begin
         for I in 1..(Function_Body_Indentation-1) loop
            Put(SPACE_TOK);
         end loop;
      end Indentation;
   begin
      Set_Streams;
      Copy_Input_To_Output(Text_Positions.Peek(Corresponding_Declarative_Part).Line);
      Function_Body_Indentation := Text_Positions.Peek(Corresponding_Declarative_Part).Column;
      Generate_Function_Head;
      Generate_Function_Declaration_Part;
      Indentation;
      Put_Line(BEGIN_TOK);
      Generate_Function_Body(1, 0);
      Generate_Function_End;
      Restore_Streams;
   end Generate_RORG_Mark_Function_Declaration;

   procedure Generate_RORG_Mark_Calls is
      Number_Of_Predicates : constant Natural := Marked_Expressions.Length(Predicate_Expressions);
      RM_Expr : Rorg_Marked_Expression;
      procedure Generate_RORG_Mark_Call(RM_Expr : Rorg_Marked_Expression) is
         use Asis.Text;
         use Ada.Strings, Ada.Strings.Wide_Fixed;
         Expr_Span : constant Span := Element_Span(RM_Expr.Expression);

         -- Generate arguments if loop variables are present.
         procedure Generate_Arguments is
            procedure Put_Elem(Identifier : Asis.Expression) is
               use Asis;
               use Asis.Definitions;
               use Asis.Declarations;
               use Asis.Expressions;
               use Asis.Elements;
            begin
               Put(Trim(Element_Image(Corresponding_Name_Definition(Identifier)), Both));
            end Put_Elem;
            procedure Put_Delim is
            begin
               Put(ARGUMENT_DELIMITER_TOK);
            end Put_Delim;
            procedure Put_Arguments is new Predicate_Loop_Variables.Put_As_Parameters(Put_Delim, Put_Elem);
         begin
            if Predicate_Loop_Variables.Has_Used_Variable then
               Put(LEFT_PAREN_TOK);
               Put_Arguments;
               Put(RIGHT_PAREN_TOK);
            end if;
         end Generate_Arguments;
      begin
         Copy_Input_To_Output(Expr_Span.First_Line, Expr_Span.First_Column);
         -- RORG MARK FUNCTION CALL
         Put(FUNCTION_NAME_TOK & Trim(Natural'Wide_Image(RM_Expr.Id),Both));
         Predicate_Loop_Variables.Set_Predicate(RM_Expr.Id);
         Generate_Arguments;
         --Put(SPACE_TOK);
         IgnoreInput(Expr_Span.Last_Line, Expr_Span.Last_Column);
      end Generate_RORG_Mark_Call;
   begin
      Set_Streams;
      for I in 1..Number_Of_Predicates loop
         Marked_Expressions.Get(RM_Expr, I, Predicate_Expressions);
         Generate_RORG_Mark_Call(RM_Expr);
      end loop;
      Restore_Streams;
      Marked_Expressions.Make_Empty(Predicate_Expressions);
      Text_Positions.Pop(Corresponding_Declarative_Part);
      --Utilities.Trace("Poped", Line);
   end Generate_RORG_Mark_Calls;

   procedure Add_Test_Coverage(Pair : Determining_Test_Set.Test_Pair) is
      Depth : Natural := 0;

      procedure Iterative_Add(Index : Natural) is
         use Bit_Operations;
      begin
         Test_Covered(Index) := True;

         if Depth=Active_Clauses.Number_Of_Clauses then
            --Put_Line("[Leaf]");
            return;
         end if;

         Depth := Depth+1;
         if Bit_At(Active_Clauses.Number_Of_Clauses-Depth+1, To_Bit_Set(Pair.Predicate-1))=False then
            --if Test_Covered(Left_Child(Index))=False then
               --Put_Line("if not");
            --end if;
            Iterative_Add(Left_Child(Index));
         else
            --if Test_Covered(Right_Child(Index))=False then
               --if Test_Covered(Left_Child(Index))=False then
                  --Put_Line("if");
               --else
                  --Put_Line("else");
               --end if;
            --end if;
            Iterative_Add(Right_Child(Index));
         end if;
      end Iterative_Add;

   begin
      --Put_Line("Key:"&Integer'Wide_Image(Pair.Predicate));
      Iterative_Add(1);
   end Add_Test_Coverage;

   procedure Process_Body_Declaration (Decl : in Asis.Declaration) is
      use Asis.Declarations;

      procedure Process_Block_Statement(Stmt : in Asis.Statement) is
         use Asis.Statements, Asis.Text;
         use Ada.Characters.Handling;

         Items : constant Asis.Declarative_Item_List := Block_Declarative_Items(Stmt);
         Expr_Span : Span;
      begin
         if Items'Length=0 then
            --Put_Line("--No declarative items!");
            --Put_Line("-->Insert RORGCover after:" & Natural'Wide_Image(First_Line_Number(Stmt)));
            Expr_Span := Element_Span(Stmt);
            Ada.Text_IO.Put_Line(Ada.Text_IO.Standard_Error, "First_Line: '" & To_String(Integer'Wide_Image(Expr_Span.First_Line)) & "'");
            Instrumentation.Push_Insertion_Point(Expr_Span.First_Line,Expr_Span.First_Column+INDENT_SIZE);
            --Instrumentation.PushInsertionPoint(First_Line_Number(Stmt),1);
         else
            --Put_Line("--Declarative items!");
            --Put_Line("-->Insert RORGCover after:" & Natural'Wide_Image(Last_Line));
            Expr_Span := Element_Span(Items(Items'Last));
            Instrumentation.Push_Insertion_Point(Expr_Span.Last_Line,Expr_Span.First_Column);
         end if;
      end;
   begin
      Process_Block_Statement(Body_Block_Statement(Decl));
      null;
   end Process_Body_Declaration;

end Instrumentation;
