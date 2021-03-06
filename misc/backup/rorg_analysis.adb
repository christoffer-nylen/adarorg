-- ADA
with
  Ada.Text_Io,
  Ada.Wide_Text_Io,
  Ada.Characters.Handling,
  Ada.Command_Line;
use
  Ada.Wide_Text_Io;

-- ASIS
with
  Asis,
  Asis.Errors,
  Asis.Exceptions,
  Asis.Implementation,
  Asis.Ada_Environments,
  Asis.Compilation_Units,
  Asis.Elements,
  Asis.Iterator,
  Asis.Declarations,
  Asis.Expressions,
  Asis.Statements,
  Asis.Text;

-- Adalog
with
  Utilities;

-- RORG
with
  Context_Arguments,
  Element_Processing,
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;

procedure Rorg_Analysis is

   My_Context              : Asis.Context;
   My_Unit                    : Asis.Compilation_Unit;
   Unit_Name                  : Wide_String ( 1 .. 100 );
   Unit_Name_Length           : Natural;
   Path_Name                  : Wide_String ( 1 .. 100 );
   Path_Name_Length           : Natural;

   procedure Pre_Procedure
     (Element   : in     Asis.Element;
      Control   : in out Asis.Traverse_Control;
      State     : in out Boolean);

   procedure Post_Procedure
     (Element   : in     Asis.Element;
      Control   : in out Asis.Traverse_Control;
      State     : in out Boolean);

   procedure Traverse_Tree is new
     Asis.Iterator.Traverse_Element
       (Boolean, Pre_Procedure, Post_Procedure);

   procedure Pre_Procedure (Element : in Asis.Element;
                            Control    : in out Asis.Traverse_Control;
                            State      : in out Boolean) is
      use Asis, Asis.Elements, Asis.Expressions;
      use Utilities;

   begin -- Pre_Procedure
      case Element_Kind (Element) is
         when A_Declaration =>
            case Declaration_Kind (Element) is
               when A_Function_Body_Declaration =>
                  Element_Processing.Process_Body_Declaration(Element);
               when A_Procedure_Body_Declaration =>
                  Element_Processing.Process_Body_Declaration(Element);
               when A_Package_Body_Declaration =>
                  Element_Processing.Process_Body_Declaration(Element);
               when A_Task_Body_Declaration =>
                  Element_Processing.Process_Body_Declaration(Element);
               when An_Entry_Body_Declaration =>
                  Element_Processing.Process_Body_Declaration(Element);
               when others =>
                  null;
            end case;
         when An_Expression =>
            case Expression_Kind (Element) is
               when An_Integer_Literal =>
                  --Put_Line ("An_Integer_Literal:" &
                  --Asis.Expressions.Value_Image(Element));
                  Element_Processing.Process_Integer_Literal (Element);
               when A_Real_Literal =>
                  --Put_Line ("A_Real_Literal:" &
                  --Asis.Expressions.Value_Image(Element));
                  Element_Processing.Process_Real_Literal (Element);
               when A_String_Literal =>
                  --Put_Line ("A_String_Literal:" &
                  --Asis.Expressions.Value_Image(Element));
                  Element_Processing.Process_String_Literal (Element);
               when An_Identifier =>
                  --Put_Line ("An_Identifier:" &
                  --Asis.Expressions.Name_Image(Element));
                  Element_Processing.Process_Identifier (Element);
               when An_Operator_Symbol =>
                  --Put_Line ("An_Operator_Symbol:" &
                  --Asis.Expressions.Name_Image(Element));
                  Element_Processing.Process_Operator (Element);
               when A_Character_Literal =>
                  --Put_Line ("A_Character_Literal:" &
                  --Asis.Expressions.Name_Image(Element));
                  Element_Processing.Process_Character_Literal (Element);
               when An_Enumeration_Literal =>
                  --Put_Line ("An_Enumeration_Literal:" &
                  --Asis.Expressions.Name_Image(Element));
                  Element_Processing.Process_Enumeration_Literal (Element);
               when A_Function_Call =>
                  --Put_Line ("A_Function_Call:");
                  if Is_Prefix_Call(Element) then
                     Element_Processing.Process_Complicated_Element(Element);
                  end if;
               when An_Indexed_Component =>
                  --Put_Line ("An_Indexed_Component: Asis_Element_Table.Table (J)");
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Slice =>
                  --Put_Line ("A_Slice: Asis_Element_Table.Table (1 .. 3)");
                  null;
               when A_Selected_Component =>
                  --Put_Line ("A_Selected_Component: Asis.Hmmm");
                  Element_Processing.Process_Complicated_Element(Element);
               when An_Attribute_Reference =>
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Named_Array_Aggregate =>
                  --Put_Line ("type Element_List is array
                  --(List_Index range <>) of Element;");
                  --Put_Line ("A_Named_Array_Aggregate: Element_List'
                  --(1 => Node_To_Element_New (Node => Arg_Node,
                  --Starting_Element  => Definition))");
                  Trace("A_Named_Array_Aggregate",Element);
                  Put_Line("Asis.Abandon_Children");
                  Control := Asis.Abandon_Children;
               when An_And_Then_Short_Circuit =>
                  --Put_Line ("An_And_Then_Short_Circuit: a = Wee and then b = Hej");
                  Trace("rorg_analysis.adb : Short_Circuit: ", Element);
                  Put_Line("Asis.Abandon_Children");
                  Control := Asis.Abandon_Children;
               when An_Or_Else_Short_Circuit =>
                  --Put_Line ("An_Or_Else_Short_Circuit: a = Wee or else b = Hej");
                  Trace("rorg_analysis.adb : Short_Circuit: ", Element);
                  Put_Line("Asis.Abandon_Children");
                  Control := Asis.Abandon_Children;
               when A_Parenthesized_Expression =>
                  --Put_Line ("A_Parenthesized_Expression: (a = Wee or else b = Hej)");
                  Element_Processing.Process_Parenthesis (Element);
               when A_Type_Conversion =>
                  Put_Line("A_Type_Conversion");
                  Put_Line("Asis.Abandon_Children");
                  Control := Asis.Abandon_Children;
               when A_Qualified_Expression =>
                  --Put_Line ("A_Qualified_Expression:
                  --Element_List'(1 => Node_To_Element_New (Node => Arg_Node,
                  --Starting_Element  => Definition))");
                  Put_Line("A_Qualified_Expression");
                  Put_Line("Asis.Abandon_Children");
                  Control := Asis.Abandon_Children;
               when others =>
                  --Put_Line ("Put_Name:" & Asis.Expressions.Name_Image(Element));
                  null;
            end case;
         when A_Path =>
            case Path_Kind (Element) is
            when An_If_Path .. An_Elsif_Path =>
               Element_Processing.Process_Path (Element);
            when others =>
               null;
            end case;
         when A_Statement =>
            case Statement_Kind (Element) is
               when A_Block_Statement =>
                  --We skip declare blocks..
                  Put_Line("Asis.Abandon_Children");
                  Control := Asis.Abandon_Children;
                  --Element_Processing.Process_Block_Statement(Element);
               when A_For_Loop_Statement =>
                  Trace("Loop:", Element);
                  Element_Processing.Process_For_Loop_Statement(Element);
               when An_If_Statement =>
                  null;
               when others =>
                  null;
            end case;
         when others =>
            null;
      end case;
   end Pre_Procedure;

   procedure Post_Procedure (Element : in Asis.Element;
                             Control    : in out Asis.Traverse_Control;
                             State      : in out Boolean) is
      use Asis, Asis.Elements, Asis.Expressions;
      use Utilities;
   begin -- Post_Procedure
      case Element_Kind (Element) is
         when A_Declaration =>
            case Declaration_Kind (Element) is
               when A_Function_Body_Declaration =>
                  Element_Processing.Post_Process_Body_Declaration;
               when A_Procedure_Body_Declaration =>
                  Element_Processing.Post_Process_Body_Declaration;
               when A_Package_Body_Declaration =>
                  Element_Processing.Post_Process_Body_Declaration;
               when A_Task_Body_Declaration =>
                  Element_Processing.Post_Process_Body_Declaration;
               when An_Entry_Body_Declaration =>
                  Element_Processing.Post_Process_Body_Declaration;
               when others =>
                  null;
            end case;
         when An_Expression =>
            case Expression_Kind (Element) is
               when A_Function_Call =>
                  --TODO: Kolla parametrar p� stacken och generera kod
                  --Put_Line("Post_Process_Function_Call");
                  if Is_Prefix_Call(Element) then
                     Element_Processing.Post_Process_Complicated_Element;
                  else
                     Element_Processing.Post_Process_Function_Call(Element);
                  end if;
               when An_Indexed_Component =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Selected_Component =>
                  Element_Processing.Post_Process_Complicated_Element;
               when An_Attribute_Reference =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Parenthesized_Expression =>
                  Element_Processing.Post_Process_Parenthesis(Element);
               when others =>
                  null;
            end case;
            Element_Processing.Post_Process_Expression(Element);
         when A_Statement =>
            case Statement_Kind (Element) is
               when An_If_Statement =>
                  --TODO: Pop stack
                  --generated code shall record the state of variables

                  null;
               when A_For_Loop_Statement =>
                  Element_Processing.Post_Process_For_Loop_Statement;
               when others =>
                  null;
            end case;
            null;
         when others =>
            null;
      end case;
   end Post_Procedure;

   procedure Process_Unit (Unit : in Asis.Compilation_Unit) is
      use Ada.Characters.Handling;
      Control : Asis.Traverse_Control := Asis.Continue;
      State   : Boolean := True;

   begin

      case Asis.Compilation_Units.Unit_Origin (Unit) is
         when Asis.An_Application_Unit =>
            if Context_Arguments.Path_Exists then
               --TODO: Skicka inte som argument..
               Element_Processing.Process_Compilation_Unit(Path_Name(1..Path_Name_Length)  & Unit_Name(1..Unit_Name_Length));
            else
               Element_Processing.Process_Compilation_Unit(Unit_Name(1..Unit_Name_Length));
            end if;

            New_Line;
            Put_Line ("Processing Unit: " &
                      Asis.Compilation_Units.Unit_Full_Name(Unit));
            New_Line;
            Traverse_Tree (Asis.Elements.Unit_Declaration(Unit), Control, State);
         when others =>
            null;
      end case;

   end Process_Unit;

   procedure Post_Process_Unit is
   begin
      Element_Processing.Post_Process_Compilation_Unit;
   end;

begin -- Rorg_Analysis

   Asis.Implementation.Initialize;
   --Asis.Ada_Environments.Associate (My_Context, "My Context");

   --Flags: -CA -FS -I<dir>
   -- FS: All the trees considered as making up a given Context are created
   --   "on the fly", whether or not the corresponding tree file already exists.
   --   Once created, a tree file then is reused as long as the Context remains open.
   -- CA: The Context comprises all the tree files in the tree search path.
   --   ASIS processes all the tree files located in the tree search path
   --   associated with the Context.
   -- I<dir>: Defines the directory in which to search for source files
   -- when compiling sources to create a tree "on the fly".
   --TODO: don't include adatest path
   Context_Arguments.Initialize;
   Context_Arguments.Get_Path_Name(Path_Name, Path_Name_Length);
   Context_Arguments.Get_Unit_Name(Unit_Name, Unit_Name_Length);

   Asis.Ada_Environments.Associate (My_Context, "My Context",
                                    "-CA -FS -I/sw/adatest95/2.0/AdaTEST95/2.0/lib/adatest/ -I"&Path_Name(1..Path_Name_Length));
   Asis.Ada_Environments.Open (My_Context);

   --if Unit_Name_Length=0 then
   --   Put_Line ("Type the name of an Ada package specification");
   --   Get_Line (Unit_Name, Unit_Name_Length);
   --end if;

   --ASIS first tries to locate the source file 'Unit_Name' in the current
   --directory: '.'. If there is no such file in the currect directory. If
   --there is no such file in the current directory, ASIS continues the search
   --by looking into the directories listed in the value of ADA_INCLUDE_PATH
   --environment variable. If the source is found (say in the current
   --directory), ASIS creates the tree file by calling the compiler:
   -- $ gcc -c -gnatc -gnatt -I. -I- 'Unit_Name'.ads
   My_Unit := Asis.Compilation_Units.Compilation_Unit_Body
     ( Unit_Name ( 1 .. Unit_Name_Length), My_Context );

   if Asis.Compilation_Units.Is_Nil ( My_Unit )
   then
      Put (CONTEXT_UNIT_NOT_FOUND_MESSAGE);
      Put (Unit_Name ( 1 .. Unit_Name_Length));
      New_Line;
   else
      Put (CONTEXT_UNIT_FOUND_MESSAGE);
      Put (Unit_Name ( 1 .. Unit_Name_Length));
      New_Line;
      Process_Unit(My_Unit);
      Post_Process_Unit;
      New_Line;
   end if;

   Asis.Ada_Environments.Close (My_Context);
   Asis.Ada_Environments.Dissociate (My_Context);
   Asis.Implementation.Finalize;

exception

   when Asis.Exceptions.ASIS_Inappropriate_Context
      | Asis.Exceptions.ASIS_Inappropriate_Container
      | Asis.Exceptions.ASIS_Inappropriate_Compilation_Unit
      | Asis.Exceptions.ASIS_Inappropriate_Element
      | Asis.Exceptions.ASIS_Inappropriate_Line
      | Asis.Exceptions.ASIS_Inappropriate_Line_Number
      | Asis.Exceptions.ASIS_Failed
      =>

      Put (Asis.Implementation.Diagnosis);
      New_Line;
      Put (STATUS_VALUE_MESSAGE);
      Put (Asis.Errors.Error_Kinds'Wide_Image
           (Asis.Implementation.Status));
      New_Line;

   when others =>

      Put_Line ("Asis Application failed because of non-ASIS reasons");

end Rorg_Analysis;
