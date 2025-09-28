module cc
import gg

pub fn text(msg string, x int, y int) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.gg.draw_text_def(x, y, msg)
	}
}

pub fn draw_text(msg string, x int, y int, cfg gg.TextCfg) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.gg.draw_text(x, y, msg, cfg)
	}
}