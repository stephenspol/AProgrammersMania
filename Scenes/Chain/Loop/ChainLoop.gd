extends Area2D

const CHAIN_LOOP_GAP = 2

export var anchor = false

var over = false

var attachedEntity : Node2D

var pos = Vector2()

var velocity = Vector2.ZERO
const MAX_SPEED = 10

#func _ready():
#	if self.get_name() != "AnchorLoop":
#		var randNum = randi();
#		self.set_name(str(randNum))

func _physics_process(delta):
	velocity = velocity.limit_length(MAX_SPEED)
	pos += velocity
	if attachedEntity != null and attachedEntity.swinging_enabled:
		attachedEntity.velocity += velocity

func setPosition(index):
	pos = Vector2(0, index + 1) 
	pos *= ($ChainLoopSprite.texture.get_size().y + CHAIN_LOOP_GAP)
	position = pos

func _on_Control_mouse_entered():
	if !anchor:
		over = true
		modulate = Color(0x0000ffff)

func _on_Control_mouse_exited():
	if !anchor:
		over = false
		modulate = Color(0xffffffff)


func _on_ChainLoop_body_entered(body):
	if body.has_method("attached_to_chain"):
		pos += body.velocity * .1
		attachedEntity = body
#		attach_pin_joint(body)
		body.attached_to_chain(self)


func _on_ChainLoop_body_exited(body):
	pass
#	if body.has_method("detached_from_chain"):
#		body.detached_from_chain(self)
#		attachedEntity = null
		
#func attach_pin_joint(body):
#	var join = PinJoint2D.new()
#	join.set_node_a(self.get_name())
#	join.set_node_b(body.get_name())

# TODO use event instead, seems to freeze when trying to use keymapping
func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and over:
		var mousePos = get_global_mouse_position()
		var vector = mousePos - get_global_position()
#		pos += vector
		velocity += vector
