extends Node

enum WindowMode { WINDOWED, FULLSCREEN }

enum ResourceType {}

# 阵营
enum Faction {
	NONE,
	RED,
	BLUE,
	DARK_GREEN,
	ORANGE,
	PURPLE,
	CYAN,
	YELLOW,
	MAGENTA,
	TEAL,
	LIME_GREEN,
	BORDEAUX,
	WHITE,
	GRAY,
	BLACK,
}

const RESOURCE_TYPES = [
	null,
]

# 阵营颜色名字
const FACTIONS = [
	"None",
	"Red",
	"Blue",
	"Dark Green",
	"Orange",
	"Purple",
	"Cyan",
	"Yellow",
	"Pink",
	"Teal",
	"Lime Green",
	"Bordeaux",
	"White",
	"Gray",
	"Black",
]

# 阵营旗帜
const FACTION_FLAGS = []

# 阵营颜色
const FACTION_COLORS = [
	Color8(0, 0, 0, 0),  # None (transparent black).
	Color8(250, 10, 10, 255),  # Red.
	Color8(0, 71, 181, 255),  # Sea Blue.
	Color8(0, 158, 23, 255),  # Dark Green.
	Color8(224, 102, 0, 255),  # Orange.
	Color8(128, 0, 128, 255),  # Purple.
	Color8(0, 255, 255, 255),  # Cyan.
	Color8(255, 214, 0, 255),  # Yellow.
	Color8(255, 0, 255, 255),  # Magenta.
	Color8(0, 145, 140, 255),  # Teal.
	Color8(0, 255, 0, 255),  # Lime Green.
	Color8(150, 5, 41, 255),  # Bordeaux Red.
	Color8(255, 255, 255, 255),  # White.
	Color8(128, 128, 128, 255),  # Gray.
	Color8(0, 0, 0, 255),  # Black.
]

# 消息
const MESSAGE_SCENE = preload("res://Assets/UI/Scenes/Message.tscn")

const WINDOW_MODES = {WindowMode.WINDOWED: "Windowed", WindowMode.FULLSCREEN: "Fullscreen"}

# 语言选择
const LANGUAGES = ["en", "zh", "de", "fr"]

const LANGUAGES_READABLE = {
	"en": "English",
	"zh": "简体中文",
	"de": "Deutsch",
	"fr": "Français",
}

# 游戏变量
var game_type := "FreePlay"
var faction := 1
var map: PackedScene
var ai_players := 0  # 一旦AI起作用，默认值应为3
var resource_density := 1.0
var has_traders := false
var has_pirates := true
var has_disasters := false
# ------
var Game: Spatial = null
var PlayerStart: Spatial = null

var _warning := false  # DEBUG


func _ready() -> void:
	Config.load_config()  # 如果存在存储配置则初始化

	var window_mode = Config.window_mode
	var screen_resolution = Config.screen_resolution

	OS.window_fullscreen = window_mode
	set_screen_resolution(screen_resolution)

	set_audio_volumes()

	pause_mode = Node.PAUSE_MODE_PROCESS


func set_screen_resolution(screen_resolution: String) -> void:
	var resolution = screen_resolution.split("x")
	resolution = Vector2(int(resolution[0]), int(resolution[1]))
	OS.set_window_size(resolution)
	OS.center_window()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func set_audio_volumes() -> void:
	Audio.set_master_volume(Config.master_volume)
	Audio.set_music_volume(Config.music_volume)
	Audio.set_effects_volume(Config.effects_volume)
	Audio.set_voice_volume(Config.voice_volume)


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	# Only available during gameplay
	if get_tree().get_root().get_node_or_null("World/WorldEnvironment") != null:
		if event.is_action_pressed("time_speed_up"):
			Engine.time_scale += clamp(.1, 0, 2)
			prints("Time Scale:", Engine.time_scale)
		if event.is_action_pressed("time_slow_down"):
			Engine.time_scale -= clamp(.1, 0, 2)
			prints("Time Scale:", Engine.time_scale)
		if event.is_action_pressed("time_reset"):
			Engine.time_scale = 1
			prints("Time Scale:", Engine.time_scale)

		if event.is_action_pressed("pause_scene"):
			get_tree().paused = !get_tree().paused
			print(get_tree().paused)

		if event.is_action_pressed("restart_scene"):
			#warning-ignore:return_value_discarded
			get_tree().reload_current_scene()

	if event.is_action_pressed("toggle_fullscreen"):
		var window_mode = Config.window_mode

		window_mode = (window_mode + 1) % WINDOW_MODES.size()
		prints("window_mode:", window_mode)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		OS.window_fullscreen = !OS.window_fullscreen

		Config.window_mode = window_mode

		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	if event.is_action_pressed("quit_game"):
		get_tree().quit()
