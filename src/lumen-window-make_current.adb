separate (lumen.Window)

procedure Make_Current (Win : in Window_Handle) is
begin
   Win.gl_Context.make_Current (Win.gl_Surface, 
                                Win.gl_Surface);
end Make_Current;
