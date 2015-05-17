with
  Asis.Text,
  Ada.Wide_Text_IO,
  Ada.Strings,
  Ada.Strings.Wide_Fixed;
use
  Ada.Wide_Text_IO;
package body Asis_Debug is

   ------------------
   -- Source_Print --
   ------------------

   procedure Source_Print (Elem : Asis.Element) is
      use Ada.Strings, Ada.Strings.Wide_Fixed;
      use Asis.Text;
   begin
      Put_Line(Trim(Element_Image(Elem), Both));
   end Source_Print;

end Asis_Debug;
