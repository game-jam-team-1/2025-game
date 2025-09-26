@abstract
class_name Item
extends RigidBody2D
## An item is a physics object which can be picked up and thrown by the player.

## Emitted when the item is thrown.
signal item_thrown

## Emitted when the item is used, this could happen when the item is not being 
## held. Delete is to notify if this object will queue_free, but don't another
## node should not queue_free us.
signal item_used(delete: bool)

## Current state of the item, because it can be held or not.
enum ItemState {
	HELD, ## Held in the hand of a player.
	ORPHAN, ## Was thrown or started out not being held.
}

## This item's tier. See [class SingletonItemsManager].
var tier: int

## The player this is held by. Properties or functions should not be called on 
## this.
var held_by: Player

## If this item is the selected item in the inventory.
var enabled: bool

## Current state. See [enum Item.ItemState].
@export var state: ItemState = ItemState.HELD

## The resource this was created from or can be converted to.
@export var resource: ItemResource

## Area used for detection by the player.
@export var area: Area2D

## If this can be thrown. If this is false, [code]throw_item[/code] probably
## won't do anything.
@export var can_be_thrown: bool = true

func _ready() -> void:
	assert(area, "Item must have an Area2D for detection")
	assert(resource, "Item must have an ItemResource")
	tier = resource.tier

## Call this function when the item is picked up.
func notify_picked_up(by: Player) -> void:
	held_by = by
	state = ItemState.HELD

## Call this function (ideally internally) when the item is thrown.
func notify_thrown() -> void:
	state = ItemState.ORPHAN

## Gets the scene of this item from [member resource]. Loads at runtime.
func get_scene() -> PackedScene:
	return load(resource.scene_path)

## Call this to make the item be used.
@abstract
func use_item() -> void

## Call this to make the item get thrown. Force is an impulse, in kg px/s
@abstract 
func throw_item(direction: Vector2, force: float) -> void

## Can be called by the player to make this item be held. The item decides what 
## to do with this information.
@abstract 
func follow_mouse(player_position: Vector2, mouse_position: Vector2) -> void
