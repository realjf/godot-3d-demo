tool
extends Label
class_name MessageText

export(String, MULTILINE) var message_text setget set_message_text

func _ready() -> void:
	set_message_text(message_text)
	

func set_message_text(new_message_text: String) -> void:
	message_text = new_message_text
	text = message_text
	
	# 文本更新后，决定字体大小调整是否合适
	var font = get("custom_fonts/font")
	font.set("size", 17)
	
	if get_line_count() > 2:
		# 使字体唯一，这样它就不会错误地更新其他实例
		font = font.duplicate(true)
		add_font_override("font", font)
		font.set("size", 15)
	else:
		font.set("size", 17)
	
	if get_line_count() > 3:
		printerr("Text [{0}] at {1} is too long." . format([text, self.name]))



