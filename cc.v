module cc

struct CCContext {
mut:
}

@[unsafe]
fn context() &CCContext {
	mut static ctx := voidptr(0)
	if unsafe { ctx == nil } {
		ctx = &CCContext{} 
	}
	return ctx
}

fn cleanup() {
	
}

fn begin() {
	mut ctx := unsafe { context() }
}

fn end() {
	mut ctx := unsafe { context() }
}