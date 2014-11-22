with Rorg;
package body Sut is
   function XYBC(X : Integer;

      -- RORG_Mark_0
      -- Location          : original/sut.adb:7:10:
      --
      -- Predicate         : (A or B) and C
      -- Clause A          : X>Y
      -- Clause B          : B
      -- Clause C          : C
      --
      -- Exceptions        :
      -- Clause B          : 'B' is a non-relational clause (will not be RORG tested)
      -- Clause C          : 'C' is a non-relational clause (will not be RORG tested)
      --
      -- Source Expression :
      --          (X>Y or B) and C
      function RORG_Mark_0 return Boolean is
      begin
         if not (X>Y) then
            if not (B) then
               if C then
                  -- Test Case      : A=False, B=False, C=True => False
                  -- Active Clauses : A,                        

                  -- Clause A:
                  if X=Y then
                     Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;
                  else
                     Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
                  end if;

                  return False;
               end if;
            end if;
         else
            if not (B) then
               if C then
                  -- Test Case      : A=True,  B=False, C=True => True
                  -- Active Clauses : A,                        

                  -- Clause A:
                  Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;

                  return True;
               end if;
            end if;
         end if;
         return (X>Y or B) and C;
      end RORG_Mark_0;
                 Y : Integer;
                 B : Boolean;
                 C : Boolean) return Boolean is
   begin
      if RORG_Mark_0 then
         return True;
      end if;
      return False;
   end XYBC;
end Sut;
