procedure A_Null_Literal_And_Stuff is
   type Dir_node;
   type p_Dir_node is access Dir_node;
   type Dir_node(name_len: Natural) is record
      left, right      : p_Dir_node;
   end record;
   vine_tail, remainder, Temp, Root : p_Dir_node;
   A,B,C : Boolean;
   E : Integer;
   total, max_depth, sum_depth : Integer;

   procedure Traverse( p: p_Dir_node; depth: Natural ) is
    begin
      if p /= null then
        total:= total + 1;
        if depth > max_depth then
          max_depth:= depth;
        end if;
        sum_depth:= sum_depth + depth;
        Traverse(p.left, depth + 1);
        Traverse(p.right, depth + 1);
      end if;
    end Traverse;

begin
   vine_tail := Root;
   remainder := vine_tail.right;
   if remainder.left = null then
      null;
   end if;
   if remainder.left /= null then
      null;
   end if;
   if (A or B) and C then
      null;
   end if;
end A_Null_Literal_And_Stuff;
