----------------------------------------------------------------------
--  AdaRORG_Options - Package specification                         --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

package Adarorg_Options is
   procedure Initialize(Str : in String := ".");
   function Get_Path_Name return Wide_String;
   function Get_Unit_Name return Wide_String;
   function Path_And_Unit_Name return Wide_String;
   function Path_Exists return Boolean;
end Adarorg_Options;
