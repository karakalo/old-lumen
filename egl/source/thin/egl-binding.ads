with eGL.Pointers,
     eGL.NativeDisplayType,

     Interfaces.C.Strings;


package eGL.Binding
is

   function eglGetError return eGL.EGLint;

   function eglGetDisplay
     (display_id : in eGL.NativeDisplayType.Item)
      return       eGL.EGLDisplay;

   function eglInitialize
     (dpy   : in eGL.EGLDisplay;
      major : in eGL.Pointers.EGLint_Pointer;
      minor : in eGL.Pointers.EGLint_Pointer)
      return  eGL.EGLBoolean;

   function eglTerminate (dpy : in eGL.EGLDisplay) return eGL.EGLBoolean;

   function eglQueryString
     (dpy  : in eGL.EGLDisplay;
      name : in eGL.EGLint)
      return Interfaces.C.Strings.chars_ptr;

   function eglGetConfigs
     (dpy         : in eGL.EGLDisplay;
      configs     : in eGL.Pointers.EGLConfig_Pointer;
      config_size : in eGL.EGLint;
      num_config  : in eGL.Pointers.EGLint_Pointer)
      return        eGL.EGLBoolean;

   function eglChooseConfig
     (dpy         : in eGL.EGLDisplay;
      attrib_list : in eGL.Pointers.EGLint_Pointer;
      configs     : in eGL.Pointers.EGLConfig_Pointer;
      config_size : in eGL.EGLint;
      num_config  : in eGL.Pointers.EGLint_Pointer)
      return        eGL.EGLBoolean;

   function eglGetConfigAttrib
     (dpy       : in eGL.EGLDisplay;
      config    : in eGL.EGLConfig;
      attribute : in eGL.EGLint;
      value     : in eGL.Pointers.EGLint_Pointer)
      return      eGL.EGLBoolean;

   function eglCreateWindowSurface
     (dpy         : in eGL.EGLDisplay;
      config      : in eGL.EGLConfig;
      win         : in eGL.NativeWindowType;
      attrib_list : in eGL.Pointers.EGLint_Pointer)
      return        eGL.EGLSurface;

   function eglCreatePbufferSurface
     (dpy         : in eGL.EGLDisplay;
      config      : in eGL.EGLConfig;
      attrib_list : in eGL.Pointers.EGLint_Pointer)
      return        eGL.EGLSurface;

   function eglCreatePixmapSurface
     (dpy         : in eGL.EGLDisplay;
      config      : in eGL.EGLConfig;
      pixmap      : in eGL.NativePixmapType;
      attrib_list : in eGL.Pointers.EGLint_Pointer)
      return        eGL.EGLSurface;

   function eglDestroySurface
     (dpy     : in eGL.EGLDisplay;
      surface : in eGL.EGLSurface)
      return    eGL.EGLBoolean;

   function eglQuerySurface
     (dpy       : in eGL.EGLDisplay;
      surface   : in eGL.EGLSurface;
      attribute : in eGL.EGLint;
      value     : in eGL.Pointers.EGLint_Pointer)
      return      eGL.EGLBoolean;

   function eglBindAPI (api : in eGL.EGLenum) return eGL.EGLBoolean;

   function eglQueryAPI return  eGL.EGLenum;

   function eglWaitClient return  eGL.EGLBoolean;

   function eglReleaseThread return  eGL.EGLBoolean;

   function eglCreatePbufferFromClientBuffer
     (dpy         : in eGL.EGLDisplay;
      buftype     : in eGL.EGLenum;
      buffer      : in eGL.EGLClientBuffer;
      config      : in eGL.EGLConfig;
      attrib_list : in eGL.Pointers.EGLint_Pointer)
      return        eGL.EGLSurface;

   function eglSurfaceAttrib
     (dpy       : in eGL.EGLDisplay;
      surface   : in eGL.EGLSurface;
      attribute : in eGL.EGLint;
      value     : in eGL.EGLint)
      return      eGL.EGLBoolean;

   function eglBindTexImage
     (dpy     : in eGL.EGLDisplay;
      surface : in eGL.EGLSurface;
      buffer  : in eGL.EGLint)
      return    eGL.EGLBoolean;

   function eglReleaseTexImage
     (dpy     : in eGL.EGLDisplay;
      surface : in eGL.EGLSurface;
      buffer  : in eGL.EGLint)
      return    eGL.EGLBoolean;

   function eglSwapInterval
     (dpy      : in eGL.EGLDisplay;
      interval : in eGL.EGLint)
      return     eGL.EGLBoolean;

   function eglCreateContext
     (dpy           : in eGL.EGLDisplay;
      config        : in eGL.EGLConfig;
      share_context : in eGL.EGLContext;
      attrib_list   : in eGL.Pointers.EGLint_Pointer)
      return          eGL.EGLContext;

   function eglDestroyContext
     (dpy  : in eGL.EGLDisplay;
      ctx  : in eGL.EGLContext)
      return eGL.EGLBoolean;

   function eglMakeCurrent
     (dpy  : in eGL.EGLDisplay;
      draw : in eGL.EGLSurface;
      read : in eGL.EGLSurface;
      ctx  : in eGL.EGLContext)
      return eGL.EGLBoolean;

   function eglGetCurrentContext return  eGL.EGLContext;

   function eglGetCurrentSurface
     (readdraw : in eGL.EGLint)
      return     eGL.EGLSurface;

   function eglGetCurrentDisplay return  eGL.EGLDisplay;

   function eglQueryContext
     (dpy       : in eGL.EGLDisplay;
      ctx       : in eGL.EGLContext;
      attribute : in eGL.EGLint;
      value     : in eGL.Pointers.EGLint_Pointer)
      return      eGL.EGLBoolean;

   function eglWaitGL return  eGL.EGLBoolean;

   function eglWaitNative (engine : in eGL.EGLint) return eGL.EGLBoolean;

   function eglSwapBuffers
     (dpy     : in eGL.EGLDisplay;
      surface : in eGL.EGLSurface)
      return    eGL.EGLBoolean;

   function eglCopyBuffers
     (dpy     : in eGL.EGLDisplay;
      surface : in eGL.EGLSurface;
      target  : in eGL.NativePixmapType)
      return    eGL.EGLBoolean;

   function eglGetProcAddress
     (procname : in Interfaces.C.Strings.chars_ptr)
      return     void_ptr;

   function egl_DEFAULT_DISPLAY return access eGL.Display;

   function egl_NO_CONTEXT return  eGL.EGLContext;

   function egl_NO_DISPLAY return  eGL.EGLDisplay;

   function egl_NO_SURFACE return  eGL.EGLSurface;

   function egl_DONT_CARE return  eGL.EGLint;





private

   pragma Import (C, eglGetError);
   pragma Import (C, eglGetDisplay,          "Ada_eglGetDisplay");
   pragma Import (C, eglInitialize,          "Ada_eglInitialize");
   pragma Import (C, eglTerminate);
   pragma Import (C, eglQueryString);
   pragma Import (C, eglGetConfigs,          "Ada_eglGetConfigs");
   pragma Import (C, eglChooseConfig,        "Ada_eglChooseConfig");
   pragma Import (C, eglGetConfigAttrib,     "Ada_eglGetConfigAttrib");
   pragma Import (C, eglCreateWindowSurface, "Ada_eglCreateWindowSurface");
   pragma Import (C, eglCreatePbufferSurface);
   pragma Import (C, eglCreatePixmapSurface);
   pragma Import (C, eglDestroySurface);
   pragma Import (C, eglQuerySurface);
   pragma Import (C, eglBindAPI);
   pragma Import (C, eglQueryAPI);
   pragma Import (C, eglWaitClient);
   pragma Import (C, eglReleaseThread);
   pragma Import (C, eglCreatePbufferFromClientBuffer);
   pragma Import (C, eglSurfaceAttrib);
   pragma Import (C, eglBindTexImage);
   pragma Import (C, eglReleaseTexImage);
   pragma Import (C, eglSwapInterval);
   pragma Import (C, eglCreateContext,      "Ada_eglCreateContext");
   pragma Import (C, eglDestroyContext);
   pragma Import (C, eglMakeCurrent,        "Ada_eglMakeCurrent");
   pragma Import (C, eglGetCurrentContext);
   pragma Import (C, eglGetCurrentSurface);
   pragma Import (C, eglGetCurrentDisplay);
   pragma Import (C, eglQueryContext);
   pragma Import (C, eglWaitGL);
   pragma Import (C, eglWaitNative);
   pragma Import (C, eglSwapBuffers,        "Ada_eglSwapBuffers");
   pragma Import (C, eglCopyBuffers);
   pragma Import (C, eglGetProcAddress);
   pragma Import (C, egl_DEFAULT_DISPLAY,   "Ada_egl_DEFAULT_DISPLAY");
   pragma Import (C, egl_NO_CONTEXT,        "Ada_egl_NO_CONTEXT");
   pragma Import (C, egl_NO_DISPLAY,        "Ada_egl_NO_DISPLAY");
   pragma Import (C, egl_NO_SURFACE,        "Ada_egl_NO_SURFACE");
   pragma Import (C, egl_DONT_CARE,         "Ada_egl_DONT_CARE");

end eGL.Binding;
