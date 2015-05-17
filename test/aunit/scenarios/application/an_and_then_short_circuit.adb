procedure An_And_Then_Short_Circuit is
   A,B,C : Boolean;
   type Primary_Color is (Red, Green, Blue);
   D : Primary_Color;
   E : Integer;
begin
   if (A and B) and then C then
      null;
   end if;
   case D is
      when Red | Green  =>
         null;
      when Blue =>
         null;
   end case;
   if E>1 then
      null;
   end if;
end An_And_Then_Short_Circuit;
