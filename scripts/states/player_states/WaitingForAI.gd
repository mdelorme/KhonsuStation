extends Node

signal set_next_state(next_state: Node, parameter: Variant)

var parent_node: Node2D

func on_state_enter(previous_state: Node, _parameter: Variant) -> void:
	Debug.log("Node %s is switching from state %s to %s" % [parent_node.name, previous_state.name, name])
	
func process(_delta: float) -> void:
	set_next_state.emit("WaitingForInput", null)

