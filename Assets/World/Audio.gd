extends AudioStreamPlayer

const SOUNDS = {
	
}

var asp_click = AudioStreamPlayer.new()
var asp_build = AudioStreamPlayer.new()
var asp_voice = AudioStreamPlayer.new()

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	asp_click.bus = "Effects"
	asp_build.bus = "Effects"
	asp_voice.bus = "Voice"
	
	asp_click.stream = SOUNDS["click"]
	asp_click.stream = SOUNDS["build"]
	
func play_snd(snd_name: String, stream: AudioStream = null) -> void:
	var asp: AudioStreamPlayer = {
		"click": asp_click,
		"build": asp_build,
		"voice": asp_voice
	}.get(snd_name)
	
	# 如果请求的声音存在一个不同的 AudioStreamPlayer，则使用那个
	if asp != null:
		if stream: # 目前只用于传递不同的语音信息
			asp.stream = stream
		if not asp.name:
			add_child(asp)
		asp.play()
		# print_debug("Playing {0}". format([snd_name]))
		
	# 否则通过通用 AudioStreamPlayer 播放
	elif SOUNDS[snd_name]:
		self.stream = SOUNDS[snd_name]
#		if not name:
#			add_child(self)
		play()
#		print_debug("Playing {0}" . format([snd_name]))
	else:
		printerr("Sound {0} not found." . format([snd_name]))
		

func play_snd_click() -> void:
	play_snd("click")
	
func play_snd_fail() -> void:
	play_snd("build")
	
func play_snd_voice(voice_code: String) -> void:
	play_snd("voice", SOUNDS[voice_code])
	
func play_entry_snd() -> void:
	asp_voice.stream = SOUNDS["{0}_{1}".format([Config.language, randi() % 4])]
	if not asp_voice.name:
		add_child(asp_voice)
	asp_voice.play()
	
func set_volume(volume:float, bus_name: String) -> void:
	var index = AudioServer.get_bug_index(bus_name)
	print("Set volume for bus {0}({1}): {2}".format([bus_name, index, volume]))
	AudioServer.set_bus_volume_db(index, linear2db(volume / 100.0))
	
func set_master_volume(volume: float) -> void:
	set_volume(volume, "Master")

func set_voice_volume(volume: float) -> void:
	set_volume(volume, "Voice")

func set_effects_volume(volume: float) -> void:
	set_volume(volume, "Effects")

func set_music_volume(volume: float) -> void:
	set_volume(volume, "Music")
		
		
		
		
		
