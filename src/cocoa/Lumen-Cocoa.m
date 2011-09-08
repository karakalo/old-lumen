//  Copyright (c) 2011, Felix Krause <flyx@isobeef.org>
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#import "Lumen-Cocoa.h"

struct window_info {
	NSWindow *backend;
	NSOpenGLView *view;
	NSOpenGLContext *context;
	CGLContextObj cglcontext;
};

struct event_info {
	// TODO
};

int luco_application_initialized = 0;


handle luco_create_window (handle parent,
						   int width,
						   int height, 
						   int wanted_events,
						   const char * name,
						   CGLContextObj context,
						   int direct,
						   int animated,
						   const int attributes[]) {
	// TODO: handle wanted_events, direct, animated, attributes
	
	if (!luco_application_initialized) {
		printf("initializing application\n");
		[NSApplication sharedApplication];
	}
	
	printf("initializing window\n");
	NSWindow *win = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, width, height)
												 styleMask:NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask
												   backing:NSBackingStoreBuffered defer:true];
	
	printf("initializing view\n");
	NSOpenGLView *view = [[NSOpenGLView alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
	
	printf("creating win_info\n");
	handle win_info = (handle)malloc(sizeof(struct window_info));
	
	(*win_info).backend = win;
	(*win_info).view = view;
	(*win_info).context = 0;
	
	printf("setting autoresizing mask\n");
	[view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	
	printf("setting title\n");
	[win setTitle:[NSString stringWithCString:name encoding: NSISOLatin1StringEncoding]];
	
	printf ("setting context\n");
	luco_set_context(win_info, context);
	
	printf("adding view to window\n");
	[[win contentView] addSubview:view];
	
	luco_make_current(win_info);
	
	return win_info;
}

extern void luco_destroy_window (handle window) {
	[(*window).backend release];
	free((void*)window);
}

extern void luco_set_names (handle window, const char * name, const char * icon_name) {
	[(*window).backend setTitle:[NSString stringWithCString:name encoding:NSISOLatin1StringEncoding]];
}

extern void luco_make_current (handle window) {
	[(*window).backend makeKeyAndOrderFront:nil];
	if ([(*window).context view] != (*window).view) {
		[(*window).context setView:(*window).view];
	}
}

extern void luco_set_context (handle window, CGLContextObj context) {
	NSOpenGLContext *glcontext;
	CGLContextObj cglcontext;
	CGLPixelFormatObj cglpixelformat;
	int terminator = 0;
	int npix;
	
	printf("enter luco_set_context\n");
	
	if (context == 0) {
		printf("no valid context given, creating own\n");
		CGLChoosePixelFormat((CGLPixelFormatAttribute*)&terminator, &cglpixelformat, &npix);
		CGLCreateContext(cglpixelformat, NULL, &cglcontext);
	} else {
		printf("valid context given\n");
	}
	(*window).cglcontext = cglcontext;
	
	printf("creating NSOpenGLContext\n");
	glcontext = [[NSOpenGLContext alloc] initWithCGLContextObj:cglcontext];
	
	printf ("NSOpenGLContext created, linking to NSOpenGLView\n");
	[(*window).view setOpenGLContext:glcontext];
	
	if ((*window).context) {
		printf ("releasing old context\n");
		[(*window).context release];
	}
	
	(*window).context = glcontext;
	printf ("exiting luco_set_context\n");
}

extern void luco_swap (handle window) {
	CGLFlushDrawable((*window).cglcontext);
}

extern int luco_width (handle window) {
	return [[(*window).backend contentView] frame].size.width;
}

extern int luco_height (handle window) {
	return [[(*window).backend contentView] frame].size.height;
}