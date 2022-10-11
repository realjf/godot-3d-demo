extends Control
class_name MainMenuUI

var _scenes = {
	
}

func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventMouseButton:
		return
	
	var animation_player := $AnimationPlayer as AnimationPlayer
	animation_player.seek(animation_player.current_animation_length)
	
	accept_event()
	set_process_input(false)
	

func _go_to_scene(scene: String) -> void:
	Audio.play_snd_click()
	
	if scene == "sp_game" or scene == "help" or scene == "options":
		var subscene = _scenes[scene].instance()
		subscene.parent = self
		visible = false
		get_tree().get_root().add_child(subscene)
	else:
		get_tree().change_scene_to(_scenes[scene])
