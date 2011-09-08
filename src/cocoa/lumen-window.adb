with Interfaces.C.Pointers;
with Interfaces.C.Strings;
with System;

package body Lumen.Window is

   procedure Create (Win           : in out Handle;
                     Parent        : in     Handle             := No_Window;
                     Width         : in     Natural            := 400;
                     Height        : in     Natural            := 400;
                     Events        : in     Wanted_Event_Set   := Want_No_Events;
                     Name          : in     String             := "";
                     Icon_Name     : in     String             := "";
                     Class_Name    : in     String             := "";
                     Instance_Name : in     String             := "";
                     Context       : in     Context_Handle     := No_Context;
                     Depth         : in     Color_Depth        := True_Color;
                     Direct        : in     Boolean            := True;
                     Animated      : in     Boolean            := True;
                     Attributes    : in     Context_Attributes := Default_Context_Attributes) is

      type Event_Kind is (Terminator,
                          Key_Press, Key_Release, Button_Press, Button_Release,
                          Window_Enter, Window_Leave, Pointer_Move, Pointer_Drag,
                          Exposure, Focus_Change);
      for Event_Kind use (Terminator     => 0,
                          Key_Press      => 1,
                          Key_Release    => 2,
                          Button_Press   => 3,
                          Button_Release => 4,
                          Window_Enter   => 5,
                          Window_Leave   => 6,
                          Pointer_Move   => 7,
                          Pointer_Drag   => 8,
                          Exposure       => 9,
                          Focus_Change   => 10);
      for Event_Kind'Size use 32;

      type Event_Kind_List is array (Positive range <>) of aliased Event_Kind;

      type Int_List is array (Positive range <>) of aliased Interfaces.C.int;

      function Luco_Create_Window (Parent : Handle;
                                   Width, Height : Interfaces.C.int;
                                   Wanted_Events : Interfaces.C.int;
                                   Name          : Interfaces.C.Strings.chars_ptr;
                                   Context       : Context_Handle;
                                   Direct, Animated : Interfaces.C.int;
                                   Attributes : access constant Interfaces.C.int)
                                   return Handle;

      pragma Import (C, Luco_Create_Window, "luco_create_window");

      use type Interfaces.C.int;

      Raw_Wanted_Events : Interfaces.C.int := 0;
      Name_String       : Interfaces.C.Strings.chars_ptr
        := Interfaces.C.Strings.New_String (Name);
      Raw_Direct, Raw_Animated : Interfaces.C.int := 0;

      -- currently not implemented
      Raw_Attributes    : Int_List := (1 => 0);
   begin
      for Index in Events'Range loop
         if Events (Index) then
            Raw_Wanted_Events := Raw_Wanted_Events + 2 ** (Wanted_Event'Pos (Index));
         end if;
      end loop;
      if Direct then
         Raw_Direct := 1;
      end if;
      if Animated then
         Raw_Animated := 1;
      end if;

      Win := Luco_Create_Window (Parent, Interfaces.C.int (Width),
                                 Interfaces.C.int (Height), Raw_Wanted_Events,
                                 Name_String, Context, Raw_Direct,
                                 Raw_Animated,
                                 Raw_Attributes (Raw_Attributes'First)'Access);

   end Create;

   procedure Destroy (Win : in out Handle) is
      procedure Luco_Destroy_Window (Window : in Handle);
      pragma Import (C, Luco_Destroy_Window, "luco_destroy_window");
   begin
      Luco_Destroy_Window (Win);
      Win := null;
   end Destroy;

   procedure Set_Names (Win           : in Handle;
                        Name          : in String           := "";
                        Icon_Name     : in String           := "";
                        Class_Name    : in String           := "";
                        Instance_Name : in String           := "") is
      procedure Luco_Set_Names (Win : in Handle;
                                Name, Icon_Name : in Interfaces.C.Strings.chars_ptr);
      pragma Import (C, Luco_Set_Names, "luco_set_names");

      use Interfaces.C.Strings;
   begin
      Luco_Set_Names (Win, New_String (Name), New_String (Icon_Name));
   end Set_Names;

   function Create_Context (Win    : in Handle;
                            Direct : in Boolean := True)
                            return Context_Handle is
   begin
      -- TODO
      return System.Null_Address;
   end Create_Context;

   procedure Destroy_Context (Win : in out Handle) is
   begin
      -- TODO
      null;
   end Destroy_Context;

   procedure Make_Current (Win : in Handle) is
      procedure Luco_Make_Current (Win : in Handle);
      pragma Import (C, Luco_Make_Current, "luco_make_current");
   begin
      Luco_Make_Current (Win);
   end Make_Current;

   procedure Set_Context (Win     : in out Handle;
                          Context : in     Context_Handle) is
      procedure Luco_Set_Context (Win : in Handle; Context : in Context_Handle);
      pragma Import (C, Luco_Set_Context, "luco_set_context");
   begin
      Luco_Set_Context (Win, Context);
   end Set_Context;

   procedure Swap (Win : in Handle) is
      procedure Luco_Swap (Win : in Handle);
      pragma Import (C, Luco_Swap, "luco_swap");
   begin
      Luco_Swap (Win);
   end Swap;

   function Width (Win : in Handle) return Natural is
      function Luco_Width (Win : in Handle) return Interfaces.C.int;
      pragma Import (C, Luco_Width, "luco_width");
   begin
      return Natural (Luco_Width (Win));
   end Width;

   function Height (Win : in Handle) return Natural is
      function Luco_Height (Win : in Handle) return Interfaces.C.int;
      pragma Import (C, Luco_Height, "luco_height");
   begin
      return Natural (Luco_Height (Win));
   end Height;

end Lumen.Window;
