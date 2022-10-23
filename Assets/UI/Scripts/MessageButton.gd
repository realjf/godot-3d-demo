tool
extends TextureButton
class_name MessageButton


const MESSAGE_TEXTURES = [
	{ #Save
		"normal": "",
		"pressed": "",
		"hover": ""
	}
]


enum MessageType {
	SAVE
}

export(MessageType) var message_type := MessageType.SAVE setget set_message_type

func set_message_type(new_message_type: int) -> void:
	message_type = new_message_type
	
	texture_normal = MESSAGE_TEXTURES[message_type]["normal"]
	texture_pressed = MESSAGE_TEXTURES[message_type]["pressed"]
	texture_hover = MESSAGE_TEXTURES[message_type]["hover"]


