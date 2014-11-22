package body Predicate_Complicated_Clause is
   Depth : Natural := 0;
   procedure Enter_Complicated_Clause is
   begin
      Depth := Depth + 1;
      --Put_Line("+Depth:"& Natural'Image(Depth));
   end Enter_Complicated_Clause;
   procedure Leaving_Complicated_Clause is
   begin
      Depth := Depth - 1;
      --Put_Line("-Depth:"& Natural'Image(Depth));
   end Leaving_Complicated_Clause;
   function Is_Inside_A_Complicated_Clause return Boolean is
   begin
      return Depth>0;
   end Is_Inside_A_Complicated_Clause;
end Predicate_Complicated_Clause;
