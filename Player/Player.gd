extends KinematicBody2D

const player_hurt_sound = preload("res://Player/PlayerHurtSound.tscn")

export var MAX_SPEED = 80
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 125

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

#Accessing animationplayer and animationtree nodes
#to setup animations use animation tree and mapping system
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/Hitbox
onready var hurtbox = $Hurtbox
onready var flash_animation_player = $FlashAnimationPlayer

func _ready():
	randomize()
	stats.connect("no_health",self,"queue_free" )
	animation_tree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

	
func move_state(delta):
		# gets input vector from directional keys
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Velocity keeps increassing with an acc as long a the directional keys are pressed
	if input_vector != Vector2.ZERO:
		# we want that the roll vector is only set if input vector is NOT zero
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		
		# on the animation tree we defined a map for the animation, now we need to tell
		# it which variable to use as input to map
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		#after defining the input we need to set the state. here is running
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		#after defining the input we need to set the state. here is idle
		animation_state.travel("Idle")
		#If the keys are not pressed the player will tend to stop with a friction 
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
		
	#	move_and_collide(velocity * delta)
	#velocity = move_and_slide(velocity)
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	animation_state.travel("Attack")

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func move():
	velocity = move_and_slide(velocity)

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move()


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.8)
	hurtbox.create_hit_effect()
	var player_hurt_sound_instance = player_hurt_sound.instance()
	get_tree().current_scene.add_child(player_hurt_sound_instance)


func _on_Hurtbox_invincibility_stated():
	flash_animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	flash_animation_player.play("Stop")
