extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MOVE_SPEED = 40.0
const DASH_SPEED = 180.0
const DASH_COOLDOWN = 2.0 

var health: int = 100
var target = null
var can_dash = true
var is_dashing = false
var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if target:
		var direction = (target.position - position).normalized()

		if not is_dashing:
			velocity = direction * MOVE_SPEED
			animated_sprite_2d.play("walk")
			
			if can_dash:
				_perform_dash(direction)

		if direction.x != 0:
			animated_sprite_2d.flip_h = direction.x > 0
	else:
		velocity = Vector2.ZERO
		animated_sprite_2d.play("idle")

	move_and_slide()


func take_damage(damage: int) -> void:
	if is_dead:
		return
	health -= damage
	print (health)
	animated_sprite_2d.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	animated_sprite_2d.modulate = Color.WHITE
	if health <= 0:
		_die()
		
func _die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()


func _perform_dash(direction: Vector2) -> void:
	can_dash = false
	is_dashing = true
	
	animated_sprite_2d.play("attack")
	
	velocity = direction * DASH_SPEED

	await get_tree().create_timer(0.4).timeout
	
	is_dashing = false

	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true

func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "player":
		target = body
