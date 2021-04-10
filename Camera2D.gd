extends Camera2D

onready var topleft = $Limits/TopsLeft
onready var bottomright = $Limits/BottomRight

func _ready():
	limit_top = topleft.position.y
	limit_left = topleft.position.x
	limit_bottom = bottomright.position.y
	limit_right = bottomright.position.x

