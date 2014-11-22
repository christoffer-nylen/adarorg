with
  Adarorg_Types;

package Filelist is
   type Instrumented_File is
      record
         CU_Name : Wide_String(1..100);
         CU_Name_Length : Natural;
         File_Name : Wide_String(1..100);
         File_Name_Length : Natural;
         Data : Adarorg_Types.Static_Data;
      end record;

   procedure Open_Filelist;
   procedure Read_Instrumented_File(Data : out Instrumented_File);
   function End_Of_Filelist return Boolean;
   procedure Close_Filelist;
   procedure Update_Filelist(New_Data : Instrumented_File);
   procedure Print_Filelist;

end Filelist;
