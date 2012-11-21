with eGL;
--       Xcb.Pointers;


package opengl.Display.privvy
--
--
--
is

--     function to_Xcb (Self : in Display.item'Class) return xcb.Pointers.Display_Pointer;
   function to_eGL (Self : in Display.item'Class) return eGL.EGLDisplay;


end opengl.Display.privvy;


