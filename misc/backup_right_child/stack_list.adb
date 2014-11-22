with Unchecked_Deallocation;

package body Stack_List is

    procedure Dispose is new Unchecked_Deallocation( Node, Node_Ptr );

    -- Initialize and Finalize routines
    procedure Initialize( S: in out Stack ) is
    begin
        null;
    end Initialize;

    procedure Finalize( S: in out Stack ) is
    begin
        Make_Empty( S );
    end Finalize;

    -- Return true if Stack S is empty, false otherwise
    function Is_Empty( S: Stack ) return Boolean is
    begin
        return S.TopOfStack = null;
    end Is_Empty;

    -- Make Stack S empty
    procedure Make_Empty( S: in out Stack ) is
    begin
	while not Is_Empty( S ) loop
            Pop( S );
        end loop;
    end Make_Empty;

    -- Remove top item from Stack S
    -- Raise Underflow if S is empty
    procedure Pop( S: in out Stack ) is
        First_Cell : Node_Ptr;
    begin
        if Is_Empty( S ) then
            raise Underflow;
        end if;

        First_Cell := S.TopOfStack;
        S.TopOfStack := S.TopOfStack.Next;
        Dispose( First_Cell );
    end Pop;

    -- Insert X as new top item in Stack S
    -- Raise Overflow if out of memory
    procedure Push( X: Element_Type; S: in out Stack ) is
    begin
        S.TopOfStack := new Node'( X, S.TopOfStack );
    exception
        when Storage_Error =>
            raise Overflow;
    end Push;

    -- Return top item in Stack S
    -- Raise Underflow if S is empty
    function Top( S: Stack ) return Element_Type is
    begin
        if Is_Empty( S ) then
            raise Underflow;
        end if;

        return S.TopOfStack.Element;
    end Top;

end Stack_List;
