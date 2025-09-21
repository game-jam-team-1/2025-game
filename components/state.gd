@abstract
class_name State
extends Node

var controlled_node: Node
var state_machine: StateMachine

func init(controlled_node: Node, state_machine: StateMachine) -> void:
	self.controlled_node = controlled_node
	self.state_machine = state_machine

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
