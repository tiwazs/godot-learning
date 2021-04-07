extends Node2D

func _on_Hurtbox_area_entered(area):
	grass_destruction_effect()
	queue_free()

#Loading the scene for the animation of the grass destruction
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func grass_destruction_effect():
	var grassEffect = GrassEffect.instance()
	
	#Accessing the world tree scene to add the animation on it	
	get_parent().add_child(grassEffect)
	
	#Getting the grass position to create the animation scene upon it
	grassEffect.global_position = global_position
