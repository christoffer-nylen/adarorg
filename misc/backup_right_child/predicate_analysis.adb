-- ASIS
with
  Asis,
  Asis.Elements,
  Asis.Declarations,
  Asis.Expressions,
  Asis.Extensions,
  Asis.Statements,
  Asis.Text;

-- Ada
with
  Ada.Wide_Text_Io,
  Ada.Strings,
  Ada.Strings.Wide_Fixed,
  Interfaces;
use
  Ada.Wide_Text_Io;

with
  Stack_Array,
  Binary_Map,
  Binary_Tree,
  Bit_Operations;

--Adalog
with
  Utilities,
  Thick_Queries;

--RORG
with
  Active_Clauses,
  Predicate,
  Predicate_Queries,
  Rorg_Analysis_Constants;
use
  Rorg_Analysis_Constants;

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
      use Utilities;
      Tmp : Predicate.Predicate_Tree.Node_Access;
      Number_Of_Clauses : Natural := Active_Clauses.Number_Of_Clauses;

      Test_Set : Bit_Set;
   begin
      --Number_Of_Clauses := Element_Stack.Length(Clauses);
      for P in Bit_Set range 1..2**Number_Of_Clauses loop
         Test_Set := P-1;
         Put("Test_Set"& Bit_Set'Wide_Image(P)&":");
         for Clause in reverse 1..Number_Of_Clauses loop
            Active_Clauses.Get(Tmp, Clause);
            if Bit_At(Clause, Test_Set)=True then
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
      use Asis, Asis.Declarations, Asis.Elements, Asis.Expressions;
      --use Predicate.Test_Pairs;
      use Bit_Operations;
      use Predicate_Queries;
      use Utilities;

      Number_Of_Clauses : Natural := Active_Clauses.Number_Of_Clauses;
      P1_Outcome, P2_Outcome : Boolean := False;
      Tmp_Bits : Bit_Set;
      Predicate2 : Bit_Set;

      Determining_Clauses : Bit_Set;

      Tmp : Predicate.Predicate_Tree.Node_Access;

      function Is_Compareable(Elem : Asis.Element) return Boolean is
         use Thick_Queries;
      begin
         case Expression_Kind(Elem) is
            when An_Integer_Literal .. A_String_Literal =>
               return True;
            when A_Character_Literal =>
               return True;
            when An_Enumeration_Literal =>
               declare
                  Representation_Value : Integer := Integer'Wide_Value(Representation_Value_Image(Corresponding_Name_Definition(Elem)));
                  Type_Decl : Asis.Declaration := Corresponding_Expression_Type(Elem);
                  Bounds : constant Asis.Element_List := Discrete_Constraining_Bounds (Type_Decl);
                  Is_Minimum_Value : Boolean := True;
                  Is_Maximum_Value : Boolean := True;
               begin
                  --Put_Line("Value/Pos: " & Integer'Wide_Image(Representation_Value));
                  for I in Bounds'Range loop
                     if Integer'Wide_Value(Representation_Value_Image(Bounds(I))) < Representation_Value then
                        Is_Minimum_Value := False;
                     end if;
                     if Integer'Wide_Value(Representation_Value_Image(Bounds(I))) > Representation_Value then
                        Is_Maximum_Value := False;
                     end if;
                  end loop;
                  return not (Is_Minimum_Value or Is_Maximum_Value);
               end;
            when An_Identifier =>
               return True;
            when An_Indexed_Component=>
               return True;
            when A_Selected_Component =>
               return True;
            when An_Attribute_Reference =>
               return True;
            when A_Function_Call =>
               return True;
            when others =>
               Trace("predicate_analysis.adb : Strange Operand:", Elem);
               return True;
         end case;
      end Is_Compareable;
   begin

      --Identify Tc, the tests for which c determines p
      for Predicate1 in Bit_Set range 1..2**Number_Of_Clauses loop

         Determining_Clauses := 0;
         for Clause in Integer range 1..Number_Of_Clauses loop
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
               Switch_Bit(Clause, Tmp_Bits);
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
                     if Is_Compareable(Tmp.Left.Data.Element) and Is_Compareable(Tmp.Right.Data.Element) then
                        --Put_Line("HerEEer3");
                        --TODO: Give Clause ID
                        if not Predicate.Has_Id(Tmp.Data) then
                           Predicate.Generate_Id(Tmp.Data);
                        end if;
                        Set_Bit(Clause, Determining_Clauses); --Move this line outside if to Get MCDC/Regular clause coverage instead
                     end if;
                  end if;
               end if;
            --end if;
         end loop;

         if Determining_Clauses>0 then
            declare
               Test_Set : Determining_Test_Set.Test_Pair := (To_Integer(Predicate1),
                                                             Determining_Clauses,
                                                             P1_Outcome);
            begin
               Determining_Test_Set.Test_Pairs.Push(Test_Set, Predicate_Pairs);
               Put("Test_Set:" & Bit_Set'Wide_Image(Predicate1) & ", Det_Clauses" & Bit_Set'Wide_Image(Determining_Clauses) & ":");
               for Clause in reverse 1..Number_Of_Clauses loop
                  if Bit_At(Clause, Determining_Clauses)=True then
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
