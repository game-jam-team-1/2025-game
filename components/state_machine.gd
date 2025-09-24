class_name StateMachine
extends Node
## A state machine, handles a bunch of states and can change between them. Make
## sure to call input process and physics process functions on this.

## Emitted when the state is changed.
signal changed_state(new_state: State)

## Starting state, the StateMachine will emediately set [member current_state]
## to this on ready.
@export var starting_state: State

## Current [class State]. What else is there to say.
var current_state: State

# Initialize by giving each state a reference to the parent and animations,
# then changing to the starting state
func init(controlled_node: Node) -> void:
	for state: State in get_children():
		state.init(controlled_node, self)
	
	change_state(starting_state)

## Changes to this state, calls enter and exit on the previous and next states.
## Try not to call this directly from a State.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	
	changed_state.emit(new_state)

## Pass through functions for the parent to call,
## handling state changes as needed.
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

## Call from the parent _process, calls process on the current state.
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

## Call from parent _physics_process, calls physics process on the current state.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
