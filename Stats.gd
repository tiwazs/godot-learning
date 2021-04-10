extends Node

#call down. signal up.

export(int) var max_health = 1
#enabling setters and getter for health.
onready var health = max_health setget set_health

signal no_health
signal health_changed
signal max_health_changed

func set_max_health(value):
	max_health = value
	self.health = min(health,max_health)
	emit_signal("max_health_changed", max_health)

#whenever health is set this function is called
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	#signalling up
	if health <= 0:
		emit_signal("no_health")
