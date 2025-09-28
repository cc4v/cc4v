module cc
import math.vec
// import gg

pub fn size(w int, h int) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.size = vec.vec2[int](w, h)
	}else{
		ctx.cc.gg.resize(w, h)
	}
}