@tool
extends Node
class_name State

signal state_changed(name: String)

@export var current_state: Node:
	set(new_state):
		if new_state != current_state:
			current_state = new_state
			next_state = current_state
			update_configuration_warnings()

var next_state:   Node
var enter_params: Variant # If we have anything to pass to the node

func _ready() -> void:
	for c in get_children():
		c.connect("set_next_state", set_next_state)

func update_state() -> void:
	if current_state != next_state:
		if next_state:
			if current_state.has_method("on_state_enter"):
				next_state.on_state_enter(current_state, enter_params)
			state_changed.emit(next_state.name)
		current_state = next_state
		
func process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	update_state()
	
	if not check_active_state():
		return
	
	if current_state.has_method("process"):
		current_state.process(delta)
		
func physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	update_state()
			
	if not check_active_state():
		return
	
	if current_state.has_method("physics_process"):
		current_state.physics_process(delta)
		
func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
		
	if not check_active_state():
		return
	if current_state.has_method("unhandled_input"):
		current_state.unhandled_input(event)

func set_next_state(state: String, parameter: Variant):
	if current_state.has_method("on_state_leave"):
		current_state.on_state_leave()
	
	enter_params = parameter
	
	next_state = find_child(state)
	if not next_state:
		printerr('Unknown state %s' % [state])
	
func check_active_state() -> bool:
	if not current_state:
		var parent : Node2D = get_parent()
		if parent:
			printerr("Error : No state defined for %s" % [parent.name])
		return false
	return true

func _get_configuration_warnings():
	var warnings = []

	if not current_state:
		warnings.append("State must have a current state defined !")
	else:
		if current_state not in get_children():
			warnings.append("Current state is not a child of state !")
	
		for c in get_children():
			if not c.has_signal("set_next_state"):
				warnings.append("State %s does not have signal 'set_next_state'" % [c.name])

	# Returning an empty array means "no warning".
	return warnings
	

func _on_child_entered_tree(node: Node) -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings()
	
	var parent := get_parent()
	if parent:
		node.parent_node = get_parent()
