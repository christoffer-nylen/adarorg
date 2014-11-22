with Rorg;
package body Expr_2 is
   procedure Init is
      type week is(mon, tue, wed);
      A : week := tue;
      B : Week := Mon;
      C : Integer := 1;
      D : Integer := 2;
      E : Integer := 2;

      -- RORG_Mark_0
      -- Location          : test/expr_2.adb:10:10:
      --
      -- Predicate         : not (A)
      -- Clause A          : A=Week'First
      --
      -- Source Expression :
      --          not (A=Week'First)
      function RORG_Mark_0 return Boolean is
      begin
         if not (A=Week'First) then
            -- Test Case           : A=False => True
            -- Determining Clauses : A       

            -- Clause A:
            if A<Week'First then
               Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
            else
               Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
            end if;
         else
            -- Test Case           : A=True => False
            -- Determining Clauses : A       

            -- Clause A:
            Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;
         end if;
         return True;
      end RORG_Mark_0;
   begin
      if (RORG_Mark_0 and (not (A=Week'First))) then
         null;
      end if;

   end Init;
end Expr_2;
