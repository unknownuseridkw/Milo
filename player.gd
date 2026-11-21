extends CharacterBody2D

@export var speed: float = 200.0
@export var attack_offset: Vector2 = Vector2(14, -3)
@export var body_offset: Vector2 = Vector2(-7, 0)
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@export var damage: int = 20 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var laser_shoot: AudioStreamPlayer2D = $LaserShoot

var direction: Vector2 = Vector2.ZERO
var isAttacking: bool = false
var max_health: int = 100
var current_heath: int = max_health

func _ready() -> void:
	%HealthBar.max_value = max_health
	health_bar()
	

func health_bar() -> void:
	%HealthBar.value = current_heath
func take_damage(amount: int) -> void:
	current_heath -= amount
	print(current_heath)
	health_bar()
	animated_sprite_2d.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	animated_sprite_2d.modulate = Color.WHITE
	if current_heath <= 0:
		_die()

func _die() -> void:
	GameManager.trigger_lose()

func _physics_process(_delta):
	process_movement()
	attack()
	animation()

func process_movement():
	if GameManager.gameStarted:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed
		move_and_slide()

func attack():
	if Input.is_action_just_pressed("ui_attack") and !isAttacking and GameManager.gameStarted:
		isAttacking = true
		hitbox.monitoring = true 
		anim.play("attack")
		await anim.animation_finished
		hitbox.monitoring = false
		isAttacking = false

func animation():
	if direction.x < 0:
		anim.flip_h = true
	elif direction.x > 0:
		anim.flip_h = false

	var facing: int = -1 if anim.flip_h else 1
	var base_offset: Vector2 = attack_offset if isAttacking else body_offset
	anim.offset = Vector2(base_offset.x * facing, base_offset.y)

	if !isAttacking:
		if direction != Vector2.ZERO:
			anim.play("walk")
		else:
			anim.play("idle")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if isAttacking and body.has_method("take_damage"):
		body.take_damage(damage)
		laser_shoot.play()
