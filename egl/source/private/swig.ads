
with interfaces.C;
with System;


package Swig
--
-- contains Swig related C type definitions not found in interfaces.C family.
--
is
   pragma pure;


   subtype void                  is System.Address;
   subtype void_ptr              is System.Address;

   subtype opaque_structure      is System.Address;
   subtype incomplete_class      is System.Address;


   subtype long_Long             is long_long_Integer;
   type    unsigned_long_Long    is mod 2 ** 64;

   type    intptr_t              is range -(2 ** (Standard'Address_Size - Integer'(1))) .. +(2 ** (Standard'Address_Size - Integer'(1)) - 1);
   type   uintptr_t              is mod 2 ** Standard'Address_Size;


   subtype int8_t                is interfaces.Integer_8;
   subtype int16_t               is interfaces.Integer_16;
   subtype int32_t               is interfaces.Integer_32;
   subtype int64_t               is interfaces.Integer_64;

   subtype uint8_t               is interfaces.unSigned_8;
   subtype uint16_t              is interfaces.unSigned_16;
   subtype uint32_t              is interfaces.unSigned_32;
   subtype uint64_t              is interfaces.unSigned_64;

   subtype bool                  is interfaces.c.plain_char;


   type void_ptr_Array           is array (interfaces.c.size_t range <>) of aliased swig.void_ptr;
   type size_t_Array             is array (interfaces.c.size_t range <>) of aliased interfaces.c.Size_t;
   type bool_Array               is array (interfaces.c.size_t range <>) of aliased swig.bool;

   type signed_char_Array        is array (interfaces.c.size_t range <>) of aliased interfaces.c.signed_Char;
   type unsigned_char_Array      is array (interfaces.c.size_t range <>) of aliased interfaces.c.unsigned_Char;

   type short_Array              is array (interfaces.c.size_t range <>) of aliased interfaces.c.Short;
   type int_Array                is array (interfaces.c.size_t range <>) of aliased interfaces.c.Int;
   type long_Array               is array (interfaces.c.size_t range <>) of aliased interfaces.c.Long;
   type long_long_Array          is array (interfaces.c.size_t range <>) of aliased swig.long_Long;

   type unsigned_short_Array     is array (interfaces.c.size_t range <>) of aliased interfaces.c.unsigned_Short;
   type unsigned_Array           is array (interfaces.c.size_t range <>) of aliased interfaces.c.Unsigned;
   type unsigned_long_Array      is array (interfaces.c.size_t range <>) of aliased interfaces.c.unsigned_Long;
   type unsigned_long_long_Array is array (interfaces.c.size_t range <>) of aliased swig.unsigned_long_Long;


   type int8_t_Array             is array (interfaces.c.size_t range <>) of aliased swig.int8_t;
   type int16_t_Array            is array (interfaces.c.size_t range <>) of aliased swig.int16_t;
   type int32_t_Array            is array (interfaces.c.size_t range <>) of aliased swig.int32_t;
   type int64_t_Array            is array (interfaces.c.size_t range <>) of aliased swig.int64_t;

   type uint8_t_Array            is array (interfaces.c.size_t range <>) of aliased swig.uint8_t;
   type uint16_t_Array           is array (interfaces.c.size_t range <>) of aliased swig.uint16_t;
   type uint32_t_Array           is array (interfaces.c.size_t range <>) of aliased swig.uint32_t;
   type uint64_t_Array           is array (interfaces.c.size_t range <>) of aliased swig.uint64_t;


   type float_Array              is array (interfaces.c.size_t range <>) of aliased interfaces.c.c_Float;
   type double_Array             is array (interfaces.c.size_t range <>) of aliased interfaces.c.Double;
   type long_double_Array        is array (interfaces.c.size_t range <>) of aliased interfaces.c.long_Double;

end Swig;
