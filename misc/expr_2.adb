with Rorg;
package body Expr_2 is
   procedure Init is
      type week is(mon, tue, wed);
      A : week := tue;
      B : Week := Mon;
      C : Integer := 1;
      D : Integer := 2;
      E : Integer := 2;

      function Wee(Hej : Boolean) return Boolean is
      begin
         return Hej;
      end Wee;

      -- RORG_Mark_0
      -- Location          : test/expr_2.adb:15:10:
      --
      -- Predicate         : not A and B
      -- Clause A          : Wee(True)
      -- Clause B          : A = Week'First
      --
      -- Source Expression :
      --          not Wee(True) and A = Week'First
      function RORG_Mark_0 return Boolean is
         Clause_A_Temp : Boolean := Wee(True);
      begin
         if not (Clause_A_Temp) then
            if not (A=Week'First) then
               -- Test Case           : A=False, B=False => False
               -- Determining Clauses :          B       

               -- Clause B:
               if A<Week'First then
                  Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
               else
                  Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
               end if;

               return False;
            else
               -- Test Case           : A=False, B=True => True
               -- Determining Clauses :          B       

               -- Clause B:
               Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;

               return True;
            end if;
         end if;
         return not Clause_A_Temp and A=Week'First;
      end RORG_Mark_0;
   begin
      if RORG_Mark_0 then
         null;
      end if;

   end Init;
end Expr_2;
