module cc

import math.vec
import gg

pub struct CCConfig {
pub mut:
	init_fn ?gg.FNCb
	frame_fn ?gg.FNCb
}

// ---------------

@[heap]
pub struct CC {
mut:
	config CCConfig
	data_ptr voidptr

pub mut:
	gg &gg.Context = unsafe { nil }
}

// ----------------

struct InitialPreference {
mut:
	size ?vec.Vec2[int]
	init_fn ?gg.FNCb
	bg_color ?gg.Color
}

@[heap]
struct CCContext {
mut:
	cc &CC = unsafe { nil }
	pref InitialPreference
}

fn (c &CC) init(mut _ CC) {
	if c.config.init_fn != none {
		c.config.init_fn(c)
	}
}

fn (c &CC) frame(mut _ CC) {
	c.gg.begin()
	if c.config.frame_fn != none {
		c.config.frame_fn(c)
	}
	c.gg.end()
}

pub fn (c &CC) data[T]() &T {
	return unsafe { c.data_ptr }
}

pub fn (mut c CC) set_data(ptr voidptr) {
	c.data_ptr = ptr
}

fn (mut c CC) cleanup() {
}

fn setup(config CCConfig) {
	mut ctx := context()

	mut c := &CC{
		config: config
	}

	mut w := 400
	mut h := 400
	mut bg_color := gg.white

	if ctx.pref.size != none {
		w = ctx.pref.size.x
		h = ctx.pref.size.y
	}

	if ctx.pref.bg_color != none {
		bg_color = ctx.pref.bg_color
	}

	if c.config.init_fn == none && ctx.pref.init_fn != none {
		c.config.init_fn = ctx.pref.init_fn
	}

	c.gg = gg.new_context(
		bg_color:      bg_color
		width:         w
		height:        h
		create_window: true
		window_title:  'Canvas'
		init_fn:       c.init
		frame_fn:      c.frame
		cleanup_fn:    c.cleanup
		user_data:     c
	)

	ctx.cc = c

	c.gg.run()
}

// get context
fn context() &CCContext {
	unsafe { 
		mut static ctx := voidptr(0)
		if ctx == nil {
			ctx = &CCContext{} 
		}
		return ctx
	}
}

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.size = vec.vec2[int](w, h)
	}else{
		ctx.cc.gg.resize(w, h)
	}
}

pub fn background(c gg.Color) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.bg_color = c
	}else{
		ctx.cc.gg.set_bg_color(c)
	}
}

pub fn (c &CC) text(msg string, x int, y int) {
	c.gg.draw_text_def(x, y, msg)
}

pub fn init(init_fn fn (voidptr)) {
	mut ctx := context()
	ctx.pref.init_fn = init_fn
}

pub fn run(frame_fn fn (voidptr)) {
	setup(CCConfig {
		frame_fn: frame_fn
	})
}