with eGL.Pointers;


package eGL.NativeDisplayType
is

   -- Item
   --
   subtype Item is eGL.Pointers.Display_Pointer;

   type Item_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.NativeDisplayType.Item;


   -- Pointer
   --
   type Pointer is access all eGL.NativeDisplayType.Item;

   type Pointer_array is
     array (Interfaces.C.size_t range <>)
            of aliased eGL.NativeDisplayType.Pointer;


end eGL.NativeDisplayType;
