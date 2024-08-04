extends Node

const debug_mode := true

func log(msg: String) -> void:
	if debug_mode:
		print('* ', msg) 
