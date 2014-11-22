package Context_Arguments is
   procedure Initialize;
   procedure Get_Path_Name(Path : out Wide_String; Length : out Natural);
   procedure Get_Unit_Name(Unit : out Wide_String; Length : out Natural);
   function Path_Exists return Boolean;
end Context_Arguments;
