extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_time: Timer = $coyote_time

var can_jump : bool = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		animation_player.play("jump")

	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
	
	if is_on_floor():
		can_jump = true
		coyote_time.stop()
	else :
		if coyote_time.is_stopped():
			coyote_time.start(0.2)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
		velocity.x = direction * SPEED
		animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animation_player.play("idle")

	move_and_slide()


func _on_coyote_time_timeout() -> void:
	can_jump = false
	coyote_time.stop()
