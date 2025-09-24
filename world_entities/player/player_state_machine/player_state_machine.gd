class_name PlayerStateMachine
extends StateMachine

@onready var idle_state: PlayerIdle = $"Idle"
@onready var walk_state: PlayerWalk = $"Walk"
@onready var jump_state: PlayerJump = $"Jump"
@onready var fall_state: PlayerFall = $"Fall"
