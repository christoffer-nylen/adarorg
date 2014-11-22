with Rorg;
procedure Expr_8 is
   Arr : array (1..4) of Integer := (others => 0);

   -- RORG_Mark_0
   -- Location          : test/expr_8.adb:6:13:
   --
   -- Predicate         : A and B
   -- Clause A          : Arr(I)=0
   -- Clause B          : Arr(R)<5
   --
   -- Source Expression :
   --             Arr(I)=0 and Arr(R)<5
   function RORG_Mark_0(I : Integer; R : Integer) return Boolean is
   begin
      if not (Arr(I)=0) then
         if Arr(R)<5 then
            -- Test Case           : A=False, B=True => False
            -- Determining Clauses : A,               

            -- Clause A:
            if Arr(I)=0 then
               Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
            else
               Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
            end if;

            return False;
         end if;
      else
         if not (Arr(R)<5) then
            -- Test Case           : A=True,  B=False => False
            -- Determining Clauses :          B       

            -- Clause B:
            if Arr(R)<5 then
               Rorg.Is_Covered(2,'='):=Rorg.Is_Covered(2,'=')+1;
            else
               Rorg.Is_Covered(2,'>'):=Rorg.Is_Covered(2,'>')+1;
            end if;

            return False;
         else
            -- Test Case           : A=True,  B=True => True
            -- Determining Clauses : A,       B       

            -- Clause A:
            Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;

            -- Clause B:
            Rorg.Is_Covered(2,'<'):=Rorg.Is_Covered(2,'<')+1;

            return True;
         end if;
      end if;
      return Arr(I)=0 and Arr(R)<5;
   end RORG_Mark_0;

   -- RORG_Mark_1
   -- Location          : test/expr_8.adb:8:16:
   --
   -- Predicate         : (A)
   -- Clause A          : Arr(R)=1
   --
   -- Source Expression :
   --                (Arr(R)=1)
   function RORG_Mark_1(R : Integer) return Boolean is
   begin
      if not (Arr(R)=1) then
         -- Test Case           : A=False => False
         -- Determining Clauses : A       

         -- Clause A:
         if Arr(R)=1 then
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
      return (Arr(R)=1);
   end RORG_Mark_1;
begin
   for R in Arr'Range loop
      for I in Arr'Range loop
         if RORG_Mark_0(I, R) then
            null;
         elsif RORG_Mark_1(R) then
            null;
         end if;
      end loop;
   end loop;
end Expr_8;
