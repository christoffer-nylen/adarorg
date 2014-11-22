with Rorg;
with
  Ada.Text_Io,
  Ada.Wide_Text_Io;

package body Expr_1 is

   Arr : array (1..4, 1..5) of Integer;

   function Hej return Boolean is
   begin
      return True;
   end;

   procedure Init is
      a : Boolean := True;

      -- RORG_Mark_0
      -- Location          : test/expr_1.adb:17:10:
      --
      -- Predicate         : A and B
      -- Clause A          : Arr(1, 2)=0
      -- Clause B          : Hej
      --
      -- Source Expression :
      --          Arr(1, 2)=0 and Hej
      function RORG_Mark_0 return Boolean is
         Clause_B_Temp : Boolean := Hej;
      begin
         if not (Arr(1, 2)=0) then
            if Clause_B_Temp then
               -- Test Case           : A=False, B=True => False
               -- Determining Clauses : A,               

               -- Clause A:
               if Arr(1, 2)=0 then
                  Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
               else
                  Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
               end if;

               return False;
            end if;
         else
            if Clause_B_Temp then
               -- Test Case           : A=True,  B=True => True
               -- Determining Clauses : A,               

               -- Clause A:
               Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;

               return True;
            end if;
         end if;
         return Arr(1, 2)=0 and Clause_B_Temp;
      end RORG_Mark_0;
   begin
      if RORG_Mark_0 then
         null;
      end if;
   end Init;

end Expr_1;
