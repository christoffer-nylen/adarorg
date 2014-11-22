with Ada.Calendar; use Ada.Calendar;

package Messages is
   type Message is tagged record
      Timestamp : Time;
   end record;

   procedure Print(Item : Message);
   procedure Display(Item : Message'Class);

   type Sensor_Message is new Message with record
      Sensor_Id : Integer;
      Reading : Float;
   end record;

   procedure Print(Item : Sensor_Message);

   type Control_Message is new Message with record
      Actuator_Id : Integer;
      Command : Float;
   end record;

   procedure Print(Item : Control_Message);

end Messages;


with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body Messages is

   -----------
   -- Print --
   -----------

   procedure Print (Item : Message) is
      The_Year : Year_Number;
      The_Month : Month_Number;
      The_Day : Day_Number;
      Seconds : Day_Duration;
   begin
      Split(Date => Item.Timestamp, Year => The_Year,
            Month => The_Month, Day => The_Day, Seconds => Seconds);

      Put("Time Stamp:");
      Put(Item => The_Year, Width => 4);
      Put("-");
      Put(Item => The_Month, Width => 1);
      Put("-");
      Put(Item => The_Day, Width => 1);
      New_Line;
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (Item : Sensor_Message) is
   begin
      Print(Message(Item));
      Put("Sensor Id: ");
      Put(Item => Item.Sensor_Id, Width => 1);
      New_Line;
      Put("Reading: ");
      Put(Item => Item.Reading, Fore => 1, Aft => 4, Exp => 0);
      New_Line;
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (Item : Control_Message) is
   begin
      Print(Message(Item));
      Put("Actuator Id: ");
      Put(Item => Item.Actuator_Id, Width => 1);
      New_Line;
      Put("Command: ");
      Put(Item => Item.Command, Fore => 1, Aft => 4, Exp => 0);
      New_Line;
   end Print;

   -------------
   ---Display --
   -------------

   procedure Display(Item : Message'Class) is
   begin
      Print(Item);
   end Display;

end Messages;


with Messages; use Messages;
with Ada.Streams.Stream_Io; use Ada.Streams.Stream_Io;
with Ada.Calendar; use Ada.Calendar;
with Ada.Text_Io;

procedure Streams_Example is
   S1 : Sensor_Message;
   M1 : Message;
   C1 : Control_Message;
   Now : Time := Clock;
   The_File : Ada.Streams.Stream_Io.File_Type;
   The_Stream : Ada.Streams.Stream_IO.Stream_Access;
begin
   S1 := (Now, 1234, 0.025);
   M1.Timestamp := Now;
   C1 := (Now, 15, 0.334);
   Display(S1);
   Display(M1);
   Display(C1);
   begin
      Open(File => The_File, Mode => Out_File,
           Name => "Messages.dat");
   exception
      when others =>
         Create(File => The_File, Name => "Messages.dat");
   end;
   The_Stream := Stream(The_File);
   Sensor_Message'Class'Output(The_Stream, S1);
   Message'Class'Output(The_Stream, M1);
   Control_Message'Class'Output(The_Stream, C1);
   Close(The_File);
   Open(File => The_File, Mode => In_File,
        Name => "Messages.dat");
   The_Stream := Stream(The_File);
   Ada.Text_Io.New_Line(2);
   while not End_Of_File(The_File) loop
      Display(Message'Class'Input(The_Stream));
   end loop;
   Close(The_File);
end Streams_Example;
