with
  Asis;

package Element_Processing is

   procedure Process_Application_Unit (Unit_Name : Wide_String);

   procedure Process_Identifier (Ident : in Asis.Expression);

   procedure Process_Literal (Lit : in Asis.Expression);

   procedure Process_Operator (Oper : in Asis.Expression);

   procedure Process_Complicated_Element (Expr : in Asis.Expression);

   procedure Process_Unknown_Element (Expr : in Asis.Expression);

   procedure Process_Condition_Expression (Expr : in Asis.Expression);

   procedure Post_Process_Complicated_Element;

   procedure Post_Process_Expression(Expr : in Asis.Expression);

   procedure Post_Process_Function_Call (Call : in Asis.Expression);

   procedure Post_Process_For_Loop_Statement;

   procedure Post_Process_Parenthesis (Parenthesis : in Asis.Expression);

end Element_Processing;
