
package eGL.Pointers
is

   -- Display_Pointer
   --
   type Display_Pointer is access all eGL.Display;

   type Display_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.Display_Pointer;


   -- NativeWindowType_Pointer
   --
   type NativeWindowType_Pointer is access all eGL.NativeWindowType;

   type NativeWindowType_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.NativeWindowType_Pointer;


   -- NativePixmapType_Pointer
   --
   type NativePixmapType_Pointer is access all eGL.NativePixmapType;

   type NativePixmapType_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.NativePixmapType_Pointer;


   -- EGLint_Pointer
   --
   type EGLint_Pointer is access all eGL.EGLint;

   type EGLint_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLint_Pointer;


   -- EGLBoolean_Pointer
   --
   type EGLBoolean_Pointer is access all eGL.EGLBoolean;

   type EGLBoolean_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLBoolean_Pointer;


   -- EGLenum_Pointer
   --
   type EGLenum_Pointer is access all eGL.EGLenum;

   type EGLenum_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLenum_Pointer;


   -- EGLConfig_Pointer
   --
   type EGLConfig_Pointer is access all eGL.EGLConfig;

   type EGLConfig_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLConfig_Pointer;


   -- EGLContext_Pointer
   --
   type EGLContext_Pointer is access all eGL.EGLContext;

   type EGLContext_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLContext_Pointer;


   -- EGLDisplay_Pointer
   --
   type EGLDisplay_Pointer is access all eGL.EGLDisplay;

   type EGLDisplay_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLDisplay_Pointer;


   -- EGLSurface_Pointer
   --
   type EGLSurface_Pointer is access all eGL.EGLSurface;

   type EGLSurface_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLSurface_Pointer;


   -- EGLClientBuffer_Pointer
   --
   type EGLClientBuffer_Pointer is access all eGL.EGLClientBuffer;

   type EGLClientBuffer_Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.Pointers.EGLClientBuffer_Pointer;


end eGL.Pointers;