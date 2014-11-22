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

begin
   for I in Signal_Name_Type'Range loop
      if (A='d' or B='e' or C = 'f') then
         null;
      elsif (Signal = Prep_1 or Signal = Prep_2 or Signal = Prep_3) and
        (In_Signal_Error(Fm_Prep_Supply) = Short_Circuit or
         In_Signal_Error(Fm_Prep_Supply) = Open_Circuit) then
         null;
      elsif (Tristate_Error(Signal_Name)(Short_Circuit) or
             Tristate_Error(Signal_Name)(Open_Circuit) or
             Signal_Name = Not_Used) then
         null;
      elsif In_Signal_Error(I)=Short_Circuit then
         null;
      end if;
   end loop;

   for R in Signal_Name_Type'Range loop
      null;
   end loop;
end Expr_4;
