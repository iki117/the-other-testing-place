extends Control
@onready var StartButton : Button = $StartButton
@onready var QuitButton : Button = $QuitButton
@onready var help : TextureRect = $TextureRect
@onready var text : RichTextLabel = $RichTextLabel
@export var stuff = 0

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_texture_rect_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left_Click") :
		help.visible = false

func _on_how_2_play_button_pressed() -> void:
	help.visible = true
	
func _process(delta: float) -> void:
	stuff += delta*2.5
	text.scale.y = sin(stuff)*10
