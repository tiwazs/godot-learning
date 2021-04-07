extends Node

#call down. signal up.

export(int) var max_health = 1
#enabling setters and getter for health.
onready var health = max_health setget set_health

signal no_health

#whenever health is set this function is called
func set_health(value):
	health = value
	#signalling up
	if health <= 0:
		emit_signal("no_health")
