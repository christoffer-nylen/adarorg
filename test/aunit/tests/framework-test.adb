--
--  Copyright (C) 2008, AdaCore
--
with
  AUnit.Assertions;
use
  AUnit.Assertions;

-- ASIS
with
  Asis,
  Asis.Implementation,
  Asis.Ada_Environments;

-- AdaRORG
with
  Adarorg_Constants,
  Adarorg_Options;

package body Framework.Test is

   procedure Set_Up (T : in out Test) is
   begin
      --T.I1 := 5;
      --T.I2 := 3;
      Asis.Implementation.Initialize;
   end Set_Up;

   procedure Tear_Down (T : in out Test) is
   begin
      Asis.Ada_Environments.Close (Framework.Adarorg_Context);
      Asis.Ada_Environments.Dissociate (Framework.Adarorg_Context);
      Asis.Implementation.Finalize;
   end Tear_Down;

   procedure Test_No_Such_File (T : in out Test) is
   begin
      --Assert (T.I1 + T.I2 = 8, "Incorrect result after addition");
      Adarorg_Options.Initialize("bad_file");
      Asis.Ada_Environments.Associate (Framework.Adarorg_Context, "My Context", "-CA -FS -I" &
                                         Adarorg_Options.Get_Path_Name);
      Asis.Ada_Environments.Open (Framework.Adarorg_Context);
      Framework.Process_Context;
   end Test_No_Such_File;

   procedure Test_Subtraction (T : in out Test) is
   begin
      Adarorg_Options.Initialize("expr_1.adb");
      Asis.Ada_Environments.Associate (Framework.Adarorg_Context, "My Context", "-CA -FS -I" &
                                         Adarorg_Options.Get_Path_Name);
      Asis.Ada_Environments.Open (Framework.Adarorg_Context);
      Framework.Process_Context;
   end Test_Subtraction;

end Framework.Test;
