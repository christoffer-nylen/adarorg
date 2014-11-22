with
  Ada.Wide_Text_Io;
use
  Ada.Wide_Text_Io;

package body Rorg is
   procedure Report_Analysis is
   begin
      for Relop_Id in Is_Covered'Range(1) loop
         for Conditional_Relop in Conditional_Relops loop
            Put(Integer'Wide_Image(Relop_Id) & ": " & Conditional_Relops'Wide_Image(Conditional_Relop));
            if Is_Covered(Relop_Id, Conditional_Relop)>0 then
               Put_Line(" is ok!");
            else
               Put_Line(" failed!");
            end if;
         end loop;
      end loop;
   end;
end Rorg;
