extends CharacterBody2D

var speed = 400
var attackspeed = 1000
var horizontal : float
var vertical : float
var target_camera_pos : Vector2
@export var target_order : StaticBody2D
@export var can_move : bool
@export var is_attacking : bool

signal KillSignal(gameobject)
@onready var particlesys : CPUParticles2D = $CPUParticles2D
@onready var killtimer : Timer = $KillTimer
@onready var attacktimer : Timer = $AttackTimer
@onready var Camera : Camera2D = $"../Camera2D"
@onready var CollideBox : CollisionShape2D = $CollisionShape2D
@onready var Attack1 : AudioStreamPlayer2D = $Attack1
@onready var Attack2 : AudioStreamPlayer2D = $Attack2

func _ready() -> void:
	can_move = true
	is_attacking = false
	
func _physics_process(_delta: float) -> void:
	target_camera_pos = self.position
	Camera.position = lerp(Camera.position, target_camera_pos, 0.05)
	if !can_move :
		if is_attacking :
			velocity = (target_order.position - self.position).normalized() * attackspeed
			self.floor_constant_speed = true
			move_and_slide()
			if (get_slide_collision_count()) :
				var collision = get_slide_collision(0)
				var collider = collision.get_collider()
				if collider and collider.is_in_group("Enemy") :  #<- yeah i know this is bad practice, but im too lazy to fix it (i know how to fix it, trust me (i think)
					particlesys.emitting = false
					KillSignal.emit(collider)
					target_order = null
					is_attacking = false
					can_move = true
					speed = 400
					attacktimer.stop()
		return
	horizontal = Input.get_axis("Right", "Left")
	vertical = Input.get_axis("Up", "Down")
	velocity.x = horizontal*speed
	velocity.y = vertical*speed
	move_and_slide()
	if (target_order) :
		self.rotation = (target_order.position - self.position).angle()
		return
	self.rotation = lerp_angle(self.rotation, (get_global_mouse_position() - self.position).angle(), 0.2)

func _on_enemy_enemyselected(gameobject: Variant) -> void:
	if (!target_order) :
		print(gameobject)
		target_order = gameobject
		var soundrandomizer = RandomNumberGenerator.new().randi_range(0, 1)
		Attack1.play() if (soundrandomizer == 1) else Attack2.play()
		killtimer.start()

func _on_kill_timer_timeout() -> void:
	can_move = false
	is_attacking = true
	attacktimer.start()
	particlesys.emitting = true
	return

func _on_attack_timer_timeout() -> void:
	particlesys.emitting = false
	speed = 400
	target_order = null
	self.floor_constant_speed = false
	can_move = true
	return
