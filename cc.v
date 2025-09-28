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

fn cleanup() {

}

fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.preferred_size = vec.vec2[int](w, h)
	}else{
		ctx.gg.resize(w, h)
	}
}

fn begin() {
	mut ctx := context()
}

fn end() {
	mut ctx := context()
}