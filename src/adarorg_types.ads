package Adarorg_Types is
   type Ada_Type_Kind is (Enumeration_Type,
                          Integer_Type,
                          Real_Type,
                          Access_Type,
                          Composite_Type,
                          Unknown_Type);

   type Static_Data is
      record
         Relops_Total : Natural;
         Relops_Tested : Natural;
         Predicates_Total : Natural;
         Predicates_Tested : Natural;
      end record;
end Adarorg_Types;
