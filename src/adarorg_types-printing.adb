-- Ada
with
  Ada.Wide_Text_Io;

-- AdaRORG
with
  Adarorg_Constants,
  Adarorg_Types;

package body Adarorg_Types.Printing is
   procedure Put(Data : Static_Data) is
      use Ada.Wide_Text_Io;
      use Adarorg_Constants;

      Relops_Total_Count  : Natural := Sum(Data.Relops_Total);
      Relops_Tested_Count : Natural := Sum(Data.Relops_Tested);

      procedure Put_Instrumentation_Details is
         use Adarorg_Types;
         Relops_Of_Kind_Tested : Natural;
      begin
         Put_Line(INSTRUMENTATION_DETAILS);
         Put_Line(INSTRUMENTATION_DETAILS_LINE);

         for I in Ada_Type_Kind'Range loop
            Relops_Of_Kind_Tested := Sum(I, Data.Relops_Tested);
            if Relops_Of_Kind_Tested > 0 then
               New_Line;
               Put_Line(INDENT_TWO & Ada_Type_Kind'Wide_Image(I));
               Put(INDENT_TWO);
               for R in Ada_Type_Kind'Wide_Image(I)'Range loop
                  Put("-");
               end loop;
               New_Line;
               for J in Ada_Relational_Operator'Range loop
                  Put(INDENT_THREE);
                  Put(RELATIONAL_OP_STR(J) & RELOP_SPACE);
                  Put(Natural'Wide_Image(Data.Relops_Tested(I, J)));
                  New_Line;
               end loop;
               Put_Line(TOTAL_TWO & Integer'Wide_Image(Relops_Of_Kind_Tested));
            end if;
         end loop;
      end Put_Instrumentation_Details;

   begin
      Put_Line(NUMBER_OF_PREDICATES);
      Put_Line(NUMBER_OF_PREDICATES_LINE);
      Put_Line(TOTAL_ONE        & Integer'Wide_Image(Data.Predicates_Total));
      Put_Line(INSTRUMENTED_ONE & Integer'Wide_Image(Data.Predicates_Tested));
      New_Line;

      Put_Line(NUMBER_OF_RELOPS);
      Put_Line(NUMBER_OF_RELOPS_LINE);
      Put_Line(TOTAL_ONE        & Integer'Wide_Image(Relops_Total_Count));
      Put_Line(INSTRUMENTED_ONE & Integer'Wide_Image(Relops_Tested_Count));
      New_Line;

      if Relops_Tested_Count > 0 then
         Put_Instrumentation_Details;
      end if;

   end Put;
end Adarorg_Types.Printing;
