----------------------------------------------------------------------
--  Instrumentation - Package instrumentation                       --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

--ASIS
with
  Asis;

--RORG
with
  Adarorg_Constants,
  Binary_Tree,
  Determining_Test_Set;
use
  Adarorg_Constants;
package Instrumentation is
   type Coverage_Information is
      record
         Clause : Asis.Element;
      end record;

   procedure Input_File_Name(Input : Wide_String);
   procedure Close_File;

   procedure Push_Insertion_Point(Line : Text_Line_Number; Column : Text_Column_Number);
   procedure Push_Predicate_Expression(Expr : Asis.Expression);

   package Coverage_Tree is new Binary_Tree (Coverage_Information);

   procedure Clear;

   procedure Generate_With_Clause;

   procedure Generate_RORG_Mark_Function_Declaration(Predicate_Pairs : Determining_Test_Set.Test_Pairs.Stack);

   procedure Generate_RORG_Mark_Calls;

   procedure Add_Test_Coverage(Pair : Determining_Test_Set.Test_Pair);

   -- Process
   procedure Process_Body_Declaration (Decl : in Asis.Declaration);

end Instrumentation;
