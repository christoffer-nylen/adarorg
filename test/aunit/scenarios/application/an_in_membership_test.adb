procedure An_In_Membership_Test is

   subtype Score is Integer range 1 .. 60;
   Total: Integer;
   S: Score;

begin
   if Total in Score then
      null;
   end if;
end An_In_Membership_Test;
