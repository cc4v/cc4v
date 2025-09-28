module cc

import math.vec
import gg

// @[heap]

struct CCContextConfig {
	frame_fn ?gg.FNCb
}

pub struct CC {
	config CCContextConfig

pub mut:
	gg &gg.Context = unsafe { nil }
}

@[heap]
struct CCContext {
pub mut:
	cc &CC = unsafe { nil }
	gg &gg.Context = unsafe { nil }
	// real_frame_fn ?gg.FNCb

mut:
	// is_running bool
	preferred_size ?vec.Vec2[int]
}

fn (mut ctx CCContext) frame(mut c CC) {
	ctx.gg.begin()
	if ctx.cc.config.frame_fn != none {
		ctx.cc.config.frame_fn(c)
	}
	ctx.gg.end()
}

fn (mut ctx CCContext) cleanup() {
}

// fn (mut ctx CCContext) init_context(config CCContextConfig) {
fn (mut ctx CCContext) setup(config CCContextConfig) {
// fn setup(config CCContextConfig) &CC {
	if unsafe { ctx.cc != nil } {
		return
	}

	ctx.cc = &CC{
		config: config
	}
	// mut c := &CC{}

	mut w := 600
	mut h := 600

	// if ctx.preferred_size != none {
	// 	w = ctx.preferred_size.x
	// 	h = ctx.preferred_size.y
	// }

	ctx.gg = gg.new_context(
		bg_color:      gg.white
		width:         w
		height:        h
		create_window: true
		window_title:  'Canvas'
		frame_fn:      ctx.frame
		cleanup_fn:    ctx.cleanup
		user_data:     ctx.cc
	)

	ctx.cc.gg = ctx.gg

	ctx.gg.run()

	// return ctx.cc
}

// get raw context
fn context() &CCContext {
	unsafe { 
		mut static ctx := voidptr(0)
		if ctx == nil {
			ctx = &CCContext{} 
		}
		return ctx
	}
}

// // get context for drawing
// fn drawing_context() &CCContext {
// 	mut ctx := context()

// 	if unsafe { ctx.cc == nil } {
// 		ctx.init_context()
// 	}

// 	return ctx
// }

fn init(mut c CC) {

}

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.preferred_size = vec.vec2[int](w, h)
	}else{
		ctx.gg.resize(w, h)
	}
}

pub fn (c &CC) text(msg string, x int, y int) {
	// mut ctx := drawing_context()
	c.gg.draw_text_def(x, y, msg)
}

pub fn run(frame_fn fn (voidptr)) {
	mut ctx := context()
	ctx.setup(CCContextConfig {
		frame_fn: frame_fn
	})
}

pub fn begin() {
	// mut ctx := context()
}

pub fn end() {
	// mut ctx := context()

	// if unsafe { ctx.cc == nil } {
	// 	ctx.gg.run()
	// }
}