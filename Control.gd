extends Control

### Hack so dlopen works.
func copy_lib(lib):
	var f = File.new()
	var err = f.open("res://lib/%s" % lib, File.READ)
	if err != OK:
		print("Error opening file: %d" % err)
		return err
	
	var w = File.new()
	w.open("/%s" % lib, File.WRITE)
	
	w.store_buffer(f.get_buffer(f.get_len()))
	return OK

func _ready():
	if OS.get_name() == "HTML5":
		if copy_lib("test.wasm") != OK:
			return

	# Load test wasm (C/C++ printf)
	# emcc src/test.c -I../godot_headers/ -s SIDE_MODULE=1 -o lib/test.wasm
	var gdn = GDNative.new()
	gdn.library = load("res://lib/test.tres")
	gdn.initialize()
	gdn.terminate()
