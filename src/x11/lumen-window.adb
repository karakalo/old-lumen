
-- Lumen.Window -- Create and destroy native windows and associated OpenGL
-- rendering contexts
--
-- Chip Richards, NiEstu, Phoenix AZ, Spring 2010

-- This code is covered by the ISC License:
--
-- Copyright © 2010, NiEstu
--
-- Permission to use, copy, modify, and/or distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- The software is provided "as is" and the author disclaims all warranties
-- with regard to this software including all implied warranties of
-- merchantability and fitness. In no event shall the author be liable for any
-- special, direct, indirect, or consequential damages or any damages
-- whatsoever resulting from loss of use, data or profits, whether in an
-- action of contract, negligence or other tortious action, arising out of or
-- in connection with the use or performance of this software.

-- The declarations below include a minimal Xlib binding, adapted from code by
-- Hans-Frieder Vogt and Vadim Godunko.  Their code was GPLv2, but I've raped
-- it so badly, and they haven't touched it in so long, that I feel okay about
-- including its derivation here.  Also included is a minimal binding to GLX,
-- adapted from another bit of abandonware originally by David Holm.  His
-- license was a different one still, and the above excuse also applies to it.


-- Environment
with Ada.Calendar;
with Ada.Command_Line;
with Ada.Directories;
with Ada.Environment_Variables;
with Ada.Unchecked_Deallocation;
with System;

with GNAT.Case_Util;

with Lumen.Binary;

-- This is really "part of" this package, just packaged separately so it can
-- be used in Events
with Lumen.Internal;
use  Lumen.Internal;

with GL.GLX;
use GL.GLX;

package body Lumen.Window is

   ---------------------------------------------------------------------------

   -- Xlib stuff needed by more than one of the routines below
   type Data_Format_Type is (Invalid, Bits_8, Bits_16, Bits_32);
   for  Data_Format_Type use (Invalid => 0, Bits_8 => 8, Bits_16 => 16, Bits_32 => 32);

   String_Encoding : String := "STRING" & ASCII.NUL;

   type X_Class_Hint is record
      Instance_Name : System.Address;
      Class_Name    : System.Address;
   end record;

   type X_Text_Property is record
      Value    : System.Address;
      Encoding : Atom;
      Format   : Data_Format_Type;
      NItems   : Long_Integer;
   end record;

   function X_Intern_Atom (Display        : Display_Pointer;
                           Name           : System.Address;
                           Only_If_Exists : Natural)
   return Atom;
   pragma Import (C, X_Intern_Atom, "XInternAtom");

   procedure X_Set_Class_Hint (Display : in Display_Pointer;
                               Window  : in GLX_Drawable;
                               Hint    : in X_Class_Hint);
   pragma Import (C, X_Set_Class_Hint, "XSetClassHint");

   procedure X_Set_Icon_Name (Display : in Display_Pointer;
                              Window  : in GLX_Drawable;
                              Name    : in System.Address);
   pragma Import (C, X_Set_Icon_Name, "XSetIconName");

   procedure X_Set_WM_Icon_Name (Display   : in Display_Pointer;
                                 Window    : in GLX_Drawable;
                                 Text_Prop : in System.Address);
   pragma Import (C, X_Set_WM_Icon_Name, "XSetWMIconName");

   procedure X_Set_WM_Name (Display   : in Display_Pointer;
                            Window    : in GLX_Drawable;
                            Text_Prop : in System.Address);
   pragma Import (C, X_Set_WM_Name, "XSetWMName");

   -- Create a native window
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

      -- Xlib types needed only by Create
      type Alloc_Mode               is (Alloc_None, Alloc_All);
      type Atom_Array               is array (Positive range <>) of Atom;
      type Colormap_ID              is new Long_Integer;
      type X_Window_Attributes_Mask is mod 2 ** Integer'Size;
      type Window_Class             is (Copy_From_Parent, Input_Output, Input_Only);
      type X_Event_Mask             is mod 2 ** Long_Integer'Size;

      subtype Dimension is Short_Integer;
      subtype Pixel     is Long_Integer;
      subtype Position  is Short_Integer;

      -- An extremely abbreviated version of the XMapEvent structure.
      type Map_Event_Data is record
         Event_Type : Integer;
         Pad        : Padding;
      end record;

      -- An extremely abbreviated version of the XSetWindowAttributes
      -- structure, containing only the fields we care about.
      --
      -- NOTE: offset multiplier values differ between 32-bit and 64-bit
      -- systems since on 32-bit systems long size equals int size and the
      -- record has no padding.  The byte and bit widths come from Internal.
      Start_32 : constant := 10;
      Start_64 : constant :=  9;
      Start    : constant := (Is_32 * Start_32) + (Is_64 * Start_64);
      type X_Set_Window_Attributes is record
         Event_Mask  : X_Event_Mask := 0;
         Colormap    : Colormap_ID  := 0;
      end record;
      for X_Set_Window_Attributes use record
         Event_Mask  at (Start + 0) * Long_Bytes range 0 .. Long_Bits;
         Colormap    at (Start + 3) * Long_Bytes range 0 .. Long_Bits;
      end record;

      -- Xlib functions needed only by Create
      function X_Create_Colormap (Display : Display_Pointer;
                                  Window  : GLX_Drawable;
                                  Visual  : System.Address;
                                  Alloc   : Alloc_Mode)
      return Colormap_ID;
      pragma Import (C, X_Create_Colormap, "XCreateColormap");

      function X_Create_Window (Display      : Display_Pointer;
                                Parent       : GLX_Drawable;
                                X            : Position;
                                Y            : Position;
                                Width        : Dimension;
                                Height       : Dimension;
                                Border_Width : Natural;
                                Depth        : Screen_Depth;
                                Class        : Window_Class;
                                Visual       : System.Address;
                                Valuemask    : X_Window_Attributes_Mask;
                                Attributes   : System.Address)
      return GLX_Drawable;
      pragma Import (C, X_Create_Window, "XCreateWindow");

      function X_Default_Screen (Display : Display_Pointer) return Screen_Number;
      pragma Import (C, X_Default_Screen, "XDefaultScreen");

      procedure X_Map_Window (Display : in Display_Pointer;   Window : in GLX_Drawable);
      pragma Import (C, X_Map_Window, "XMapWindow");

      function X_Open_Display (Display_Name : System.Address := System.Null_Address) return Display_Pointer;
      pragma Import (C, X_Open_Display, "XOpenDisplay");

      function X_Root_Window (Display : Display_Pointer;   Screen_Num : Screen_Number) return GLX_Drawable;
      pragma Import (C, X_Root_Window, "XRootWindow");

      procedure X_Set_WM_Protocols (Display   : in Display_Pointer;
                                    Window    : in GLX_Drawable;
                                    Protocols : in System.Address;
                                    Count     : in Integer);
      pragma Import (C, X_Set_WM_Protocols, "XSetWMProtocols");

      -- Xlib constants needed only by Create
      Configure_Event_Mask : constant X_Window_Attributes_Mask := 2#00_1000_0000_0000#;  -- 11th bit
      Configure_Colormap   : constant X_Window_Attributes_Mask := 2#10_0000_0000_0000#;  -- 13th bit
      X_Map_Notify         : constant := 19;  -- the one event we look for here

      -- Atom names
      WM_Del          : String := "WM_DELETE_WINDOW" & ASCII.NUL;

      ------------------------------------------------------------------------

      -- GLX types needed only by Create

      -- This should be more space than we'll ever need, allowing a value for
      -- every attr (which not all of them have), and adding 2 for our "extra"
      -- values of RGBA and double-buffered, which are (or at least can be)
      -- set separately
      Max_GLX_Attributes : constant := (Context_Attribute_Name'Pos (Context_Attribute_Name'Last) + 1) * 2 + 2;

      type GLX_Attribute_List     is array (1 .. Max_GLX_Attributes) of Integer;
      type GLX_Attribute_List_Ptr is new System.Address;

      -- GLX functions needed only by Create
      function GLX_Choose_Visual (Display        : Display_Pointer;
                                  Screen         : Screen_Number;
                                  Attribute_List : GLX_Attribute_List_Ptr)
      return X_Visual_Info_Pointer;
      pragma Import (C, GLX_Choose_Visual, "glXChooseVisual");

      ------------------------------------------------------------------------

      -- Event masks
      type Event_Mask_Table is array (Wanted_Event) of X_Event_Mask;
      Event_Masks : constant Event_Mask_Table :=
         (Want_Key_Press       => 2#0000_0000_0000_0000_0000_0001#,
          Want_Key_Release     => 2#0000_0000_0000_0000_0000_0010#,
          Want_Button_Press    => 2#0000_0000_0000_0000_0000_0100#,
          Want_Button_Release  => 2#0000_0000_0000_0000_0000_1000#,
          Want_Window_Enter    => 2#0000_0000_0000_0000_0001_0000#,
          Want_Window_Leave    => 2#0000_0000_0000_0000_0010_0000#,
          Want_Pointer_Move    => 2#0000_0000_0000_0000_0100_0000#,
          Want_Pointer_Drag    => 2#0000_0000_0010_0000_0000_0000#,
          Want_Exposure        => 2#0000_0000_1000_0000_0000_0000#,
          Want_Focus_Change    => 2#0010_0000_0000_0000_0000_0000#
         );
      Structure_Notify_Mask : constant X_Event_Mask := 2#0000_0010_0000_0000_0000_0000#;  -- 17th bit, always want this one

      -- Variables used in Create
      Con_Attributes : GLX_Attribute_List := (others => Context_Attribute_Name'Pos (Attr_None));
      Con_Attr_Index : Positive := Con_Attributes'First;
      Our_Context    : GLX_Context;
      Did            : Bool;
      Display        : Display_Pointer;
      Mapped         : Map_Event_Data;
      Our_Parent     : GLX_Drawable;
      Visual         : X_Visual_Info_Pointer;
      Win_Attributes : X_Set_Window_Attributes;
      Window         : GLX_Drawable;

      ------------------------------------------------------------------------

      -- Choose an X visual, either from an explicit ID given in the
      -- LUMEN_VISUAL_ID environment variable, or by asking GLX to pick one.
      procedure Choose_Visual is

         ---------------------------------------------------------------------

         use type System.Address;

         ---------------------------------------------------------------------

         Visual_ID_EV     : constant String := "LUMEN_VISUAL_ID";
         GLX_FB_Config_ID : constant := 16#8013#;  -- from glx.h

         ---------------------------------------------------------------------

         type Int_Ptr is access all Integer;  -- used to simulate "out" param for C function
         type FB_Config_Ptr is access all System.Address;  -- actually an array, but only ever one element

         ---------------------------------------------------------------------

         -- GLX functions needed only by Choose_Visual, and then only when an
         -- explicit visual ID is given in an environment variable
         function GLX_Choose_FB_Config (Display        : Display_Pointer;
                                        Screen         : Screen_Number;
                                        Attribute_List : GLX_Attribute_List_Ptr;
                                        Num_Found      : Int_Ptr)
         return FB_Config_Ptr;
         pragma Import (C, GLX_Choose_FB_Config, "glXChooseFBConfig");

         function GLX_Get_Visual_From_FB_Config (Display : Display_Pointer;
                                                 Config  : System.Address)
         return X_Visual_Info_Pointer;
         pragma Import (C, GLX_Get_Visual_From_FB_Config, "glXGetVisualFromFBConfig");

         ---------------------------------------------------------------------

         ID    : Visual_ID;
         Found : aliased Integer;
         FB    : FB_Config_Ptr;

         ---------------------------------------------------------------------

      begin  -- Choose_Visual

         -- See if an explicit ID was given
         if Ada.Environment_Variables.Exists (Visual_ID_EV) then
            begin
               -- Ugly hack to convert hex value
               ID := Visual_ID'Value ("16#" & Ada.Environment_Variables.Value (Visual_ID_EV) & "#");
            exception
               when others =>
                  raise Invalid_ID;
            end;

            -- ID was given; try to use that ID to get the visual
            Con_Attributes (Con_Attr_Index) := GLX_FB_Config_ID;
            Con_Attr_Index := Con_Attr_Index + 1;
            Con_Attributes (Con_Attr_Index) := Integer (ID);
            Con_Attr_Index := Con_Attr_Index + 1;

            Found := 9;
            FB := GLX_Choose_FB_Config (Display, X_Default_Screen (Display), GLX_Attribute_List_Ptr (Con_Attributes'Address),
                                        Found'Access);
            if FB = null then
               raise Not_Available;
            end if;

            Visual := GLX_Get_Visual_From_FB_Config (Display, FB.all);
         else

            -- No explicit ID given, so ask GLX to pick one.  Set up the
            -- attributes array (first putting in our separately-specified
            -- ones if given) and use it to get an appropriate visual.
            if Depth = True_Color then
               Con_Attributes (Con_Attr_Index) := Context_Attribute_Name'Pos (Attr_RGBA);
               Con_Attr_Index := Con_Attr_Index + 1;
            end if;
            if Animated then
               Con_Attributes (Con_Attr_Index) := Context_Attribute_Name'Pos (Attr_Doublebuffer);
               Con_Attr_Index := Con_Attr_Index + 1;
            end if;
            for Attr in Attributes'Range loop
               Con_Attributes (Con_Attr_Index) := Context_Attribute_Name'Pos (Attributes (Attr).Name);
               Con_Attr_Index := Con_Attr_Index + 1;
               case Attributes (Attr).Name is
                  when Attr_None | Attr_Use_GL | Attr_RGBA | Attr_Doublebuffer | Attr_Stereo =>
                     null;  -- present or not, no value
                  when Attr_Level =>
                     Con_Attributes (Con_Attr_Index) := Attributes (Attr).Level;
                     Con_Attr_Index := Con_Attr_Index + 1;
                  when Attr_Buffer_Size | Attr_Aux_Buffers | Attr_Depth_Size | Attr_Stencil_Size |
                     Attr_Red_Size | Attr_Green_Size | Attr_Blue_Size | Attr_Alpha_Size |
                     Attr_Accum_Red_Size | Attr_Accum_Green_Size | Attr_Accum_Blue_Size | Attr_Accum_Alpha_Size =>
                     Con_Attributes (Con_Attr_Index) := Attributes (Attr).Size;
                     Con_Attr_Index := Con_Attr_Index + 1;
               end case;
            end loop;
            Visual := GLX_Choose_Visual (Display, X_Default_Screen (Display), GLX_Attribute_List_Ptr (Con_Attributes'Address));
         end if;
      end Choose_Visual;

      ------------------------------------------------------------------------

   begin  -- Create

      -- Connect to the X server
      Display := X_Open_Display;
      if Display = Null_Display_Pointer then
         raise Connection_Failed;
      end if;

      -- Choose a visual to use
      Choose_Visual;

      -- Make sure we actually found a visual to use
      if Visual = null then
         raise Not_Available;
      end if;

      -- Pick the parent window to use
      if Parent = No_Window then
         Our_Parent := X_Root_Window (Display, Visual.Screen);
      else
         Our_Parent := Parent.Window;
      end if;

      -- Build the event mask as requested by the caller
      Win_Attributes.Event_Mask := Structure_Notify_Mask;
      for E in Wanted_Event loop
         if Events (E) then
            Win_Attributes.Event_Mask := Win_Attributes.Event_Mask or Event_Masks (E);
         end if;
      end loop;

      -- Create the window and map it
      Win_Attributes.Colormap := X_Create_Colormap (Display, Our_Parent, Visual.Visual, Alloc_None);
      Window := X_Create_Window (Display, Our_Parent, 0, 0, Dimension (Width), Dimension (Height), 0,
                                 Visual.Depth, Input_Output, Visual.Visual,
                                 Configure_Colormap or Configure_Event_Mask, Win_Attributes'Address);
      X_Map_Window (Display, Window);

      -- Wait for the window to be mapped
      loop
         X_Next_Event (Display, Mapped'Address);
         exit when Mapped.Event_Type = X_Map_Notify;
      end loop;

      -- Tell the window manager that we want the close button sent to us
      Delete_Window_Atom := X_Intern_Atom (Display, WM_Del'Address, 0);
      X_Set_WM_Protocols (Display, Window, Delete_Window_Atom'Address, 1);

      -- Figure out what we want to call the new window
      declare
         Application_Name : String := Ada.Directories.Simple_Name (Ada.Command_Line.Command_Name);
         App_Class_Name   : String := Application_Name;  -- converted to mixed case shortly
         Class_String     : System.Address;
         Instance_String  : System.Address;
         Name_Property    : X_Text_Property;
      begin
         GNAT.Case_Util.To_Mixed (App_Class_Name);

         -- Set the window name
         if Name'Length < 1 then
            Name_Property := (Application_Name'Address,
                              X_Intern_Atom (Display, String_Encoding'Address, 0),
                              Bits_8,
                              Application_Name'Length);
         else
            Name_Property := (Name'Address,
                              X_Intern_Atom (Display, String_Encoding'Address, 0),
                              Bits_8,
                              Name'Length);
         end if;
         X_Set_WM_Name (Display, Window, Name_Property'Address);

         -- Set the icon name
         if Icon_Name'Length < 1 then
            Name_Property := (Application_Name'Address,
                              X_Intern_Atom (Display, String_Encoding'Address, 0),
                              Bits_8,
                              Application_Name'Length);
            X_Set_Icon_Name (Display, Window, Application_Name'Address);
         else
            Name_Property := (Icon_Name'Address,
                              X_Intern_Atom (Display, String_Encoding'Address, 0),
                              Bits_8,
                              Name'Length);
            X_Set_Icon_Name (Display, Window, Icon_Name'Address);
         end if;
         X_Set_WM_Icon_Name (Display, Window, Name_Property'Address);

         -- Set the class and instance names
         if Class_Name'Length < 1 then
            Class_String := App_Class_Name'Address;
         else
            Class_String := Class_Name'Address;
         end if;
         if Instance_Name'Length < 1 then
            Instance_String := Application_Name'Address;
         else
            Instance_String := Instance_Name'Address;
         end if;
         X_Set_Class_Hint (Display, Window, (Class_String, Instance_String));
      end;

      -- Connect the OpenGL context to the new X window
      if Context = No_Context then
         Our_Context := GLX_Create_Context (Display, Visual, GLX_Context (System.Null_Address),
                                            Bool (Direct));
      else
         Our_Context := Context;
      end if;
      if Our_Context = Internal.Null_Context then
         raise Context_Failed with "Cannot create OpenGL context";
      end if;
      Did := GLX_Make_Current (Display, Window, Our_Context);
      if not Did then
         raise Context_Failed with "Cannot make OpenGL context current";
      end if;

      -- Return the results
      Win := new Window_Info'(Display     => Display,
                              Window      => Window,
                              Visual      => Visual,
                              Width       => Width,
                              Height      => Height,
                              Prior_Frame => Never,
                              App_Start   => Ada.Calendar.Clock,
                              Last_Start  => Ada.Calendar.Clock,
                              App_Frames  => 0,
                              Last_Frames => 0,
                              SPF         => 0.0,
                              Context     => Our_Context,
                              Looping     => True);
   end Create;

   ---------------------------------------------------------------------------

   -- Destroy a native window, including its current rendering context.
   procedure Destroy (Win : in out Handle) is

      procedure X_Destroy_Window (Display : in Display_Pointer;   Window : in GLX_Drawable);
      pragma Import (C, X_Destroy_Window, "XDestroyWindow");

      procedure Free is new Ada.Unchecked_Deallocation (Window_Info, Handle);

   begin  -- Destroy
      X_Destroy_Window (Win.Display, Win.Window);
      Free (Win);
   end Destroy;

   ---------------------------------------------------------------------------

   -- Set various textual names associated with a window.  Null string means
   -- leave the current value unchanged.  In the case of class and instance
   -- names, both must be given to change either one.
   procedure Set_Names (Win           : in Handle;
                        Name          : in String           := "";
                        Icon_Name     : in String           := "";
                        Class_Name    : in String           := "";
                        Instance_Name : in String           := "") is

      Name_Property : X_Text_Property;

   begin  -- Set_Names

      -- Set the window name if one was given
      if Name'Length >= 1 then
         Name_Property := (Name'Address,
                           X_Intern_Atom (Win.Display, String_Encoding'Address, 0),
                           Bits_8,
                           Name'Length);
         X_Set_WM_Name (Win.Display, Win.Window, Name_Property'Address);
      end if;

      -- Set the icon name if one was given
      if Icon_Name'Length >= 1 then
         X_Set_Icon_Name (Win.Display, Win.Window, Icon_Name'Address);
         Name_Property := (Icon_Name'Address,
                           X_Intern_Atom (Win.Display, String_Encoding'Address, 0),
                           Bits_8,
                           Name'Length);
         X_Set_WM_Icon_Name (Win.Display, Win.Window, Name_Property'Address);
      end if;

      -- Set the class and instance names if they were both given
      if Class_Name'Length >= 1 and Instance_Name'Length >= 1 then
         X_Set_Class_Hint (Win.Display, Win.Window, (Class_Name'Address, Instance_Name'Address));
      end if;
   end Set_Names;

   ---------------------------------------------------------------------------

   -- Create an OpenGL rendering context; needed only when you want a second
   -- or subsequent context for a window, since Create makes one to start
   -- with
   function Create_Context (Win    : in Handle;
                            Direct : in Boolean := True)
   return Context_Handle is
   begin  -- Create_Context
      return GLX_Create_Context (Win.Display, Win.Visual, GLX_Context (System.Null_Address),
                                 Bool (Direct));
   end Create_Context;

   ---------------------------------------------------------------------------

   -- Destroy an OpenGL rendering context
   procedure Destroy_Context (Win : in out Handle) is

      procedure GLX_Destroy_Context (Display : in Display_Pointer;
                                     Context : GLX_Context);
      pragma Import (C, GLX_Destroy_Context, "glXDestroyContext");

   begin  -- Destroy_Context
      GLX_Destroy_Context (Win.Display, Win.Context);
      Win.Context := No_Context;
   end Destroy_Context;

   ---------------------------------------------------------------------------

   -- Select a window to use for subsequent OpenGL calls
   procedure Make_Current (Win : in Handle) is
   begin  -- Make_Current
      if not GLX_Make_Current (Win.Display, Win.Window, Win.Context) then
         raise Context_Failed with "Cannot make given OpenGL context current";
      end if;
   end Make_Current;

   ---------------------------------------------------------------------------

   -- Make a rendering context the current one for a window
   procedure Set_Context (Win     : in out Handle;
                          Context : in     Context_Handle) is
   begin  -- Set_Context
      if not GLX_Make_Current (Win.Display, Win.Window, Context) then
         Win.Context := Context;
      else
         raise Context_Failed with "Cannot select given OpenGL context";
      end if;
   end Set_Context;

   ---------------------------------------------------------------------------

   -- Promotes the back buffer to front; only valid if the window is double
   -- buffered, meaning Animated was true when the window was created.  Useful
   -- for smooth animation.
   procedure Swap (Win : in Handle) is

      procedure GLX_Swap_Buffers (Display : in Display_Pointer;   Window : in GLX_Drawable);
      pragma Import (C, GLX_Swap_Buffers, "glXSwapBuffers");

   begin  -- Swap
      GLX_Swap_Buffers (Win.Display, Win.Window);
   end Swap;

   ---------------------------------------------------------------------------

   -- Return current window width
   function Width (Win : in Handle) return Natural is
   begin  -- Width
      return Win.Width;
   end Width;

   ---------------------------------------------------------------------------

   -- Return current window width
   function Height (Win : in Handle) return Natural is
   begin  -- Height
      return Win.Height;
   end Height;

   ---------------------------------------------------------------------------

end Lumen.Window;
