with opengl.surface_Profile,
     opengl.Display;

private
with EGL;


package opengl.Surface
--
--
--
is

   type Item  is tagged private;
   type Items is array (Positive range <>) of aliased Item;

   type View  is access all Item'class;
   type Views is array (Positive range <>) of View;



   procedure define (Self : in out Item;   surface_Profile : in opengl.surface_Profile.item'Class;
                                           Display         : in opengl.Display.item;
                                           Window_Id       : in Natural);



   --- Attributes
   --

   -- nil



   --- Operations
   --

   procedure swap_Buffers (Self : in Item);






private

   type Item is tagged
      record
         egl_Surface : egl.EGLSurface;
         Display     : openGL.Display.item;
      end record;

end opengl.Surface;
