procedure Another_In_Membership_Test_Indent is

   subtype Score is Integer range 1 .. 60;
   Total: Integer;
   S: Score;

   I, J : Integer;

begin
   if Total in Score or I=J then
      null;
   end if;
end Another_In_Membership_Test_Indent;
