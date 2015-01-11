-- Ada
with
  Ada.Characters.Handling,
  Ada.Wide_Text_Io,
  Ada.Streams.Stream_Io;

-- AdaRORG
with
  Adarorg_Types.Printing;
use
  Adarorg_Types.Printing;
--   Adarorg_Contants;
--use
--  Adarorg_Contants;

package body Filelist is

   The_File   : Ada.Streams.Stream_Io.File_Type;
   The_Stream : Ada.Streams.Stream_IO.Stream_Access;

   function Is_Equal(A, B : Instrumented_File) return Boolean is
   begin
      if A.CU_Name_Length=B.CU_Name_Length and A.File_Name_Length=B.File_Name_Length then
         return A.CU_Name(1..A.CU_Name_Length)=B.CU_Name(1..A.CU_Name_Length) and
           A.File_Name(1..A.File_Name_Length)=B.File_Name(1..A.File_Name_Length);
      end if;
      return False;
   end Is_Equal;

   procedure Open_Filelist is
      use Ada.Characters.Handling;
      use Ada.Streams.Stream_Io;
   begin
      -- Open filelist.dat
      Open(File => The_File,
           Mode => In_File,
           Name => Ada.Characters.Handling.To_String("filelist.dat"));
      The_Stream := Stream(The_File);
   end Open_Filelist;

   procedure Read_Instrumented_File(Data : out Instrumented_File) is
   begin
      Instrumented_File'Read(The_Stream, Data);
   end Read_Instrumented_File;

   function End_Of_Filelist return Boolean is
   begin
      return Ada.Streams.Stream_IO.End_Of_File(The_File);
   end End_Of_Filelist;

   procedure Close_Filelist is
   begin
      Ada.Streams.Stream_Io.Close(The_File);
   end Close_Filelist;

   procedure Update_Filelist(New_Data : Instrumented_File) is
      use Ada.Wide_Text_IO;
      use Ada.Characters.Handling;
      use Ada.Streams.Stream_Io;

      Tmp_File    : Ada.Streams.Stream_Io.File_Type;
      Tmp_Stream  : Ada.Streams.Stream_IO.Stream_Access;
      Tmp_Data    : Instrumented_File;
      Was_Written : Boolean := False;

   begin
      begin
         -- Open filelist.dat
         Open_Filelist;

         -- Create or Replace filelist.dat~
         Create(File => Tmp_File,
                Name => To_String("filelist.dat~"));
         Tmp_Stream := Stream(Tmp_File);

         -- Write filelist.dat + Updates to tmp-filelist
         while not End_Of_Filelist loop
            Read_Instrumented_File(Tmp_Data);
            if Is_Equal(Tmp_Data, New_Data) then
               Tmp_Data := New_Data;
               Was_Written := True;
            end if;
            Instrumented_File'Write(Tmp_Stream, Tmp_Data);
         end loop;
         if not Was_Written then
            Instrumented_File'Write(Tmp_Stream, New_Data);
         end if;
         Close_Filelist;
         Close(Tmp_File);

         Open(File => Tmp_File,
              Mode => In_File,
              Name => To_String("filelist.dat~"));
         Tmp_Stream := Stream(Tmp_File);
         Open(File => The_File,
              Mode => Out_File,
              Name => To_String("filelist.dat"));
         The_Stream := Stream(The_File);
         while not Ada.Streams.Stream_IO.End_Of_File(Tmp_File) loop
            Instrumented_File'Read(Tmp_Stream, Tmp_Data);
            Instrumented_File'Write(The_Stream, Tmp_Data);
         end loop;
         Close_Filelist;
         Close(Tmp_File);
      exception
         when others =>
            Create(File => The_File, Mode => Out_File,
                   Name => To_String("filelist.dat"));
            The_Stream := Stream(The_File);

            Instrumented_File'Write(The_Stream, New_Data);
            Close(The_File);
      end;
   end Update_Filelist;

   procedure Print_Filelist is
      use Ada.Wide_Text_Io;
      use Ada.Characters.Handling;
      use Ada.Streams.Stream_Io;

      Tmp_Data : Instrumented_File;
   begin
      Open_Filelist;

      while not End_Of_Filelist loop
         Read_Instrumented_File(Tmp_Data);
         Put(Tmp_Data.CU_Name(1..Tmp_Data.CU_Name_Length) & " " &
               Tmp_Data.File_Name(1..Tmp_Data.File_Name_Length) & " " );
         Put(Tmp_Data.Data);
         New_Line;
      end loop;
      Close_Filelist;
   exception
      when others =>
         null;
   end Print_Filelist;
end Filelist;
