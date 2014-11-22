with
  Hej;

with
  Ada.Text_Io,
  Ada.Wide_Text_Io;

package body Hejsan.Expr_1 is

   procedure Example is
      type Pressure_Type is (High, Low, Undefined);
      Pylon_Pressure : array (1..6) of Pressure_Type;
   begin
      for I in Pylon_Pressure'Range loop
         if Pylon_Pressure(I) = Low Then
            null;
         end if;
      end loop;
   end Example;

end Hejsan.Expr_1;
