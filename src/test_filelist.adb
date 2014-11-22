with Filelist;
use Filelist;

procedure Test_Filelist is
   A : Wide_String(1..100);
   B : Wide_String(1..100);
   Hej : Instrumented_File;
begin
   Print_Filelist;

   A(1..3) := "h3r";
   B(1..8) := "test/h33";
   Hej := (A, 3, B, 8, 8, 3);
   Update_Filelist(Hej);

   A(1..5) := "soo6e";
   B(1..10) := "test/soo6e";
   Hej := (A, 5, B, 10, 2, 4);
   Update_Filelist(Hej);
end Test_Filelist;
