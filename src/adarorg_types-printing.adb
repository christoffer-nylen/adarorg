-- Ada
with
  Ada.Wide_Text_Io;

-- AdaRORG
with
  Adarorg_Constants;

package body Adarorg_Types.Printing is
   procedure Put(Data : Static_Data) is
      use Ada.Wide_Text_Io;
      use Adarorg_Constants;

      procedure Put_Instrumentation_Details is
      begin
         Put_Line(INSTRUMENTATION_DETAILS);
         Put_Line(INSTRUMENTATION_DETAILS_LINE);
         --TODO:
         New_Line;
      end Put_Instrumentation_Details;

   begin
      Put_Line(NUMBER_OF_PREDICATES);
      Put_Line(NUMBER_OF_PREDICATES_LINE);
      Put_Line(TOTAL_ONE        & Integer'Wide_Image(Data.Predicates_Total));
      Put_Line(INSTRUMENTED_ONE & Integer'Wide_Image(Data.Predicates_Tested));
      New_Line;

      Put_Line(NUMBER_OF_RELOPS);
      Put_Line(NUMBER_OF_RELOPS_LINE);
      Put_Line(TOTAL_ONE        & Integer'Wide_Image(Data.Relops_Total));
      Put_Line(INSTRUMENTED_ONE & Integer'Wide_Image(Data.Relops_Tested));
      New_Line;

      if Data.Relops_Tested > 0 then
         Put_Instrumentation_Details;
      end if;

   end Put;
end Adarorg_Types.Printing;
