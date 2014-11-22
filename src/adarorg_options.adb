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
  Ada.Command_Line,
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

   Extra_Options : Ada.Strings.Wide_Unbounded.Unbounded_Wide_String;

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

   procedure Initialize is
      use Ada.Command_Line, Ada.Characters.Handling;
      File_Not_Specified : exception;
   begin
      if Argument_Count=0 then
         Put_Line ("Please specify ada file");
         raise File_Not_Specified;
         return;
      end if;

      declare
         Str : constant String := Argument(1);
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

      for Arg in 2 .. Argument_Count loop
         Ada.Strings.Wide_Unbounded.Append(Extra_Options, ' ' & To_Wide_String(Argument(Arg)));
      end loop;
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

   ---------------------------
   -- Command_Line_Commands --
   ---------------------------

   function Command_Line_Options return Wide_String is
      use Ada.Strings.Wide_Unbounded;
   begin
      return To_Wide_String(Extra_Options);
   end Command_Line_Options;

   -----------------
   -- Path_Exists --
   -----------------

   function Path_Exists return Boolean is
   begin
      return Path_Name_Length>1;
   end Path_Exists;

end Adarorg_Options;
