with -- Ada
  Ada.Calendar,
  Ada.Calendar.Formatting,
  Ada.Calendar.Time_Zones,
  Ada.Characters.Handling,
  Ada.Strings,
  Ada.Strings.Wide_Fixed,
  Ada.Wide_Text_IO;
use
  Ada.Wide_Text_IO;

with -- AdaRORG
  Adarorg_Types,
  Adarorg_Constants,
  Filelist;
use
  Adarorg_Constants;

package body Rorg.Report is
   procedure Report_Analysis(Result_File : String) is
      use Ada.Calendar, Ada.Calendar.Formatting, Ada.Calendar.Time_Zones;
      use Ada.Characters.Handling;
      use Ada.Strings, Ada.Strings.Wide_Fixed;
      use Filelist;

      File_Handle : File_Type;
      Passed      : Natural;

      Now : constant Time := Clock;

      Has_Passed : Boolean;

      Instrumentation_Data : Instrumented_File;
      Offset_First         : Natural := 1;
      Offset_Last          : Natural := 0;

      procedure Put_Header is
      begin
         Put_Line("================================================================================");
         Put_Line("        AdaRORG 2013");
         Put_Line("        Version 0.1r1");
         Put_Line("--------------------------------------------------------------------------------");
         Put_Line("        Test Results for " & Instrumentation_Data.File_Name(1..Instrumentation_Data.File_Name_Length)); --TODO: loopa över file_list
         Put_Line("        Test run on " & To_Wide_String(Image(Date => Now, Time_Zone => 60)(1..16))); --TODO: Fix
      end Put_Header;

      Relops_Tested_Count : Natural := 0;
      Relops_Total_Count : Natural := 0;

   begin
      Append_Result;
      Ada.Wide_Text_IO.Create(File_Handle, Out_File, Result_File);
      Ada.Wide_Text_IO.Set_Output(File_Handle);

      Filelist.Open_Filelist;

      while not End_Of_Filelist loop
         Read_Instrumented_File(Instrumentation_Data);
         Relops_Tested_Count := Adarorg_Types.Sum(Instrumentation_Data.Data.Relops_Tested);
         Relops_Total_Count  := Adarorg_Types.Sum(Instrumentation_Data.Data.Relops_Total);

         Passed := 0;
         Offset_First := Offset_Last + 1;
         Offset_Last  := Offset_Last + Relops_Tested_Count;

         Put_Header;
         Put_Line("--------------------------------------------------------------------------------");

         for Relop_Id in Offset_First..Offset_Last loop
            Has_Passed := True;
            for Conditional_Relop in Conditional_Relops loop
               Put(Integer'Wide_Image(Relop_Id) & ": " & Conditional_Relops'Wide_Image(Conditional_Relop) & " ");
               if Is_Covered(Relop_Id, Conditional_Relop)>0 then
                  Put_Line("OK");
               else
                  Has_Passed := False;
                  Put_Line("FAILED");
               end if;
            end loop;
            Put_Line("--------------------------------------------------------------------------------");
            if Has_Passed then
               Passed := Passed +1;
            end if;
         end loop;

         Put_Header;
         New_Line;
         Put_Line("        Checks");
         Put_Line("            Passed                  : " & Natural'Wide_Image(Passed));
         Put_Line("            Failed                  : " & Natural'Wide_Image(Relops_Tested_Count-Passed));
         Put_Line("            Ignored                 : " & Natural'Wide_Image(Relops_Total_Count-Relops_Tested_Count));
         Put_Line("--------------------------------------------------------------------------------");
         Put_Line("                    Overall Rorg Coverage: " & Natural'Wide_Image(Passed) & "/" & Trim(Natural'Wide_Image(Relops_Tested_Count), Both));
         Put_Line("================================================================================");

      end loop;

      Filelist.Close_Filelist;
      Ada.Wide_Text_IO.Close(File_Handle);
      Ada.Wide_Text_IO.Set_Output(Standard_Output);
   end;
end Rorg.Report;
