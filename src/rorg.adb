with
  Ada.Calendar,
  Ada.Calendar.Formatting,
  Ada.Calendar.Time_Zones,
  Ada.Characters.Handling,
  Ada.Wide_Text_Io,
  Ada.Strings,
  Ada.Strings.Wide_Fixed,
  Ada.Streams.Stream_Io;

with -- AdaRORG
  Adarorg_Types;

use
  Ada.Wide_Text_Io;

package body Rorg is
   procedure Append_Result is
      use Ada.Characters.Handling;
      use Ada.Streams.Stream_Io;

      The_File : Ada.Streams.Stream_Io.File_Type;
      The_Stream : Ada.Streams.Stream_IO.Stream_Access;
   begin
      --coverage.dat
      begin
         Open(File => The_File, Mode => In_File,
              Name => To_String(Coverage_Data_File_Name));
         The_Stream := Stream(The_File);
         declare
            Old_Data : constant Coverage_Data'Class := Coverage_Data'Class'Input(The_Stream);
         begin
            --Stored_Data.Relops_Total := Old_Data.Relops_Total;
            --Stored_Data.Relops_Tested := Old_Data.Relops_Tested;
            --Stored_Data.Unit_Name_Length := Old_Data.Unit_Name_Length;
            --Stored_Data.Unit_Name(1..Old_Data.Unit_Name_Length) := Old_Data.Unit_Name(1..Old_Data.Unit_Name_Length);
            for Relop_Id in 1..MAX_RELOPS_SIZE loop
               for Conditional_Relop in Conditional_Relops loop
                  --Old_Data.Number_Of_Relops := 0;
                  Is_Covered(Relop_Id, Conditional_Relop) := Is_Covered(Relop_Id, Conditional_Relop) + Old_Data.Times_Covered(Relop_Id, Conditional_Relop);
               end loop;
            end loop;
         end;
         Close(The_File);
         Open(File => The_File, Mode => Out_File,
              Name => To_String(Coverage_Data_File_Name));
      exception
         when others =>
            Create(File => The_File, Name => To_String(Coverage_Data_File_Name));
      end;
      The_Stream := Stream(The_File);
      Coverage_Data'Class'Output(The_Stream, Stored_Data);
      Close(The_File);

      --my_file.coverage.dat
      --  begin
      --     Open(File => The_File, Mode => Out_File,
      --          Name => To_String(Stored_Data.Unit_Name(1..Stored_Data.Unit_Name_Length) &"."& Coverage_Data_File_Name));
      --  exception
      --     when others =>
      --        Create(File => The_File, Name => To_String(Stored_Data.Unit_Name(1..Stored_Data.Unit_Name_Length) & "." & Coverage_Data_File_Name));
      --  end;
      --  The_Stream := Stream(The_File);
      --  Coverage_Data'Class'Output(The_Stream, Stored_Data);
      --  Close(The_File);

   end Append_Result;
end Rorg;
