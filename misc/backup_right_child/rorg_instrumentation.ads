package rorg_instrumentation is
   cond_expr[num]

   type Conditional_Expression is
      record
         id : Integer;
         line_number : Integer;
         --abstract_expr : Wide_String;

         Identifier : Asis.Defining_Name;
         Kind       : Subrules;
         Reference  : Reference_Kind;
      end record;
