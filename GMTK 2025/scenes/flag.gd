extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		var managers = get_tree().get_nodes_in_group("manager")
		for manager in managers:
			if manager.has_method("load_next_level"):
				manager.load_next_level()
