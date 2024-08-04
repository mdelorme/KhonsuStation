extends Control

@export_file("*.txt") var filename : String

const DIALOG_APPEARANCE_SPEED   := 0.5
const TEXT_APPEARANCE_SPEED     := 0.5
const PORTRAIT_TRANSITION_SPEED := 0.01

var dialog: Dialog = Dialog.new()
var cur_portrait: Texture2D = null
var cur_character: String = ""
var locked: bool = false
var raw_text: String = ""

@onready var portrait := $Panel2/MarginContainer/Portrait
@onready var contents := $Panel/MarginContainer/Contents

func _ready() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	if filename:
		dialog.load_dialog_from_file(filename)
		start_dialog()
		
func start_dialog() -> void:
	portrait.texture = null
	contents.text = ""
	raw_text = ""
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), DIALOG_APPEARANCE_SPEED)
	tween.tween_callback(next_entry)
	
func end_dialog() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), DIALOG_APPEARANCE_SPEED)

func transition_portrait(to: Texture2D) -> void:
	if to == cur_portrait:
		return
		
	locked = true
	var tween := create_tween()
	tween.tween_property(portrait, "modulate", Color(0.0, 0.0, 0.0, 1.0), PORTRAIT_TRANSITION_SPEED)
	tween.tween_property(portrait, "texture", to, 0.0)
	tween.tween_property(portrait, "modulate", Color(1.0, 1.0, 1.0, 1.0), PORTRAIT_TRANSITION_SPEED)
	tween.tween_callback(unlock)
	
	cur_portrait = to
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept'):
		next_entry()
	
func next_entry() -> void:
	if locked:
		return
		
	var entry := dialog.next_entry()
	if not entry:
		end_dialog()
	else:
		locked = true
		var new_char := entry.character_name != cur_character
		
		# Greying out original text
		var replacement_table = Characters.get_color_replacements()
		for key in replacement_table:
			contents.text = contents.text.replace(key, replacement_table[key])
		
		var text := ""
		var new_raw_text := ""
		if new_char:
			var character := Characters.get_character(entry.character_name)
			transition_portrait(character.portrait)
			text = "[b][color=%s]%s[/color][/b] - " % [character.color.to_html(), character.name]
			new_raw_text = "%s - " % [character.name] + tr(entry.dialog_string)
			
		text += "[color=#ffffffff]" + tr(entry.dialog_string) + "[/color]"
		
		var original_size : int = raw_text.length()
		var delta_char : int = new_raw_text.length()
		
		if contents.text:
			contents.text += "\n\n"
			raw_text += "\n\n"
			original_size += 2
		contents.text += text
		
		contents.visible_characters = original_size
		raw_text += new_raw_text
		
		var tween := create_tween()
		tween.tween_property(contents, "visible_characters", original_size+delta_char, TEXT_APPEARANCE_SPEED)
		tween.tween_callback(unlock)
			
			
func unlock() -> void:
	locked = false
