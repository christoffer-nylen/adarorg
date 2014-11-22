----------------------------------------------------------------------
--  AdaRORG - Main program body                                     --
--                                                                  --
--  This  software is  distributed  in  the hope  that  it will  be --
--  useful,  but WITHOUT  ANY  WARRANTY; without  even the  implied --
--  warranty  of  MERCHANTABILITY   or  FITNESS  FOR  A  PARTICULAR --
--  PURPOSE.                                                        --
----------------------------------------------------------------------

-- ASIS
with
  Asis,
  Asis.Implementation,
  Asis.Ada_Environments;

-- AdaRORG
with
  Adarorg_Options,
  Framework;

procedure Adarorg is
begin
   Asis.Implementation.Initialize;

   Adarorg_Options.Initialize;

   --if Unit_Name_Length=0 then
   --   Put_Line ("Type the name of an Ada package specification");
   --   Get_Line (Unit_Name, Unit_Name_Length);
   --end if;

   --  Flags: -CA -FS -I<dir>
   --  FS: All the trees considered as making up a given Context are created
   --  "on the fly", whether or not the corresponding tree file already exists.
   --  Once created, a tree file then is reused as long as the Context remains open.
   --  CA: The Context comprises all the tree files in the tree search path.
   --  ASIS processes all the tree files located in the tree search path
   --  associated with the Context.
   --  I<dir>: Defines the directory in which to search for source files
   --  when compiling sources to create a tree "on the fly".
   Asis.Ada_Environments.Associate (Framework.Adarorg_Context, "My Context", "-CA -FS -I" & Adarorg_Options.Get_Path_Name &" "&Adarorg_Options.Command_Line_Options);
                                    --"-CA -FS -I/sw/adatest95/2.0/AdaTEST95/2.0/lib/adatest/ -I"&Framework.Path_Name(1..Framework.Path_Name_Length));
   Asis.Ada_Environments.Open (Framework.Adarorg_Context);

   Framework.Process_Context;

   Asis.Ada_Environments.Close (Framework.Adarorg_Context);
   Asis.Ada_Environments.Dissociate (Framework.Adarorg_Context);
   Asis.Implementation.Finalize;

--  exception

--     when Asis.Exceptions.ASIS_Inappropriate_Context
--       | Asis.Exceptions.ASIS_Inappropriate_Container
--       | Asis.Exceptions.ASIS_Inappropriate_Compilation_Unit
--       | Asis.Exceptions.ASIS_Inappropriate_Element
--       | Asis.Exceptions.ASIS_Inappropriate_Line
--       | Asis.Exceptions.ASIS_Inappropriate_Line_Number
--       | Asis.Exceptions.ASIS_Failed
--       =>

--        Put (Asis.Implementation.Diagnosis);
--        New_Line;
--        Put (STATUS_VALUE_MESSAGE);
--        Put (Asis.Errors.Error_Kinds'Wide_Image
--               (Asis.Implementation.Status));
--        New_Line;

--     when others =>
--        Put_Line ("Application failed because of non-ASIS reasons");

end Adarorg;
