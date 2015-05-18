----------------------------------------------------------------------
--  Framework - Package body                                        --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

-- Ada
with
  Ada.Wide_Text_Io;
use
  Ada.Wide_Text_Io;

-- ASIS
with
  Asis.Compilation_Units,
  Asis.Elements,
  Asis.Expressions,
  Asis.Iterator,
  Asis.Statements;

-- Adalog
with
  Utilities;

-- AdaRORG
with
  Adarorg_Constants,
  Adarorg_Constants.Asis_Types,
  Adarorg_Options,
  Element_Processing,
  Instrumentation,
  Predicate_Loop_Variables, --TODO: Fix this
  Statistics;
use
  Adarorg_Constants,
  Adarorg_Constants.Asis_Types;

package body Framework is

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

   -------------------
   -- Pre_Procedure --
   -------------------

   procedure Pre_Procedure (Element : in Asis.Element;
                            Control    : in out Asis.Traverse_Control;
                            State      : in out Boolean) is
      use Asis, Asis.Elements, Asis.Expressions;
      use Utilities;

   begin -- Pre_Procedure
      case Element_Kind (Element) is
         when A_Declaration =>
            case Declaration_Kind (Element) is
               when A_Function_Body_Declaration |
                 A_Procedure_Body_Declaration |
                 A_Package_Body_Declaration |
                 A_Task_Body_Declaration |
                 An_Entry_Body_Declaration =>
                  Instrumentation.Process_Body_Declaration(Element);
               when others =>
                  null;
            end case;
         when An_Expression =>
            case Expression_Kind (Element) is
               when An_Integer_Literal |
                 A_Real_Literal |
                 A_String_Literal |
                 A_Character_Literal |
                 An_Enumeration_Literal =>
                  Element_Processing.Process_Literal (Element);
               when An_Identifier =>
                  Element_Processing.Process_Identifier (Element);
               when An_Operator_Symbol =>
                  Element_Processing.Process_Operator (Element);
               when A_Function_Call =>
                  if Is_Prefix_Call(Element) then
                     Element_Processing.Process_Complicated_Element(Element);
                  end if;
               when An_Indexed_Component =>
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Slice =>
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Selected_Component =>
                  --TODO: check is selected component is constant boundary value
                  --      process/push child instead?
                  Element_Processing.Process_Complicated_Element(Element);
               when An_Attribute_Reference =>
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Named_Array_Aggregate =>
                  Element_Processing.Process_Complicated_Element(Element);
               when An_And_Then_Short_Circuit | An_Or_Else_Short_Circuit =>
                  Element_Processing.Process_Complicated_Element(Element);
               when An_In_Membership_Test | A_Not_In_Membership_Test =>
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Null_Literal =>
                  --TODO: Foo > Null is never possible! This will be a false-positive
                  Element_Processing.Process_Literal (Element);
               when A_Parenthesized_Expression =>
                  null;
               when A_Type_Conversion =>
                  Element_Processing.Process_Complicated_Element(Element);
               when A_Qualified_Expression =>
                  Element_Processing.Process_Complicated_Element(Element);
               when others =>
                  Element_Processing.Process_Unknown_Element(Element);
                  Trace("framework.adb : Wierd stuff: ", Element);
            end case;
         when A_Path =>
            case Path_Kind (Element) is
               when An_If_Path .. An_Elsif_Path =>
                  declare
                     Expr : constant Asis.Expression := Asis.Statements.Condition_Expression(Element);
                  begin
                     Element_Processing.Process_Condition_Expression (Expr);
                     Statistics.Process_Condition_Expression (Expr);
                  end;
               when others =>
                  null;
            end case;
         when A_Statement =>
            case Statement_Kind (Element) is
               when A_Block_Statement =>
                  Control := Asis.Abandon_Children;
               when An_Assignment_Statement =>
                  --TODO
                  null;
               when others =>
                  null;
            end case;
         when others =>
            null;
      end case;
   end Pre_Procedure;

   --------------------
   -- Post_Procedure --
   --------------------

   procedure Post_Procedure (Element : in Asis.Element;
                             Control    : in out Asis.Traverse_Control;
                             State      : in out Boolean) is
      use Asis, Asis.Elements, Asis.Expressions;
      use Utilities;
   begin -- Post_Procedure
      case Element_Kind (Element) is
         when A_Declaration =>
            case Declaration_Kind (Element) is
               when A_Function_Body_Declaration |
                 A_Procedure_Body_Declaration |
                 A_Package_Body_Declaration |
                 A_Task_Body_Declaration |
                 An_Entry_Body_Declaration =>
                  Instrumentation.Generate_RORG_Mark_Calls;
                  Predicate_Loop_Variables.Reset_Used_Variables;
               when others =>
                  null;
            end case;
         when An_Expression =>
            case Expression_Kind (Element) is
               when An_Integer_Literal |
                 A_Real_Literal |
                 A_String_Literal |
                 A_Character_Literal |
                 An_Enumeration_Literal =>
                  null;
               when An_Identifier =>
                  null;
               when An_Operator_Symbol =>
                  null;
               when A_Function_Call =>
                  if Is_Prefix_Call(Element) then
                     Element_Processing.Post_Process_Complicated_Element;
                  else
                     Element_Processing.Post_Process_Function_Call(Element);
                  end if;
               when An_Indexed_Component =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Slice =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Selected_Component =>
                  Element_Processing.Post_Process_Complicated_Element;
               when An_Attribute_Reference =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Named_Array_Aggregate =>
                  Element_Processing.Post_Process_Complicated_Element;
               when An_And_Then_Short_Circuit | An_Or_Else_Short_Circuit =>
                  Element_Processing.Post_Process_Complicated_Element;
               when An_In_Membership_Test | A_Not_In_Membership_Test =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Null_Literal =>
                  null;
               when A_Parenthesized_Expression =>
                  Element_Processing.Post_Process_Parenthesis(Element);
               when A_Type_Conversion =>
                  Element_Processing.Post_Process_Complicated_Element;
               when A_Qualified_Expression =>
                  Element_Processing.Post_Process_Complicated_Element;
               when others =>
                  null;
            end case;
            Element_Processing.Post_Process_Expression(Element);
         when A_Statement =>
            case Statement_Kind (Element) is
               when An_If_Statement =>
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

   ------------------------------
   -- Process_Application_Unit --
   ------------------------------

   procedure Process_Application_Unit (Unit : in Asis.Compilation_Unit) is
      Control : Asis.Traverse_Control := Asis.Continue;
      State   : Boolean := True;
   begin
      Statistics.Process_Application_Unit(Adarorg_Options.Get_Unit_Name); --TODO: Change to actual compilation unit
      Instrumentation.Input_File_Name(Adarorg_Options.Path_And_Unit_Name);
      Instrumentation.Generate_With_Clause;

      Element_Processing.Process_Application_Unit(Adarorg_Options.Get_Unit_Name);

      New_Line;
      Put_Line ("Processing Unit: " &
                  Asis.Compilation_Units.Unit_Full_Name(Unit));
      New_Line;
      Traverse_Tree (Asis.Elements.Unit_Declaration(Unit), Control, State);
   end Process_Application_Unit;

   -----------------------------------
   -- Post_Process_Application_Unit --
   -----------------------------------

   procedure Post_Process_Application_Unit (Unit : in Asis.Compilation_Unit) is
   begin
      Instrumentation.Close_File;
      Statistics.Post_Process_Application_Unit;
   end Post_Process_Application_Unit;

   ------------------
   -- Process_Unit --
   ------------------

   procedure Process_Unit (Unit : in Asis.Compilation_Unit) is
   begin
      case Asis.Compilation_Units.Unit_Origin (Unit) is
         when Asis.An_Application_Unit =>
            Process_Application_Unit(Unit);
         when Asis.A_Predefined_Unit | Asis.Not_An_Origin | Asis.An_Implementation_Unit =>
            null;
      end case;
   end Process_Unit;

   -----------------------
   -- Post_Process_Unit --
   -----------------------

   procedure Post_Process_Unit (Unit : in Asis.Compilation_Unit) is
   begin
       case Asis.Compilation_Units.Unit_Origin (Unit) is
         when Asis.An_Application_Unit =>
            Post_Process_Application_Unit(Unit);
         when Asis.A_Predefined_Unit | Asis.Not_An_Origin | Asis.An_Implementation_Unit =>
            null;
      end case;
   end;

   procedure Process_Context is
      Subject_Unit               : Asis.Compilation_Unit;
   begin -- Process_Context

   --ASIS first tries to locate the source file 'Unit_Name' in the current
   --directory: '.'. If there is no such file in the currect directory. If
   --there is no such file in the current directory, ASIS continues the search
   --by looking into the directories listed in the value of ADA_INCLUDE_PATH
   --environment variable. If the source is found (say in the current
   --directory), ASIS creates the tree file by calling the compiler:
   -- $ gcc -c -gnatc -gnatt -I. -I- 'Unit_Name'.ads
   Subject_Unit := Asis.Compilation_Units.Compilation_Unit_Body
     ( Adarorg_Options.Get_Unit_Name, Framework.Adarorg_Context );

   if Asis.Compilation_Units.Is_Nil ( Subject_Unit ) then
      Put (CONTEXT_UNIT_NOT_FOUND_MESSAGE);
      Put_Line(Adarorg_Options.Get_Unit_Name);
      --raise CONTEXT_UNIT_NOT_FOUND;
   else
      Put (CONTEXT_UNIT_FOUND_MESSAGE);
      Put (Adarorg_Options.Get_Unit_Name);
      New_Line;
      Process_Unit(Subject_Unit);
      Post_Process_Unit(Subject_Unit);
      New_Line;
   end if;
   end Process_Context;

end Framework;
