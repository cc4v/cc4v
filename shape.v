module cc
// import gg

pub fn rect(x f32, y f32, w f32, h f32) {
	mut ctx := context()
	if unsafe { ctx.cc != nil } {
		col := ctx.cc.current_style.color
		if ctx.cc.current_style.fill {
			ctx.cc.gg.draw_rect_filled(x, y, w, h, col)
		} else {
			ctx.cc.gg.draw_rect_empty(x, y, w, h, col)
		}
	}
}