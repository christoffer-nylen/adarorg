-- Generic Package Specification for Stack_List
--     Uses a linked list implementation
-- Requires:
--     Instantiated with any private type
-- Types defined:
--     Stack               limited private type
-- Exceptions defined:
--     Overflow            raised for Push on a full Stack
--     Underflow           raised for Pop or Top on empty Stack
-- Operations defined:
--     Initialize and Finalize are defined
--     Is_Empty            returns true if stack is empty
--     Make_Empty          make a stack empty
--     Pop                 delete top element from stack
--     Push                add a new top element to stack
--     Top                 return top element of stack

with Ada.Finalization;

generic
    type Element_Type is private;
package Stack_List is
    type Stack is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( S: in out Stack );
    procedure Finalize( S: in out Stack );

    function  Is_Empty( S: Stack ) return Boolean;
    procedure Make_Empty( S: in out Stack );
    procedure Pop  ( S: in out Stack );
    procedure Push ( X: Element_Type; S: in out Stack );
    function  Top  ( S: Stack ) return Element_Type;

    Overflow : exception;
    Underflow: exception;

private
    -- Stack implementation is a linked list with no header

    type Node;
    type Node_Ptr is access Node;

    type Node is
      record
        Element : Element_Type;
        Next    : Node_Ptr;
      end record;

    type Stack is new Ada.Finalization.Limited_Controlled with
      record
        TopOfStack : Node_Ptr;
      end record;

end Stack_List;
