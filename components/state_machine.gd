class_name StateMachine
extends Node

signal changed_state(new_state: State)

@export var starting_state: State

var current_state: State


# Initialize by giving each state a reference to the parent and animations,
# then changing to the starting state
func init(controlled_node: Node) -> void:
	for state: State in get_children():
		state.init(controlled_node, self)
	
	change_state(starting_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	
	changed_state.emit(new_state)


# Pass through functions for the parent to call,
# handling state changes as needed.
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
