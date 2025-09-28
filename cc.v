module cc

import math.vec
import gg

struct CCConfig {
	frame_fn ?gg.FNCb
}

@[heap]
pub struct CC {
	config CCConfig

pub mut:
	gg &gg.Context = unsafe { nil }
}

@[heap]
struct CCContext {
mut:
	cc &CC = unsafe { nil }
	preferred_size ?vec.Vec2[int]
}

fn (mut c CC) frame(mut _ CC) {
	c.gg.begin()
	if c.config.frame_fn != none {
		c.config.frame_fn(c)
	}
	c.gg.end()
}

fn (mut c CC) cleanup() {
}

fn setup(config CCConfig) {
	mut ctx := context()

	mut c := &CC{
		config: config
	}

	mut w := 600
	mut h := 600

	if ctx.preferred_size != none {
		w = ctx.preferred_size.x
		h = ctx.preferred_size.y
	}

	c.gg = gg.new_context(
		bg_color:      gg.white
		width:         w
		height:        h
		create_window: true
		window_title:  'Canvas'
		frame_fn:      c.frame
		cleanup_fn:    c.cleanup
		user_data:     c
	)

	ctx.cc = c

	c.gg.run()

	// return ctx.cc
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

fn init(mut c CC) {

}

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.preferred_size = vec.vec2[int](w, h)
	}else{
		ctx.cc.gg.resize(w, h)
	}
}

pub fn (c &CC) text(msg string, x int, y int) {
	c.gg.draw_text_def(x, y, msg)
}

pub fn run(frame_fn fn (voidptr)) {
	setup(CCConfig {
		frame_fn: frame_fn
	})
}