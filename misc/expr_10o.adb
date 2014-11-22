with Rorg;
with Ada.Text_IO; use Ada.Text_IO;

procedure Expr_10 is

   A : Integer := 1;
   B : Integer := 2;

   procedure C is

      -- RORG_Mark_0
      -- Location          : test/expr_10.adb:10:10:
      --
      -- Predicate         : A
      -- Clause A          : A>B
      --
      -- Source Expression :
      --          A>B
      function RORG_Mark_0 return Boolean is
      begin
         if not (A>B) then
            -- Test Case           : A=False => False
            -- Determining Clauses : A       

            -- Clause A:
            if A>B then
               Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;
            else
               Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
            end if;

            return False;
         else
            -- Test Case           : A=True => True
            -- Determining Clauses : A       

            -- Clause A:
            Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;

            return True;
         end if;
         return A>B;
      end RORG_Mark_0;
   begin
      if RORG_Mark_0 then
         null;
      end if;
   end;

   G : Integer := 3;

   procedure D is
      function E return Boolean is

         -- RORG_Mark_1
         -- Location          : test/expr_10.adb:20:13:
         --
         -- Predicate         : A
         -- Clause A          : G=A
         --
         -- Source Expression :
         --             G=A
         function RORG_Mark_1 return Boolean is
         begin
            if not (G=A) then
               -- Test Case           : A=False => False
               -- Determining Clauses : A       

               -- Clause A:
               if G=A then
                  Rorg.Is_Covered(2,'<'):=Rorg.Is_Covered(2,'<')+1;
               else
                  Rorg.Is_Covered(2,'>'):=Rorg.Is_Covered(2,'>')+1;
               end if;

               return False;
            else
               -- Test Case           : A=True => True
               -- Determining Clauses : A       

               -- Clause A:
               Rorg.Is_Covered(2,'='):=Rorg.Is_Covered(2,'=')+1;

               return True;
            end if;
            return G=A;
         end RORG_Mark_1;
      begin
         if RORG_Mark_1 then
            return True;
         else
            return False;
         end if;
      end;

      -- RORG_Mark_2
      -- Location          : test/expr_10.adb:27:10:
      --
      -- Predicate         : A
      -- Clause A          : A=B
      --
      -- Source Expression :
      --          A=B
      function RORG_Mark_2 return Boolean is
      begin
         if not (A=B) then
            -- Test Case           : A=False => False
            -- Determining Clauses : A       

            -- Clause A:
            if A=B then
               Rorg.Is_Covered(3,'<'):=Rorg.Is_Covered(3,'<')+1;
            else
               Rorg.Is_Covered(3,'>'):=Rorg.Is_Covered(3,'>')+1;
            end if;

            return False;
         else
            -- Test Case           : A=True => True
            -- Determining Clauses : A       

            -- Clause A:
            Rorg.Is_Covered(3,'='):=Rorg.Is_Covered(3,'=')+1;

            return True;
         end if;
         return A=B;
      end RORG_Mark_2;
   begin
      if RORG_Mark_2 then
         null;
      end if;
   end;
begin
   declare
      F : Integer :=3;
      procedure G is
      begin
         if F=3 then
            null;
         end if;
      end;
   begin
      if F=4 then
         null;
      end if;
      declare
      begin
         if F=5 then
            null;
         end if;
      end;
      if F=6 then
         null;
      end if;
   end;
end Expr_10;
