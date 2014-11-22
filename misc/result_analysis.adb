--TODO: Generic package
--type operand_a
--type operand_b
--<
--=
-->

package body result_analysis is


   --We need three tests, a < b, a = b, c > b and are assured of having
   --at least two (thanks to MC/DC coverage)
   type theThreeConditions is (Less_Than, Equal, Greater_Than);
   isCovered[Less_Than]=isCovered[Equal]=isCovered[Greater_Than]=False
   --for each recording
   if a<b then
      isCovered[Less_Than]=True;
   elsif a>b then
      isCovered[Equal]=True;
   else
      isCovered[Greater_Than]=True;
end result_analysis;
