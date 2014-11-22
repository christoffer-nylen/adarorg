------------------------------------------------------------------------------
--                                                                          --
--                      DISPLAY_SOURCE COMPONENTS                           --
--                                                                          --
--                              S T A C K S                                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--            Copyright (c) 1995-1999, Free Software Foundation, Inc.       --
--                                                                          --
-- Display_Source is free software; you can redistribute it and/or modify it--
-- under terms of the  GNU General Public License  as published by the Free --
-- Software Foundation;  either version 2,  or  (at your option)  any later --
-- version. Display_Source is distributed in the hope  that it will be use- --
-- ful, but WITHOUT ANY WARRANTY; without even the implied warranty of MER- --
-- CHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General  --
-- Public License for more details. You should have received a copy of the  --
-- GNU General Public License distributed with GNAT; see file COPYING. If   --
-- not, write to the Free Software Foundation, 59 Temple Place Suite 330,   --
-- Boston, MA 02111-1307, USA.                                              --
--                                                                          --
-- Display_Source is distributed as a part of the ASIS implementation for   --
-- GNAT (ASIS-for-GNAT).                                                     --
--                                                                          --
-- The   original   version   of  Display_Source  has  been  developed  by  --
-- Jean-Charles  Marteau and Serge Reboul,  ENSIMAG  High School Graduates  --
-- (Computer sciences)  Grenoble,  France  in  Sema Group Grenoble, France. --
--                                                                          --
-- Display_Source is now maintained by Ada Core Technologies Inc            --
-- (http://www.gnat.com).                                                   --
------------------------------------------------------------------------------

-----------------------------------------------------------------
-- This package is part of the ASIS application display_source --
-----------------------------------------------------------------
-- It provides an implementation of stacks ...                 --
-- It is used in Source_Trav package .                         --
-----------------------------------------------------------------
generic

   type T_Elem is private;

   type A_Elem is access all T_Elem;

   Initial_Number : Natural := 50;

package Stacks is

   type Stack is private;
   Empty_Stack : constant Stack;

   Stack_Error : exception;

   --  standard functions for a stack :
   --  Push puts an Elem on the top of the stack
   --  Pop gets the last pushed element of the stack
   procedure Push (St : in out Stack; Elem : in T_Elem);
   procedure Pop (St : in out Stack; Elem : out T_Elem);
   --  Upper lets you have access to the first Elem
   --  on the top of the stack.
   function Upper (St : in Stack) return A_Elem;
   function Size_Of_Stack (St : in Stack) return Natural;
   function Is_Empty (St : in Stack) return Boolean;

private

   type T_Node;

   type Stack is access all T_Node;

   Empty_Stack : constant Stack := null;

end Stacks;