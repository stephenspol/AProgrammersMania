extends KinematicBody2D

var gravity = 25
var velocity = Vector2.ZERO
onready var move_speed : float = 175 * scale.x

var is_respawning := false
var is_panning_to_checkpoint := false
const PAN_SPEED := 0.1

var is_swinging := false

func _physics_process(delta):
	# TODO Respawn throws nil if checkpoint was not set
	if is_panning_to_checkpoint:
		position = lerp(position, respawn_checkpoint_node_ref.position, PAN_SPEED)
		if position.distance_to(respawn_checkpoint_node_ref.position) <= 2:
			respawn()

	if is_respawning:
		return
	
	var move_left = Input.get_action_strength("ui_left")
	var move_right = Input.get_action_strength("ui_right")
	velocity.x = (move_right - move_left) * move_speed
	
	if is_swinging:
		velocity = move_and_slide(velocity, Vector2.UP)
		return
	
	velocity.y += gravity
	
	if move_left > 0:
		$AnimatedSprite.flip_h = true
	elif move_right > 0:
		$AnimatedSprite.flip_h = false
		
	if velocity.x != 0 and is_on_floor():
		$AnimatedSprite.play("run")
	elif is_on_floor():
		$AnimatedSprite.play("idle")
	elif velocity.y > 0:
		$AnimatedSprite.play("fall")
	elif velocity.y < 0:
		$AnimatedSprite.play("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const JUMP_FORCE := 400

func _input(event):
	if event.is_action_pressed("ui_up") and is_on_floor():
		velocity.y -= JUMP_FORCE
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
		if respawn_checkpoint_node_ref != null:
			respawn_checkpoint_node_ref.set_active(false)
			
		respawn_checkpoint_node_ref = new_checkpoint
		respawn_checkpoint_node_ref.set_active(true)

func attached_to_chain(chainLoop : Node2D):
	is_swinging = true
	
func detached_from_chain(chainLoop : Node2D):
	is_swinging = false
