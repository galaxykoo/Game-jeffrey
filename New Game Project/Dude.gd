extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var parent = get_parent()

export(PackedScene) var combat_actor
#warning-ignore:unused_class_variable
var lost = false
# Called when the node enters the scene tree for the first time.

# Called when the node enters the scene tree for the first time.
func _ready():
	update_look_direction(Vector2.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(_delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
	update_look_direction(input_direction)

	var target_position = parent.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
		$Tween.start()
	else:
		bump()


func get_input_direction():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

func update_look_direction(direction):
	$PosDude/AnimatedSprite.rotation = direction.angle()

func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("walk")
	var move_direction = (position - target_position).normalized()
	$Tween.interpolate_property($Pivot, "position", move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Pivot/Sprite.position = position - target_position
	position = target_position

	yield($AnimationPlayer, "animation_finished")

	set_process(true)


func bump():
	$AnimationPlayer.play("bump")
		# See the note below about boolean assignment



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
