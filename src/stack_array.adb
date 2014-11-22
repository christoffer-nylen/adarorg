with Ada.Text_Io;
use Ada.Text_Io;
package body Stack_Array is

   procedure Get( X: in out Element_Type; I: in Positive; S: in Stack ) is
   begin
      if I not in 1..S.Top_Of_Stack then
         raise Out_Of_Bounds;
      end if;
      X := S.Stack_Array(I);
   end Get;

   procedure Insert
     (X : in Element_Type;
      I : in Positive;
      S : in out Stack)
   is
   begin
      if I in 1..S.Top_Of_Stack then
         Put_Line("stack_array.adb: Out_Of_Bounds");
         raise Out_Of_Bounds;
      end if;
      S.Stack_Array(I) := X;
   end Insert;

   -- Return true if Stack S is empty, false otherwise
   function Is_Empty( S: Stack ) return Boolean is
    begin
        return S.Top_Of_Stack = S.Stack_Array'First - 1;
    end Is_Empty;

    -- Return true if Stack S is full, false otherwise
    function Is_Full( S: Stack ) return Boolean is
    begin
        return S.Top_Of_Stack = S.Stack_Array'Last;
    end Is_Full;

    -- Make Stack S empty
    procedure Make_Empty( S: in out Stack ) is
    begin
        S.Top_Of_Stack := S.Stack_Array'First - 1;
    end Make_Empty;

    function Peek ( S: in Stack) return Element_Type Is
    begin
       if Is_Empty( S ) then
          Put_Line("stack_array.adb: Underflow");
          raise Underflow;
       end if;
       return S.Stack_Array( S.Top_Of_Stack );
    end Peek;

    -- Delete top item from Stack S
    -- Raise Underflow if S is empty
    procedure Pop( S: in out Stack ) is
    begin
       if Is_Empty( S ) then
          Put_Line("stack_array.adb: Underflow");
          raise Underflow;
       end if;

       S.Top_Of_Stack := S.Top_Of_Stack - 1;
    end Pop;

    -- Delete top item from S, store it in Top_Element
    -- Raise Underflow if S is empty
    procedure Pop( S: in out Stack; Top_Element: out Element_Type ) is
    begin
       if Is_Empty( S ) then
          Put_Line("stack_array.adb: Underflow");
          raise Underflow;
       end if;

       Top_Element := S.Stack_Array( S.Top_Of_Stack );
       S.Top_Of_Stack := S.Top_Of_Stack - 1;
    end Pop;

    -- Insert X as new top of Stack S
    -- Raise Overflow if S is full
    procedure Push( X: Element_Type; S: in out Stack ) is
    begin
       if Is_Full( S ) then
          Put_Line("stack_array.adb: Underflow");
          raise Overflow;
       end if;

       S.Top_Of_Stack := S.Top_Of_Stack + 1;
       S.Stack_Array( S.Top_Of_Stack ) := X;
    end Push;

    function Length ( S: Stack ) return Natural is
    begin
       return S.Top_Of_Stack;
    end Length;

    -- Return top item in Stack S
    -- Raise Underflow if S is empty
    function Top( S: Stack ) return Element_Type is
    begin
       if Is_Empty( S ) then
          Put_Line("stack_array.adb: Underflow");
          raise Underflow;
       end if;

       return S.Stack_Array( S.Top_Of_Stack );
    end Top;

    function Is_Present ( X: Element_Type; S : Stack) return Boolean is
    begin
       for I in Integer range 1..S.Top_Of_Stack loop
          if Is_Equal(X, S.Stack_Array(I)) then
             return True;
          end if;
       end loop;
       return False;
    end Is_Present;

    function Has_Property (S : Stack) return Boolean is
    begin
       for I in Integer range 1..S.Top_Of_Stack loop
          if Property(S.Stack_Array(I)) then
             return True;
          end if;
       end loop;
       return False;
    end;

    function Get_Corresponding_Element ( X: in Element_Type;
                                         S : in Stack) return Element_Type is
    begin
       for I in Integer range 1..S.Top_Of_Stack loop
          if Is_Equal(X, S.Stack_Array(I)) then
             return S.Stack_Array(I);
          end if;
       end loop;
       raise Element_Not_Found;
    end Get_Corresponding_Element;

    procedure Iterate(S : in Stack) is
    begin
       for I in Integer range 1..S.Top_Of_Stack loop
          Action(S.Stack_Array(I));
       end loop;
    end Iterate;

    procedure Update(S : in out Stack) is
    begin
       for I in Integer range 1..S.Top_Of_Stack loop
          Action(S.Stack_Array(I));
       end loop;
    end Update;

end Stack_Array;
