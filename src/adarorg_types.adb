package body Adarorg_Types is
   function Sum(Elem : Relop_Counter) return Natural is
      Relops : Natural := 0;
   begin
      for I in Elem'Range loop
         for J in Ada_Relational_Operator'Range loop
            Relops := Relops + Elem(I, J);
         end loop;
      end loop;
      return Relops;
   end Sum;

   function Sum(I : Ada_Type_Kind; Elem : Relop_Counter) return Natural is
      Relops : Natural := 0;
   begin
      for J in Ada_Relational_Operator'Range loop
         Relops := Relops + Elem(I, J);
      end loop;
      return Relops;
   end Sum;
end Adarorg_Types;
