with
  Asis;

package Element_Processing is

   procedure Process_Compilation_Unit (Unit_Name : Wide_String);

   procedure Process_Body_Declaration (Decl : in Asis.Declaration);

   procedure Process_Identifier (Ident : in Asis.Expression);

   procedure Process_Integer_Literal (Int : in Asis.Expression);

   procedure Process_Real_Literal (Real : in Asis.Expression);

   procedure Process_String_Literal (Str : in Asis.Expression);

   procedure Process_Character_Literal (Char : in Asis.Expression);

   procedure Process_Enumeration_Literal (Enum : in Asis.Expression);

   procedure Process_Operator (Oper : in Asis.Expression);

   procedure Process_Function_Call; --(Expr : in Asis.Expression);

   procedure Process_Complicated_Element (Expr : in Asis.Expression);

   procedure Process_Parenthesis (Parenthesis : in Asis.Expression);

   procedure Process_Path (Path : in Asis.Path);

   procedure Process_Block_Statement (Stmt : in Asis.Statement);

   procedure Process_For_Loop_Statement (Stmt : in Asis.Statement);

   procedure Post_Process_Compilation_Unit;

   procedure Post_Process_Complicated_Element;

   procedure Post_Process_Body_Declaration;

   procedure Post_Process_Expression(Expr : in Asis.Expression);

   procedure Post_Process_Function_Call (Call : in Asis.Expression);

   procedure Post_Process_For_Loop_Statement;

   procedure Post_Process_Parenthesis (Parenthesis : in Asis.Expression);

end Element_Processing;
