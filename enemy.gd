extends StaticBody2D
signal enemyselected(gameobject)
@onready var player = $"../Player"
@onready var Partsys = $CPUParticles2D
@onready var collider = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var scream = $Scream
@onready var splash = $Splash

func _ready() -> void:
	player.KillSignal.connect(_on_player_kill_signal)

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
		if Input.is_action_just_pressed("Left_Click"):
			enemyselected.emit(self)

func _on_player_kill_signal(gameobject: Variant) -> void:
	if (gameobject == self) :
		Partsys.emitting = true
		scream.play()
		splash.play()
		print(self, "Killed!")
		if sprite :
			sprite.hide()
		collider.set_deferred("disabled", true)
		await get_tree().create_timer(Partsys.lifetime).timeout
		self.queue_free()
