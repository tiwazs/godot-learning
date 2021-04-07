extends Node2D

func _on_Hurtbox_area_entered(area):
	grass_destruction_effect()
	queue_free()
	

func grass_destruction_effect():
		#Loading the scene for the animation of the grass destruction
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	
	#Accessing the world tree scene to add the animation on it
	var world = get_tree().current_scene
	
	world.add_child(grassEffect)
	
	#Getting the grass position to create the animation scene upon it
	grassEffect.global_position = global_position
