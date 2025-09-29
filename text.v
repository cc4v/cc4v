module cc
import gg

pub fn text(msg string, x f32, y f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.gg.draw_text_def(int(x), int(y), msg)
	}
}

pub fn draw_text(msg string, x f32, y f32, cfg gg.TextCfg) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		ctx.cc.gg.draw_text(int(x), int(y), msg, cfg)
	}
}