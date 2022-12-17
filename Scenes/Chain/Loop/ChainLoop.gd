extends Area2D

const CHAIN_LOOP_GAP = 2

export var anchor = false

var over = false

var pos = Vector2()
var oldPos = Vector2()

func setPosition(index):
	pos = Vector2(0, index + 1) 
	pos *= ($ChainLoopSprite.texture.get_size().y + CHAIN_LOOP_GAP)
	oldPos = pos
	position = pos

func _physics_process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and over:
		var mousePos = get_global_mouse_position()
		var vector = mousePos - get_global_position()
		oldPos = pos
		pos += vector

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
		if (!body.is_swinging):
			pos += body.velocity * .1
		
		body.attached_to_chain(self)


func _on_ChainLoop_body_exited(body):
	if body.has_method("detached_from_chain"):
		body.detached_from_chain(self)
