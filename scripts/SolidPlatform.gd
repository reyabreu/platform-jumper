extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	print("body %s collided with platform [%d]" % [body, get_instance_id()])
	if body.name == "Player":
		if body.position.y < position.y:
			body