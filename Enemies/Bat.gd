extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeatheffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200 

#Bat state machine
enum {
	IDLE,
	WANDER,
	CHASE
}
var velocity = Vector2.ZERO

var knockback = Vector2.ZERO

var state = IDLE

onready var stats = $Stats


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		WANDER:
			pass
		CHASE:
			pass

func seek_player():
	pass
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120 

#signal for when bat's health is no no
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
