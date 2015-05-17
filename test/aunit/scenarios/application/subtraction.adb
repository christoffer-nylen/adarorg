with Rorg;
procedure Subtraction is
   A, B : Integer;

   -- RORG_Mark_0
   -- Location          : ./subtraction.adb:4:7:
   --
   -- Predicate         : A or B
   -- Clause A          : A = 0
   -- Clause B          : A /= B - 3
   --
   -- Source Expression :
   --       A = 0 or A /= B - 3
   function RORG_Mark_0 return Boolean is
   begin
      if not (A=0) then
         if not (A/=B - 3) then
            -- Test Case      : A=False, B=False => False
            -- Active Clauses : A,       B       

            -- Clause A:
            if A<0 then
               Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
            else
               Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
            end if;

            -- Clause B:
            Rorg.Is_Covered(2,'='):=Rorg.Is_Covered(2,'=')+1;

            return False;
         else
            -- Test Case      : A=False, B=True => True
            -- Active Clauses :          B       

            -- Clause B:
            if A<B - 3 then
               Rorg.Is_Covered(2,'<'):=Rorg.Is_Covered(2,'<')+1;
            else
               Rorg.Is_Covered(2,'>'):=Rorg.Is_Covered(2,'>')+1;
            end if;

            return True;
         end if;
      else
         if not (A/=B - 3) then
            -- Test Case      : A=True,  B=False => True
            -- Active Clauses : A,               

            -- Clause A:
            Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;

            return True;
         end if;
      end if;
      return A=0 or A/=B - 3;
   end RORG_Mark_0;

   -- RORG_Mark_1
   -- Location          : ./subtraction.adb:7:7:
   --
   -- Predicate         : A
   -- Clause A          : A = B
   --
   -- Source Expression :
   --       A = B
   function RORG_Mark_1 return Boolean is
   begin
      if not (A=B) then
         -- Test Case      : A=False => False
         -- Active Clauses : A       

         -- Clause A:
         if A<B then
            Rorg.Is_Covered(3,'<'):=Rorg.Is_Covered(3,'<')+1;
         else
            Rorg.Is_Covered(3,'>'):=Rorg.Is_Covered(3,'>')+1;
         end if;

         return False;
      else
         -- Test Case      : A=True => True
         -- Active Clauses : A       

         -- Clause A:
         Rorg.Is_Covered(3,'='):=Rorg.Is_Covered(3,'=')+1;

         return True;
      end if;
   end RORG_Mark_1;
begin
   if RORG_Mark_0 then
      null;
   end if;
   if RORG_Mark_1 then
      null;
   end if;
end Subtraction;
