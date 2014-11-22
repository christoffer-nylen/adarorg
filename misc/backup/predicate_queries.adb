with
  Asis.Elements,
  Asis.Expressions;

with
  Utilities;

--RORG
with
  Rorg_Analysis_Constants;

package body Predicate_Queries is
   function Is_Regular_Clause(Element : Asis.Expression) return Boolean is
      use Asis, Asis.Elements, Asis.Expressions;
   begin
      return
        Expression_Kind(Element) = An_Identifier or
        Expression_Kind(Element) = An_Indexed_Component;
      --TODO: Add more stuff here
   end;

   function Is_Relational_Clause(Element : Asis.Expression) return Boolean is
      use Asis, Asis.Elements, Asis.Expressions;
      use Rorg_Analysis_Constants;
   begin
      if Expression_Kind (Element)=An_Operator_Symbol then
         return Operator_Kind(Element) in A_Relational_Operator;
      end if;

      --Not an operator
      return False;
   end;

   function Is_Same_Corresponding_Declaration(Arg1 : in Asis.Expression; Arg2 : in Asis.Expression) return Boolean is
      use Asis, Asis.Elements, Asis.Expressions;
      use Utilities;

      Tmp1, Tmp2 : Asis.Declaration;
   begin
      Tmp1 := Corresponding_Name_Declaration(Arg1);
      Tmp2 := Corresponding_Name_Declaration(Arg2);
      return Is_Equal(Tmp1, Tmp2);
   end;
end Predicate_Queries;
