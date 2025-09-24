@abstract
class_name State
extends Node
## State is the base node for a state handled by [class StateMachine].

## This state applies to the controller node.
var controlled_node: Node

## The state machine handling this state. Try not to call functions on this 
## directly to follow reccomended coding guidelines for Godot (signal up, call 
## down).
var state_machine: StateMachine

func init(new_controlled_node: Node, new_state_machine: StateMachine) -> void:
	self.controlled_node = new_controlled_node
	self.state_machine = new_state_machine

## Called when this becomes the current state of the [class StateMachine].
func enter() -> void:
	pass

## Called when this no longer is the current state of the [class StateMachine].
func exit() -> void:
	pass

## Called by the state machine, when there is an input event.
func process_input(event: InputEvent) -> State:
	return null

## Called from the process function of the state machine.
func process_frame(delta: float) -> State:
	return null

## Called from the physics process function of the state machine.
func process_physics(delta: float) -> State:
	return null
