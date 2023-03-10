extends KinematicBody2D

export var swinging_enabled := false

const gravity = 25
var velocity = Vector2.ZERO
onready var move_speed : float = 175 * scale.x
var has_double_jump := false

var is_respawning := false
var is_panning_to_checkpoint := false
const PAN_SPEED := 0.1

var is_swinging := false
var attached_chain_loop : Node2D

func _physics_process(delta):
	# TODO Respawn throws null if checkpoint was not set
	if is_panning_to_checkpoint:
		position = lerp(position, respawn_checkpoint_node_ref.position, PAN_SPEED)
		if position.distance_to(respawn_checkpoint_node_ref.position) <= 2:
			respawn()

	if is_respawning:
		return
		
	var move_left = Input.get_action_strength("ui_left")
	var move_right = Input.get_action_strength("ui_right")
		
	if is_swinging and swinging_enabled:
#		attached_chain_loop.velocity.x += (move_right - move_left) * move_speed
		velocity = move_and_slide(velocity, Vector2.UP)
		return
	
	velocity.x = (move_right - move_left) * move_speed
	
	velocity.y += gravity
	
	if move_left > 0:
		$AnimatedSprite.flip_h = true
	elif move_right > 0:
		$AnimatedSprite.flip_h = false
		
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite.play("run")
		else:
			$AnimatedSprite.play("idle")
		has_double_jump = true
	elif is_on_wall():
		$AnimatedSprite.play("wall jump")
	elif velocity.y > 0:
		$AnimatedSprite.play("fall")
	elif velocity.y < 0:
		if $AnimatedSprite.animation != "double jump":
			$AnimatedSprite.play("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const JUMP_FORCE := 400

func _input(event):
	if event.is_action_pressed("ui_up"):
		if is_on_floor():
			velocity.y -= JUMP_FORCE
		elif has_double_jump:
			$AnimatedSprite.play("double jump")
			velocity.y = -JUMP_FORCE
			has_double_jump = false
		elif is_on_wall():
			velocity.y = -JUMP_FORCE
			if $AnimatedSprite.flip_h:
				velocity.x = move_speed * 2
			else:
				velocity.x = -move_speed * 2
		$JumpSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_spike_damage(damage):
	if !is_respawning:
		print("Took %d damage" % damage)
		despawn()

func despawn():
	is_respawning = true
	
	$HitSound.play()
	$AnimatedSprite.play("despawn")
	yield($AnimatedSprite, "animation_finished")
	
	is_panning_to_checkpoint = true
	$AnimatedSprite.visible = false
	
func respawn():
	is_panning_to_checkpoint = false
	
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("spawn")
	yield($AnimatedSprite, "animation_finished")
	is_respawning = false

var respawn_checkpoint_node_ref : Node2D

func update_checkpoint(new_checkpoint: Node2D):
	if new_checkpoint != respawn_checkpoint_node_ref:
		if respawn_checkpoint_node_ref != null and respawn_checkpoint_node_ref.has_method("set_active"):
			respawn_checkpoint_node_ref.set_active(false)
			
		respawn_checkpoint_node_ref = new_checkpoint
		respawn_checkpoint_node_ref.set_active(true)

func attached_to_chain(chainLoop : Node2D):
	attached_chain_loop = chainLoop
	is_swinging = true
	
func detached_from_chain(chainLoop : Node2D):
	attached_chain_loop = null
	is_swinging = false
