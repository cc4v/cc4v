module cc
import gg

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
	if unsafe { ctx.cc == nil } {
		ctx.cc.current_style.color = c
	}
}