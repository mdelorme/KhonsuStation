extends State

func on_state_enter(previous_state: Node, _parameter: Variant) -> void:
	Debug.log("Node %s is switching from state %s to %s" % [parent_node.name, previous_state.name, name])
	
func unhandled_input(event: InputEvent) -> void:
	# Movement
	var offset := Vector2i(0,0)
	if event.is_action("action_left"):
		offset = Vector2i(-1, 0)
		parent_node.play_animation("idle_left")
	elif event.is_action("action_right"):
		offset = Vector2i( 1, 0)
		parent_node.play_animation("idle_right")
	elif event.is_action("action_up"):
		offset = Vector2i(0, -1);
		parent_node.play_animation("idle_up")
	elif event.is_action("action_down"):
		offset = Vector2i(0,  1)
		parent_node.play_animation("idle_down")
		
	if offset != Vector2i(0,0) and parent_node.can_move(offset):
			set_next_state.emit("Moving", offset*Constants.TILE_SIZE)
			
			
