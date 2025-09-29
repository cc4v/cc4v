module cc
import gg
// import log

pub fn background(c gg.Color) {
	mut ctx := context()
	if unsafe { ctx.cc == nil } {
		ctx.pref.bg_color = c
	}else{
		ctx.cc.gg.set_bg_color(c)
	}
}

pub fn set_color(c gg.Color){
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.current_style.color = c
	}
}

pub fn get_color() gg.Color {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		return ctx.cc.current_style.color
	}else{
		// log.error("cc: failed to get color")
		panic("cc: failed to get color")
	}
}