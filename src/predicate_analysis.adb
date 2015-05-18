-- Ada
with
  Ada.Wide_Text_Io;
use
  Ada.Wide_Text_Io;

with
  Asis,
  Asis.Elements,
  Asis.Expressions;

with
  Stack_Array,
  Bit_Operations;

--RORG
with
  Active_Clauses,
  Adarorg_Constants,
  Adarorg_Types,
  Adarorg_Types.Asis_Types,
  Predicate_Queries,
  Statistics;
use
  Adarorg_Constants;

package body Predicate_Analysis is

   --TODO: Pekare eller publik??
   package Predicate_Outcome is new Stack_Array(Boolean);
   Truth_Table : Predicate_Outcome.Stack(2**PREDICATE_SIZE);

   procedure Clear is
   begin
      Predicate_Outcome.Make_Empty(Truth_Table);
   end Clear;

   procedure Populate_Truth_Table (Eval_Tree : in Predicate.Predicate_Tree.Node_Access) is
      use Bit_Operations;
      use Predicate_Queries;

      Tmp : Predicate.Predicate_Tree.Node_Access;
      Number_Of_Clauses : constant Natural := Active_Clauses.Number_Of_Clauses;

      Test_Set : Bit_Set;
   begin
      --Number_Of_Clauses := Element_Stack.Length(Clauses);
      for P in Bit_Set range 1..2**Number_Of_Clauses loop
         Test_Set := P-1;
         Put("Test_Set"& Bit_Set'Wide_Image(P)&":");
         for Clause in 1..Number_Of_Clauses loop
            Active_Clauses.Get(Tmp, Clause);
            if Bit_At(Number_Of_Clauses-Clause+1, Test_Set) then
               Put("1");
               Tmp.Data.Value := True;
            else
               Put("0");
               Tmp.Data.Value := False;
            end if;
         end loop;

         if Predicate.Eval(Eval_Tree) then
            Predicate_Outcome.Push(True, Truth_Table);
            Put_Line("=1");--, size:"&Natural'Wide_Image(Predicate_Outcome.Length(Truth_Table)));
         else
            Predicate_Outcome.Push(False, Truth_Table);
            Put_Line("=0");--, size:"&Natural'Wide_Image(Predicate_Outcome.Length(Truth_Table)));
         end if;
      end loop;
   end Populate_Truth_Table;

   procedure Identify_Test_Set(Predicate_Pairs : out Determining_Test_Set.Test_Pairs.Stack) is
      --use Predicate.Test_Pairs;
      use Bit_Operations;
      use Predicate_Queries;

      Number_Of_Clauses : constant Natural := Active_Clauses.Number_Of_Clauses;
      P1_Outcome, P2_Outcome : Boolean := False;
      Tmp_Bits : Bit_Set;
      Predicate2 : Bit_Set;

      Determining_Clauses : Bit_Set;

      Tmp : Predicate.Predicate_Tree.Node_Access;
   begin

      --Identify Tc, the tests for which c determines p
      for Predicate1 in Bit_Set range 1..2**Number_Of_Clauses loop

         Determining_Clauses := 0;
         for Clause in 1..Number_Of_Clauses loop
            Active_Clauses.Get(Tmp, Clause);

            --TODO: Check "basic" feasible path check:
            --   when Left or Right clause is An_Integer_Literal, A_Real_Literal, An_Enumeration_Literal
            --if not Feasible_Path then
            --   Continue;
            --end if;

            --if Bit_At(Clause, Predicate1)=True then
               Predicate_Outcome.Get(P1_Outcome, To_Integer(Predicate1), Truth_Table);

               Tmp_Bits := Predicate1-1;
               --Put_Line("Tmp_Bits_Before:" & Bit_Set'Wide_Image(Tmp_Bits));
               Switch_Bit(Number_Of_Clauses-Clause+1, Tmp_Bits);
               --Put_Line("Tmp_Bits_After:" & Bit_Set'Wide_Image(Tmp_Bits));
               Predicate2 := Tmp_Bits+1;

               --Put_Line("HerEEer0");
               Predicate_Outcome.Get(P2_Outcome, To_Integer(Predicate2), Truth_Table);
               --Put_Line("Pair?:" & Bit_Set'Wide_Image(Predicate1) & "," & Bit_Set'Wide_Image(Predicate2));
               --Put_Line("Outcomes:" & Boolean'Wide_Image(P1_Outcome) & "," & Boolean'Wide_Image(P2_Outcome));
               if (not P1_Outcome=P2_Outcome) then
                  --Put_Line("Pair:" & Bit_Set'Wide_Image(Predicate1) & "," & Bit_Set'Wide_Image(Predicate2));
                  --Put_Line("HerEEer1");
                  if Is_Relational_Clause(Tmp.Data.Element) then
                     --Put_Line("HerEEer2");
                     if Predicate.Is_Comparable(Tmp.Data) then
                        --Put_Line("HerEEer3");
                        --TODO: Give Clause ID
                        if not Predicate.Has_Relop_Id(Tmp.Data) then
                           Statistics.Process_Tested_Relational_Operator(Adarorg_Types.Asis_Types.To_Ada_Relational_Operator(Asis.Elements.Operator_Kind(Tmp.Data.Element)),
                                                                         Tmp.Data.Relop_Kind);
                           Predicate.Assign_Relop_Id(Tmp.Data, Statistics.Get_Relops_Tested_Count);
                        end if;
                        Set_Bit(Number_Of_Clauses-Clause+1, Determining_Clauses); --Move this line outside if to Get MCDC/Regular clause coverage instead
                     end if;
                  end if;
               end if;
            --end if;
         end loop;

         if Determining_Clauses>0 then
            declare
               Test_Set : constant Determining_Test_Set.Test_Pair := (To_Integer(Predicate1),
                                                                      Determining_Clauses,
                                                                      P1_Outcome);
            begin
               Determining_Test_Set.Test_Pairs.Push(Test_Set, Predicate_Pairs);
               Put("Test_Set:" & Bit_Set'Wide_Image(Predicate1) & ", Determining:");-- & Bit_Set'Wide_Image(Determining_Clauses) & ":");
               for Clause in 1..Number_Of_Clauses loop
                  if Bit_At(Number_Of_Clauses-Clause+1, Determining_Clauses) then
                     Put("1");
                  else
                     Put("0");
                  end if;
               end loop;
               New_Line;
            end;
         end if;
      end loop;
   end Identify_Test_Set;

end Predicate_Analysis;
