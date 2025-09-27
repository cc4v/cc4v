module cc

struct CCContext {
mut:
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

fn begin() {
	mut ctx := context()
}

fn end() {
	mut ctx := context()
}