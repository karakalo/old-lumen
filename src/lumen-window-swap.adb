separate (lumen.Window)

procedure Swap (Win : in Window_Handle) is
begin
   Win.gl_Surface.swap_Buffers;
end Swap;

