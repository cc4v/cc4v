module cc

import math.vec
import gg

struct CC {

}

struct CCContext {
mut:
	cc &CC = unsafe { nil }
	gg &gg.Context = unsafe { nil }
	preferred_size ?vec.Vec2[int]
}

fn context() &CCContext {
	unsafe { 
		mut static ctx := voidptr(0)
		if ctx == nil {
			ctx = &CCContext{} 
		}
		return ctx
	}
}

fn draw_context() &CCContext {
	// WORKAROUND
	return context()
}

fn cleanup() {

}

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.preferred_size = vec.vec2[int](w, h)
	}else{
		ctx.gg.resize(w, h)
	}
}

pub fn text(msg string, x f32, y f32) {
	mut ctx := draw_context()
}

pub fn begin() {
	mut ctx := context()
}

pub fn end() {
	mut ctx := context()
}