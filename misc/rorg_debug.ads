with
  Ada.Characters.Handling,
  Ada.Wide_Text_Io,
  Context_Arguments;
use
  Ada.Wide_Text_Io;

package Rorg_Debug is
   Debug_File_Handle : File_Type;
   Debug_Mode : Boolean := False;
   procedure Set_Debug_Mode(Mode : Boolean := True);
   procedure Set_Debug_Stream;
   procedure Restore_Debug_Stream;
   procedure Close_Debug_File;
end Rorg_Debug;
