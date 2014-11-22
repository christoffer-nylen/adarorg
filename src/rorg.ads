package Rorg is
   type File_ID_Type is (File_ID_1, -- test/expr_1.adb
                         File_ID_2, -- test/expr_2.adb
                         File_ID_3);-- test/expr_3.adb

   MAX_RELOPS_SIZE : constant Natural := 1000;

   Coverage_Data_File_Name : Wide_String := "coverage.dat";

   type Conditional_Relops is ('=','<','>');

   type Coverage_Array is array (1..MAX_RELOPS_SIZE, Conditional_Relops'Range) of Integer;

   type Coverage_Data is tagged
      record
         --Unit_Name : Wide_String(1..100);
         --Unit_Name_Length : Natural := 0;
         --Relops_Total : Natural := 0;
         --Relops_Tested : Natural := 0;
         Times_Covered : Coverage_Array := (others => (others => 0));
      end record;

   Stored_Data : Coverage_Data;
   Is_Covered : Coverage_Array Renames Stored_Data.Times_Covered;

   procedure Append_Result;

end Rorg;
