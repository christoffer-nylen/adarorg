package body Rorg_Debug is
   procedure Set_Debug_Mode(Mode : Boolean := True) is
      use Context_Arguments;
      use Ada.Characters.Handling;

      Output : Wide_String(1..100);
      Output_Length : Natural;
   begin
      --TODO: context arg instead
      if Mode then
         Context_Arguments.Get_Unit_Name(Output, Output_Length);
         Ada.Wide_Text_IO.Create(Debug_File_Handle, Out_File, To_String(Output(1..Output_Length)));
         Ada.Wide_Text_IO.Set_Output(Debug_File_Handle);
      end if;
      Debug_Mode := Mode;
   end Set_Debug_Mode;

   procedure Set_Debug_Stream is
   begin
      Ada.Wide_Text_IO.Set_Output(Debug_File_Handle);
   end Set_Debug_Stream;

   procedure Restore_Debug_Stream is
   begin
      Ada.Wide_Text_IO.Set_Output(Standard_Output);
   end Restore_Debug_Stream;

   procedure Close_Debug_File is
   begin
      Ada.Wide_Text_IO.Close(Debug_File_Handle);
   end;
end Rorg_Debug;
