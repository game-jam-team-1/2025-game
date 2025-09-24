class_name PlayerState
extends State

@onready var player: Player
@onready var player_sm: PlayerStateMachine


func init(controlled_node: Node, state_machine: StateMachine) -> void:
	super(controlled_node, state_machine)
	player = controlled_node as Player
	player_sm = state_machine as PlayerStateMachine
