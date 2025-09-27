module cc

struct CCContext {

}

@[unsafe]
fn singleton() &CCContext {
	mut static ctx := voidptr(0)
	if unsafe { ctx == nil } {
		ctx = &CCContext{} 
	}
	return ctx
}

fn cleanup() {
	
}

fn begin() {

}

fn end() {

}