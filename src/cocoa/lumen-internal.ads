with System;

with GL.CGL;

package Lumen.Internal is
   subtype GL_Context is GL.CGL.CGLContextObject;

   -- as all the windowing stuff is handled in LumenCocoa, don't care
   -- about the Window_Info members here
   type Window_Info is null record;

   Null_Context : constant GL_Context := System.Null_Address;
end Lumen.Internal;
