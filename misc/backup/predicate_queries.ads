with
  Asis;
package Predicate_Queries is
   function Is_Regular_Clause(Element : Asis.Expression) return Boolean;
   function Is_Relational_Clause(Element : Asis.Expression) return Boolean;
   function Is_Same_Corresponding_Declaration(Arg1 : in Asis.Expression; Arg2 : in Asis.Expression) return Boolean;
end Predicate_Queries;
