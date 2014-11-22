with Ada.Wide_Text_Io;

package body Adarorg_Types.Printing is
   procedure Put(Data : Static_Data) is
      use Ada.Wide_Text_Io;
   begin
      Put(Integer'Wide_Image(Data.Relops_Total) & " ");
      Put(Integer'Wide_Image(Data.Relops_Tested) & " ");
      Put(Integer'Wide_Image(Data.Predicates_Total) & " ");
      Put(Integer'Wide_Image(Data.Predicates_Tested));
   end Put;
end Adarorg_Types.Printing;
