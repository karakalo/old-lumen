//
//  Lumen-Cocoa.h
//  Lumen-Cocoa
//
//  Created by Felix Krause on 07.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/OpenGL.h>
#import <Cocoa/Cocoa.h>

typedef struct window_info *handle;

typedef struct event_info *event;

typedef enum {
	KEY_PRESS      = 0x001,
	KEY_RELEASE    = 0x002,
	BUTTON_PRESS   = 0x004,
	BUTTON_RELEASE = 0x008,
	WINDOW_ENTER   = 0x010,
	WINDOW_LEAVE   = 0x020,
	POINTER_MOVE   = 0x040,
	POINTER_DRAG   = 0x080,
	EXPOSURE       = 0x100,
	FOCUS_CHANGE   = 0x200
} event_kind;

typedef enum {
	PSEUDO_COLOR = 0,
	TRUE_COLOR   = 1
} color_depth;

#define	ATTR_USE_GL           1
#define ATTR_BUFFER_SIZE      2
#define ATTR_LEVEL            3
#define ATTR_RBGA             4
#define ATTR_DOUBLEBUFFER     5
#define ATTR_STEREO           6
#define ATTR_AUX_BUFFERS      7
#define ATTR_RED_SIZE         8
#define ATTR_GREEN_SIZE       9
#define ATTR_BLUE_SIZE        10
#define ATTR_ALPHA_SIZE       11
#define ATTR_DEPTH_SIZE       12
#define ATTR_STENCIL_SIZE     13
#define ATTR_ACCUM_RED_SIZE   14
#define ATTR_ACCUM_GREEN_SIZE 15
#define ATTR_ACCUM_BLUE_SIZE  16
#define ATTR_ACCUM_ALPHA_SIZE 17

extern handle luco_create_window (handle parent, int width, int height, int wanted_events, const char * name, CGLContextObj context, int direct, int animated, const int attributes[]);

extern void luco_destroy_window (handle window);

extern void luco_set_names (handle window, const char * name, const char * icon_name);

extern void luco_make_current (handle window);

extern void luco_set_context (handle window, CGLContextObj context);

extern void luco_swap (handle window);

extern int luco_width (handle window);

extern int luco_height (handle window);