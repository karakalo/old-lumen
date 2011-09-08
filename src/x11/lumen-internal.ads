
-- Lumen.Internal -- Internal declarations not intended for user applications
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

-- Environment
with System;
with Ada.Calendar;

with GL.GLX;
use GL.GLX;

package Lumen.Internal is

   subtype GL_Context is GL.GLX.GLX_Context;
   Null_Context : constant GL_Context := GL.GLX.Null_Context;

   -- Xlib stuff needed for our window info record
   type Atom            is new Long_Integer;
   Null_Display_Pointer : constant Display_Pointer := Display_Pointer (System.Null_Address);

   -- A time that won't ever happen during the execution of a Lumen app
   Never : constant Ada.Calendar.Time := Ada.Calendar.Time_Of (Year  => Ada.Calendar.Year_Number'First,
                                                               Month => Ada.Calendar.Month_Number'First,
                                                               Day   => Ada.Calendar.Day_Number'First);
   -- The native window type
   type Window_Info is record
      Display     : Display_Pointer       := Null_Display_Pointer;
      Window      : GLX_Drawable          := 0;
      Visual      : X_Visual_Info_Pointer := null;
      Width       : Natural               := 0;
      Height      : Natural               := 0;
      Prior_Frame : Ada.Calendar.Time     := Never;
      App_Start   : Ada.Calendar.Time     := Never;
      Last_Start  : Ada.Calendar.Time     := Never;
      App_Frames  : Long_Integer          := 0;
      Last_Frames : Long_Integer          := 0;
      SPF         : Duration              := 0.0;
      Context     : GLX_Context           := Null_Context;
      Looping     : Boolean               := True;
   end record;

   ---------------------------------------------------------------------------

   -- Our "delete window" atom value
   Delete_Window_Atom : Atom;

   ---------------------------------------------------------------------------

   -- Binding to XNextEvent, used by Window for mapping notify events, and by
   -- Events for everything else
   procedure X_Next_Event (Display : in Display_Pointer;
                           Event   : in System.Address);
   pragma Import (C, X_Next_Event, "XNextEvent");

   ---------------------------------------------------------------------------

   -- Values used to compute record rep clause values that are portable
   -- between 32- and 64-bit systems
   Is_32      : constant := Boolean'Pos (System.Word_Size = 32);
   Is_64      : constant := 1 - Is_32;
   Word_Bytes : constant := Integer'Size / System.Storage_Unit;
   Word_Bits  : constant := Integer'Size - 1;
   Long_Bytes : constant := Long_Integer'Size / System.Storage_Unit;
   Long_Bits  : constant := Long_Integer'Size - 1;

   ---------------------------------------------------------------------------

   -- The maximum length of an event data record
   type Padding is array (1 .. 23) of Long_Integer;

   ---------------------------------------------------------------------------

end Lumen.Internal;
