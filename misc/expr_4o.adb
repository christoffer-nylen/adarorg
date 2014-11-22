with Rorg;
procedure Expr_4 is
   type week is('d', 'e', 'f');
   a : week := 'd';
   b : week := 'e';
   c : week := week'Val(0);

   type Signal_Type       is
     (Ac,           Dc,           Prep_1,       Prep_2,       Prep_3,
      Arm,          Fire,         Jettison_Cmd);

   Signal : Signal_Type := Ac;

   type Signal_Error_Type is (Signal_Ok,
                             Short_Circuit,
                              Open_Circuit);

   type Signal_Name_Type is         -- Generated in IRS parser, file "code.ads"
     (AIU_LG_Retracted,
      AIU_Power_Supply_Mode_1,
      AIU_Power_Supply_Mode_2,
      BOY_Rear_Fuselage_Ident_1,
      Boot_Load,
      FM_Prep_Supply,
      FM_Prep_2_P1L,
      FM_Prep_2_P1R,
      FM_Prep_2_P2L,
      FM_Prep_2_P2R,
      FM_Prep_2_P3L,
      FM_Prep_2_P3R,
      FM_Prep_2_P4,
      FM_Prep_2_P5,
      FM_Prep_3_P1L,
      FM_Prep_3_P1R,
      FM_Prep_3_P2L,
      FM_Prep_3_P2R,
      FM_Prep_3_P3L);

   type Tristate_Name_Type is       -- Manually written, not generated in IRS parser
     ( SMU_PREP_4_P2L,
       SMU_PREP_4_P2R,
       SMU_PREP_4_P3L,
       SMU_PREP_4_P3R,
       SMU_PREP_4_P4,
       SMU_PREP_5_P2L,
       SMU_PREP_5_P2R,
       SMU_PREP_5_P3L,
       SMU_PREP_5_P3R,
       SMU_PREP_5_P4,
       SMU_PREP_6_P2L,
       SMU_PREP_6_P2R,
       SMU_PREP_6_P3L,
       SMU_PREP_6_P3R,
       SMU_PREP_6_P4,
       SW_Logic_1_P2L,
       SW_Logic_1_P2R,
       SW_Logic_1_P3L,
       SW_Logic_1_P3R,
       SW_Logic_2_P2L,
       SW_Logic_2_P2R,
       SW_Logic_2_P3L,
       SW_Logic_2_P3R,
       SW_Logic_3_P2L,
       SW_Logic_3_P2R,
       SW_Logic_3_P3L,
       SW_Logic_3_P3R,
       SW_Logic_4_P2L,
       SW_Logic_4_P2R,
       SW_Logic_4_P3L,
       SW_Logic_4_P3R,
       Not_Used);

   type In_Signal_Error_Set_Type is array(Signal_Name_Type) of Signal_Error_Type;
   type Tristate_Signal_Error_Set_Type is array(Signal_Error_Type) of Boolean ;
   type Tristate_Error_Set_Type is array(Tristate_Name_Type) of Tristate_Signal_Error_Set_Type;

   Tristate_Error           : Tristate_Error_Set_Type;
   In_Signal_Error          : In_Signal_Error_Set_Type;
   Signal_Name : Tristate_Name_Type;

   Hej : constant Signal_Name_Type := FM_Prep_2_P1R;

   -- RORG_Mark_0
   -- Location          : test/expr_4.adb:84:10:
   --
   -- Predicate         : (A or B or C)
   -- Clause A          : A='d'
   -- Clause B          : B='e'
   -- Clause C          : C = 'f'
   --
   -- Source Expression :
   --          (A='d' or B='e' or C = 'f')
   function RORG_Mark_0 return Boolean is
   begin
      if not (A='d') then
         if not (B='e') then
            if not (C='f') then
               -- Test Case           : A=False, B=False, C=False => False
               -- Determining Clauses : A,       B,       C       

               -- Clause A:
               if A='d' then
                  Rorg.Is_Covered(3,'<'):=Rorg.Is_Covered(3,'<')+1;
               else
                  Rorg.Is_Covered(3,'>'):=Rorg.Is_Covered(3,'>')+1;
               end if;

               -- Clause B:
               if B='e' then
                  Rorg.Is_Covered(2,'<'):=Rorg.Is_Covered(2,'<')+1;
               else
                  Rorg.Is_Covered(2,'>'):=Rorg.Is_Covered(2,'>')+1;
               end if;

               -- Clause C:
               if C='f' then
                  Rorg.Is_Covered(1,'<'):=Rorg.Is_Covered(1,'<')+1;
               else
                  Rorg.Is_Covered(1,'>'):=Rorg.Is_Covered(1,'>')+1;
               end if;

               return False;
            else
               -- Test Case           : A=False, B=False, C=True => True
               -- Determining Clauses :                   C       

               -- Clause C:
               Rorg.Is_Covered(1,'='):=Rorg.Is_Covered(1,'=')+1;

               return True;
            end if;
         else
            if not (C='f') then
               -- Test Case           : A=False, B=True,  C=False => True
               -- Determining Clauses :          B,               

               -- Clause B:
               Rorg.Is_Covered(2,'='):=Rorg.Is_Covered(2,'=')+1;

               return True;
            end if;
         end if;
      else
         if not (B='e') then
            if not (C='f') then
               -- Test Case           : A=True,  B=False, C=False => True
               -- Determining Clauses : A,                        

               -- Clause A:
               Rorg.Is_Covered(3,'='):=Rorg.Is_Covered(3,'=')+1;

               return True;
            end if;
         end if;
      end if;
      return (A='d' or B='e' or C='f');
   end RORG_Mark_0;

   -- RORG_Mark_1
   -- Location          : test/expr_4.adb:86:13:
   --
   -- Predicate         : (A or B or C) and (D or E)
   -- Clause A          : Signal = Prep_1
   -- Clause B          : Signal = Prep_2
   -- Clause C          : Signal = Prep_3
   -- Clause D          : In_Signal_Error(Fm_Prep_Supply) = Short_Circuit
   -- Clause E          : In_Signal_Error(Fm_Prep_Supply) = Open_Circuit
   --
   -- Source Expression :
   --             (Signal = Prep_1 or Signal = Prep_2 or Signal = Prep_3) and
   --         (In_Signal_Error(Fm_Prep_Supply) = Short_Circuit or
   --          In_Signal_Error(Fm_Prep_Supply) = Open_Circuit)
   function RORG_Mark_1 return Boolean is
   begin
      if not (Signal=Prep_1) then
         if not (Signal=Prep_2) then
            if not (Signal=Prep_3) then
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if In_Signal_Error(Fm_Prep_Supply)=Open_Circuit then
                     -- Test Case           : A=False, B=False, C=False, D=False, E=True => False
                     -- Determining Clauses : A,       B,       C,                        

                     -- Clause A:
                     if Signal=Prep_1 then
                        Rorg.Is_Covered(6,'<'):=Rorg.Is_Covered(6,'<')+1;
                     else
                        Rorg.Is_Covered(6,'>'):=Rorg.Is_Covered(6,'>')+1;
                     end if;

                     -- Clause B:
                     if Signal=Prep_2 then
                        Rorg.Is_Covered(5,'<'):=Rorg.Is_Covered(5,'<')+1;
                     else
                        Rorg.Is_Covered(5,'>'):=Rorg.Is_Covered(5,'>')+1;
                     end if;

                     -- Clause C:
                     if Signal=Prep_3 then
                        Rorg.Is_Covered(4,'<'):=Rorg.Is_Covered(4,'<')+1;
                     else
                        Rorg.Is_Covered(4,'>'):=Rorg.Is_Covered(4,'>')+1;
                     end if;

                     return False;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=False, C=False, D=True,  E=False => False
                     -- Determining Clauses : A,       B,       C,                        

                     -- Clause A:
                     if Signal=Prep_1 then
                        Rorg.Is_Covered(6,'<'):=Rorg.Is_Covered(6,'<')+1;
                     else
                        Rorg.Is_Covered(6,'>'):=Rorg.Is_Covered(6,'>')+1;
                     end if;

                     -- Clause B:
                     if Signal=Prep_2 then
                        Rorg.Is_Covered(5,'<'):=Rorg.Is_Covered(5,'<')+1;
                     else
                        Rorg.Is_Covered(5,'>'):=Rorg.Is_Covered(5,'>')+1;
                     end if;

                     -- Clause C:
                     if Signal=Prep_3 then
                        Rorg.Is_Covered(4,'<'):=Rorg.Is_Covered(4,'<')+1;
                     else
                        Rorg.Is_Covered(4,'>'):=Rorg.Is_Covered(4,'>')+1;
                     end if;

                     return False;
                  else
                     -- Test Case           : A=False, B=False, C=False, D=True,  E=True => False
                     -- Determining Clauses : A,       B,       C,                        

                     -- Clause A:
                     if Signal=Prep_1 then
                        Rorg.Is_Covered(6,'<'):=Rorg.Is_Covered(6,'<')+1;
                     else
                        Rorg.Is_Covered(6,'>'):=Rorg.Is_Covered(6,'>')+1;
                     end if;

                     -- Clause B:
                     if Signal=Prep_2 then
                        Rorg.Is_Covered(5,'<'):=Rorg.Is_Covered(5,'<')+1;
                     else
                        Rorg.Is_Covered(5,'>'):=Rorg.Is_Covered(5,'>')+1;
                     end if;

                     -- Clause C:
                     if Signal=Prep_3 then
                        Rorg.Is_Covered(4,'<'):=Rorg.Is_Covered(4,'<')+1;
                     else
                        Rorg.Is_Covered(4,'>'):=Rorg.Is_Covered(4,'>')+1;
                     end if;

                     return False;
                  end if;
               end if;
            else
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=False, C=True,  D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  else
                     -- Test Case           : A=False, B=False, C=True,  D=False, E=True => True
                     -- Determining Clauses :                   C,                        

                     -- Clause C:
                     Rorg.Is_Covered(4,'='):=Rorg.Is_Covered(4,'=')+1;

                     return True;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=False, C=True,  D=True,  E=False => True
                     -- Determining Clauses :                   C,       D,               

                     -- Clause C:
                     Rorg.Is_Covered(4,'='):=Rorg.Is_Covered(4,'=')+1;

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  else
                     -- Test Case           : A=False, B=False, C=True,  D=True,  E=True => True
                     -- Determining Clauses :                   C,                        

                     -- Clause C:
                     Rorg.Is_Covered(4,'='):=Rorg.Is_Covered(4,'=')+1;

                     return True;
                  end if;
               end if;
            end if;
         else
            if not (Signal=Prep_3) then
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=True,  C=False, D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  else
                     -- Test Case           : A=False, B=True,  C=False, D=False, E=True => True
                     -- Determining Clauses :          B,                                 

                     -- Clause B:
                     Rorg.Is_Covered(5,'='):=Rorg.Is_Covered(5,'=')+1;

                     return True;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=True,  C=False, D=True,  E=False => True
                     -- Determining Clauses :          B,                D,               

                     -- Clause B:
                     Rorg.Is_Covered(5,'='):=Rorg.Is_Covered(5,'=')+1;

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  else
                     -- Test Case           : A=False, B=True,  C=False, D=True,  E=True => True
                     -- Determining Clauses :          B,                                 

                     -- Clause B:
                     Rorg.Is_Covered(5,'='):=Rorg.Is_Covered(5,'=')+1;

                     return True;
                  end if;
               end if;
            else
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=True,  C=True,  D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=False, B=True,  C=True,  D=True,  E=False => True
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  end if;
               end if;
            end if;
         end if;
      else
         if not (Signal=Prep_2) then
            if not (Signal=Prep_3) then
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=False, C=False, D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  else
                     -- Test Case           : A=True,  B=False, C=False, D=False, E=True => True
                     -- Determining Clauses : A,                                          

                     -- Clause A:
                     Rorg.Is_Covered(6,'='):=Rorg.Is_Covered(6,'=')+1;

                     return True;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=False, C=False, D=True,  E=False => True
                     -- Determining Clauses : A,                         D,               

                     -- Clause A:
                     Rorg.Is_Covered(6,'='):=Rorg.Is_Covered(6,'=')+1;

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  else
                     -- Test Case           : A=True,  B=False, C=False, D=True,  E=True => True
                     -- Determining Clauses : A,                                          

                     -- Clause A:
                     Rorg.Is_Covered(6,'='):=Rorg.Is_Covered(6,'=')+1;

                     return True;
                  end if;
               end if;
            else
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=False, C=True,  D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=False, C=True,  D=True,  E=False => True
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  end if;
               end if;
            end if;
         else
            if not (Signal=Prep_3) then
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=True,  C=False, D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=True,  C=False, D=True,  E=False => True
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  end if;
               end if;
            else
               if not (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit) then
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=True,  C=True,  D=False, E=False => False
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     if In_Signal_Error(Fm_Prep_Supply)=Short_Circuit then
                        Rorg.Is_Covered(7,'<'):=Rorg.Is_Covered(7,'<')+1;
                     else
                        Rorg.Is_Covered(7,'>'):=Rorg.Is_Covered(7,'>')+1;
                     end if;

                     return False;
                  end if;
               else
                  if not (In_Signal_Error(Fm_Prep_Supply)=Open_Circuit) then
                     -- Test Case           : A=True,  B=True,  C=True,  D=True,  E=False => True
                     -- Determining Clauses :                            D,               

                     -- Clause D:
                     Rorg.Is_Covered(7,'='):=Rorg.Is_Covered(7,'=')+1;

                     return True;
                  end if;
               end if;
            end if;
         end if;
      end if;
      return (Signal=Prep_1 or Signal=Prep_2 or Signal=Prep_3) and (In_Signal_Error(Fm_Prep_Supply)=Short_Circuit or In_Signal_Error(Fm_Prep_Supply)=Open_Circuit);
   end RORG_Mark_1;

   -- RORG_Mark_2
   -- Location          : test/expr_4.adb:94:13:
   --
   -- Predicate         : A
   -- Clause A          : In_Signal_Error(I)=Short_Circuit
   --
   -- Source Expression :
   --             In_Signal_Error(I)=Short_Circuit
   function RORG_Mark_2(I : Signal_Name_Type) return Boolean is
   begin
      if not (In_Signal_Error(I)=Short_Circuit) then
         -- Test Case           : A=False => False
         -- Determining Clauses : A       

         -- Clause A:
         if In_Signal_Error(I)=Short_Circuit then
            Rorg.Is_Covered(8,'<'):=Rorg.Is_Covered(8,'<')+1;
         else
            Rorg.Is_Covered(8,'>'):=Rorg.Is_Covered(8,'>')+1;
         end if;

         return False;
      else
         -- Test Case           : A=True => True
         -- Determining Clauses : A       

         -- Clause A:
         Rorg.Is_Covered(8,'='):=Rorg.Is_Covered(8,'=')+1;

         return True;
      end if;
      return In_Signal_Error(I)=Short_Circuit;
   end RORG_Mark_2;

begin
   for I in Signal_Name_Type'Range loop
      if RORG_Mark_0 then
         null;
      elsif RORG_Mark_1 then
         null;
      elsif (Tristate_Error(Signal_Name)(Short_Circuit) or
             Tristate_Error(Signal_Name)(Open_Circuit) or
             Signal_Name = Not_Used) then
         null;
      elsif RORG_Mark_2(I) then
         null;
      end if;
   end loop;

   for R in Signal_Name_Type'Range loop
      null;
   end loop;
end Expr_4;
