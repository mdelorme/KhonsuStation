extends Node

const path := "res://resources/characters/"

var _characters : Dictionary = {}

func _ready() -> void:
	Debug.log("Loading characters")
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename:
			var char_name := filename.get_file().get_basename().to_upper()
			_characters[char_name] = load(dir.get_current_dir() + filename)
			filename = dir.get_next()
			Debug.log(" - New character %s" % [char_name])
		Debug.log("%d characters loaded" % [_characters.size()])
	else:
		printerr("No character path found at %s" % [path])

func get_character(char_name: String) -> Character:
	if not char_name in _characters:
		printerr("No character named %s" % [char_name])
		return null
	return _characters[char_name]
	
func get_color_replacements() -> Dictionary:
	var res := {}
	for char_name in _characters:
		var character : Character = _characters[char_name]
		res[character.color.to_html()] = character.dim_color.to_html()
	res["#ffffffff"] = "#aaaaaaff"
	return res
