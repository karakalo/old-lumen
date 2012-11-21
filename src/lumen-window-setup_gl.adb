separate (lumen.Window)

procedure setup_gl (Win : in out Window_Type;   Window_Id : in Natural)
is
begin
   Win.gl_Display := opengl.Display.Default;

   win.gl_Profile.define (Win.gl_Display'unchecked_Access,
                          desired => opengl.surface_Profile.default_Qualities);

   Win.gl_Surface.define (Win.gl_Profile,
                          Win.gl_Display,
                          Window_Id);

   Win.gl_Context.define (Win.gl_Display'unchecked_Access,
                          Win.gl_Profile);


   Win.gl_Context.make_Current (Win.gl_Surface, Win.gl_Surface);
end setup_gl;
