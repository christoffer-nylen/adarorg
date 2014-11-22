with
  Ada.Wide_Text_Io,
  Ada.Characters.Handling,
  Ada.Command_Line,
  Gnat.Regpat;
use
  Ada.Command_Line,
  Ada.Wide_Text_Io;

with
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;

package body Context_Arguments is

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

   procedure Initialize is
      use Ada.Command_Line, Ada.Characters.Handling;
      File_Not_Specified : exception;
   begin
      if Argument_Count=0 then
         --Path_Name(1) := '.';
         --Path_Name_Length := 1;
         Put_Line ("Please specify ada file");
         raise File_Not_Specified;
         return;
      end if;

      declare
         Str : String := Argument(1);
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
            Path_Name_Length := 1;
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

   procedure Get_Path_Name (Path : out Wide_String; Length : out Natural) is
   begin
      Path(Path'First..Path_Name_Length) := Path_Name(1..Path_Name_Length);
      Length := Path_Name_Length;
   end Get_Path_Name;

   procedure Get_Unit_Name (Unit : out Wide_String; Length : out Natural) is
   begin
      Unit(Unit'First..Unit_Name_Length) := Unit_Name(1..Unit_Name_Length);
      Length := Unit_Name_Length;
   end Get_Unit_Name;

   function Path_Exists return Boolean is
   begin
      return Path_Name_Length>1;
   end Path_Exists;

end Context_Arguments;
