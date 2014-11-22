with Rorg;
with
  Hej;

with
  Ada.Text_Io,
  Ada.Wide_Text_Io;

package body Expr_1 is

   procedure Example is
      type Pressure_Type is (High, Low, Undefined);
      Pylon_Pressure : array (1..6) of Pressure_Type;

      -- RORG_Mark_0
      -- Location          : original/expr_1.adb:15:13:
      --
      -- Predicate         : A
      -- Clause A          : Pylon_Pressure(I) = Low
      --
      -- Source Expression :
      --             Pylon_Pressure(I) = Low
      function RORG_Mark_0(I : Integer) return Boolean is
      begin
         if not (Pylon_Pressure(I)=Low) then
            -- Test Case      : A=False => False
            -- Active Clauses : A       

            -- Clause A:
            if Pylon_Pressure(I)<Low then
               Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
            else
               Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
            end if;

            return False;
         else
            -- Test Case      : A=True => True
            -- Active Clauses : A       

            -- Clause A:
            Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;

            return True;
         end if;
      end RORG_Mark_0;
   begin
      for I in Pylon_Pressure'Range loop
         if RORG_Mark_0(I) Then
            null;
         end if;
      end loop;
   end Example;

end Expr_1;
