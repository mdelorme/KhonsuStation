extends Resource
class_name Dialog

class DialogEntry:
	extends Resource
	@export var character_name: String
	@export var dialog_string: String
	
	func init(char_name: String, lines: String) -> void:
		character_name = char_name
		dialog_string = lines
		
var entries : Array[DialogEntry]
var cur_entry : int = 0

func load_dialog_from_file(filename: String) -> void:
	entries.clear()
	
	var file := FileAccess.open(filename, FileAccess.READ)
	if not file:
		var error_entry := DialogEntry.new()
		error_entry.init('ERROR', 'Error : Unknown dialog file %s' % [filename])
	else:
		while not file.eof_reached():
			var line := file.get_line().strip_edges()
			
			if not line or line[0] == '#':
				continue
			var tokens := line.split(" ")
			var char_name : String = tokens[0]
			tokens.remove_at(0)
			var entry : String = ' '.join(tokens)
			var new_entry := DialogEntry.new()
			new_entry.init(char_name, entry)
			entries.push_back(new_entry)
	cur_entry = 0
	file.close()
	
func end_of_dialog() -> bool:
	return cur_entry == entries.size()
	
func next_entry() -> DialogEntry:
	if end_of_dialog():
		return null
	
	var res := entries[cur_entry]
	cur_entry += 1
	return res
	

