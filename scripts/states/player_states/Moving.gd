extends State
class_name StatePlayerMoving


var destination: Vector2
var direction := Constants.Direction.None

const epsilon_destination := 1.0 # 1 pixel
const moving_lerp_factor  := 0.3

func set_destination(dest: Vector2) -> void:
	destination = dest

func on_state_enter(previous_state: Node, enter_param: Variant) -> void:
	Debug.log("Node %s is switching from state %s to %s" % [parent_node.name, previous_state.name, name])
	
	var pos : Vector2 = parent_node.global_position
	destination = pos + (enter_param as Vector2)
	
	var anim_name : String = ""
	if destination.x > pos.x:
		anim_name = "run_right"
		direction = Constants.Direction.Right
	elif destination.x < pos.x:
		anim_name = "run_left"
		direction = Constants.Direction.Left
	elif destination.y < pos.y:
		anim_name = "run_up"
		direction = Constants.Direction.Up
	elif destination.y > pos.y:
		anim_name = "run_down"
		direction = Constants.Direction.Down
	if anim_name != "":
		parent_node.play_animation(anim_name)
	
func on_state_leave() -> void:
	match direction:
		Constants.Direction.Up:    parent_node.play_animation("idle_up")
		Constants.Direction.Down:  parent_node.play_animation("idle_down")
		Constants.Direction.Left:  parent_node.play_animation("idle_left")
		Constants.Direction.Right: parent_node.play_animation("idle_right")
	direction = Constants.Direction.None
	
func physics_process(_delta: float) -> void:
	var d2 := destination.distance_squared_to(parent_node.global_position)
	if (d2 < epsilon_destination):
		parent_node.global_position = destination
		set_next_state.emit("WaitingForAI", null)
	else:
		parent_node.global_position = lerp(parent_node.global_position, destination, moving_lerp_factor)
