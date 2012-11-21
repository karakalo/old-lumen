with opengl.Display.privvy,
     opengl.surface_Profile.privvy,
     opengl.Surface.privvy;

with egl.Binding;   use egl.Binding;
with System;        use System;



package body openGL.Context
is


   procedure define (Self : in out Item;   the_Display         : access opengl.Display.item'Class;
                                           the_surface_Profile : in     opengl.surface_Profile.item)
   is
      use EGL, opengl.Display.privvy, opengl.surface_Profile.privvy;

      contextAttribs : EGLint_array := (EGL_CONTEXT_CLIENT_VERSION, 2,
                                        EGL_NONE);
   begin
      self.egl_Context := eglCreateContext (to_eGL (the_Display.all),
                                            to_eGL (the_surface_Profile),
                                            EGL_NO_CONTEXT,
                                            contextAttribs (contextAttribs'first)'unchecked_access);

      if self.egl_Context = EGL_NO_CONTEXT then
         raise opengl.Error with "unable to create an EGL Context";
      end if;

      self.Display := the_Display;
   end;






   procedure make_Current (Self : in Item;   read_Surface  : in opengl.Surface.item;
                                             write_Surface : in opengl.Surface.item)
   is
      use eGL, opengl.Display.privvy, opengl.Surface.privvy;
      use type EGLBoolean;

      Success : EGLBoolean := eglmakeCurrent (to_eGL (Self.Display.all),
                                              to_eGL (read_Surface), to_eGL (write_Surface),
                                              Self.egl_Context);
   begin
      if Success = EGL_FALSE then
         raise openGL.Error with "unable to make egl Context current";
      end if;
   end;





   function egl_Context_debug (Self : in Item'Class) return egl.EGLConfig
   is
   begin
      return self.egl_Context;
   end;


end openGL.Context;
