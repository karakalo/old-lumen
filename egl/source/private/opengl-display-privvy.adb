

package body opengl.Display.privvy
is


   function to_eGL (Self : in Display.item'Class) return eGL.EGLDisplay
   is
   begin
      return Self.Thin;
   end;



--     function to_Xcb (Self : in Display.item'Class) return xcb.Pointers.Display_Pointer
--     is
--     begin
--        return Self.xcb;
--     end;


end opengl.Display.privvy;


