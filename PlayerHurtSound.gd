extends AudioStreamPlayer2D


func _ready():
	connect("finish",self,"queue_free" )
