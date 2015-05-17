procedure A_Null_Literal is
   type Dir_node;
   type p_Dir_node is access Dir_node;
   type Dir_node(name_len: Natural) is record
      left, right      : p_Dir_node;
   end record;

   vine_tail, remainder, Temp, Root : p_Dir_node;
begin
   vine_tail := Root;
   remainder := vine_tail.right;
   if remainder.left = null then
      null;
   end if;
end A_Null_Literal;
