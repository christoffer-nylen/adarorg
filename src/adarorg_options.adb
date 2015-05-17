----------------------------------------------------------------------
--  AdaRORG_Options - Package body                                  --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

-- Ada
with
  Ada.Characters.Handling,
  Ada.Strings.Wide_Unbounded,
  Ada.Wide_Text_Io;
use
  Ada.Wide_Text_Io;

-- Gnat
with
  Gnat.Regpat;

-- AdaRORG
with
  Adarorg_Constants;
use
  Adarorg_Constants;

package body Adarorg_Options is

   Unit_Name : Wide_String(1..100);
   Path_Name : Wide_String(1..100);
   Unit_Name_Length : Natural := 0;
   Path_Name_Length : Natural := 0;

   package Pat renames Gnat.Regpat;

   procedure Search_For_Pattern(Compiled_Expression: Pat.Pattern_Matcher;
                                Search_In: String;
                                First, Last: out Positive;
                                Found: out Boolean) is
      Result: Pat.Match_Array (0 .. 1);
   begin
      Pat.Match(Compiled_Expression, Search_In, Result);
      Found := not Pat."="(Result(1), Pat.No_Match);
      if Found then
         First := Result(1).First;
         Last := Result(1).Last;
      end if;
   end Search_For_Pattern;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize(Str : in String := ".") is
      use Ada.Characters.Handling;
   begin
      declare
         Current_First : Positive := Str'First;
         First, Last : Positive;
         Found : Boolean;
      begin
         Search_For_Pattern(Pat.Compile(PATH_PATTERN),
                            Str(Current_First .. Str'Last),
                            First, Last, Found);
         Current_First := Last+1;

         if Found then
            Path_Name_Length := Last-First+1;
            Path_Name(1..Path_Name_Length) := To_Wide_String(Str(First .. Last));
         else
            Path_Name(1) := '.';
            Path_Name(2) := '/';
            Path_Name_Length := 2;
            Current_First := Str'First;
         end if;

         Search_For_Pattern(Pat.Compile(UNIT_PATTERN),
                            Str(Current_First .. Str'Last),
                            First, Last, Found);

         if Found then
            Unit_Name_Length := Last-First+1;
            Unit_Name(1..Unit_Name_Length) := To_Wide_String(Str(First .. Last));
         else
            Unit_Name_Length := 0;
         end if;
      end;
   end Initialize;

   -------------------
   -- Get_Path_Name --
   -------------------

   function Get_Path_Name return Wide_String is
   begin
      return Path_Name(1..Path_Name_Length);
   end Get_Path_Name;

   -------------------
   -- Get_Unit_Name --
   -------------------

   function Get_Unit_Name return Wide_String is
   begin
      return Unit_Name(1..Unit_Name_Length);
   end Get_Unit_Name;

   ------------------------
   -- Path_And_Unit_Name --
   ------------------------

   function Path_And_Unit_Name return Wide_String is
   begin
      return Path_Name(1..Path_Name_Length) & Unit_Name(1..Unit_Name_Length);
   end Path_And_Unit_Name;

   -----------------
   -- Path_Exists --
   -----------------

   function Path_Exists return Boolean is
   begin
      return Path_Name_Length>1;
   end Path_Exists;

end Adarorg_Options;
