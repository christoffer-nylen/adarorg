--
--  Copyright (C) 2008, AdaCore
--
with AUnit;
with AUnit.Test_Fixtures;

package Framework.Test is

   type Test is new AUnit.Test_Fixtures.Test_Fixture with record
      --I1 : Int;
      --I2 : Int;
      Wee : Integer;
   end record;

   procedure Set_Up (T : in out Test);
   procedure Tear_Down (T : in out Test);

   procedure Test_No_Such_File (T : in out Test);
   procedure Test_Subtraction (T : in out Test);

end Framework.Test;
