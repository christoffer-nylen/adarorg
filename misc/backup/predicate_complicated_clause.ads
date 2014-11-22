--This package is needed to save loop/index variables without pushing them
--on to the predicate tree for truth table generation.
package Predicate_Complicated_Clause is
   procedure Enter_Complicated_Clause;
   procedure Leaving_Complicated_Clause;
   function Is_Inside_A_Complicated_Clause return Boolean;
end Predicate_Complicated_Clause;
