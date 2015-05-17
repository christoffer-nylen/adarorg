with Rorg;
procedure Test_Integer is
   A, B : Integer;

   -- RORG_Mark_0
   -- Location          : ./test_integer.adb:4:7:
   --
   -- Predicate         : A
   -- Clause A          : A<B
   --
   -- Source Expression :
   --       A<B
   function RORG_Mark_0 return Boolean is
   begin
      if not (A<B) then
         -- Test Case      : A=False => False
         -- Active Clauses : A       

         -- Clause A:
         if A=B then
            Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;
         else
            Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
         end if;

         return False;
      else
         -- Test Case      : A=True => True
         -- Active Clauses : A       

         -- Clause A:
         Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;

         return True;
      end if;
   end RORG_Mark_0;
begin
   if RORG_Mark_0 then
      null;
   end if;
end Test_Integer;
