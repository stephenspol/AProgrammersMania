# Based on https://steemit.com/utopian-io/@sp33dy/tutorial-godot-engine-v3-gdscript-verlet-chain-v0-01
extends Node2D

const CHAIN_LOOP = preload("res://Scenes/Chain/Loop/ChainLoop.tscn")
const CHAIN_LINK = preload("res://Scenes/Chain/Link/ChainLink.tscn")

const CHAIN_LINK_LENGTH = 26

const GRAVITY = 0.6
const RESISTANCE = 0.98
const FRICTION = 0.90

var loops = []
var links = []

export (int) var linkCount = 4

onready var SCREEN_SIZE = get_viewport().size

func _ready():
	addAnchorLoop()
	for i in range (linkCount):
		addLoop(i)
		addLink(i)

func addAnchorLoop():
	loops.append($AnchorLoop)

func addLoop(index):
	var loop = CHAIN_LOOP.instance()
	loop.setPosition(index)
	loops.append(loop)
	add_child(loop)

func addLink(index):
	var link = CHAIN_LINK.instance()
	link.parentLoop = loops[index]
	link.childLoop = loops[index + 1]
	links.append(link)
	add_child(link)

func _process(delta):
	renderFrame()

func _physics_process(delta):
	updateLoops()
	constrainLinks()

func updateLoops():
	for loop in loops:
		if !loop.anchor and !loop.over:
			applyMovement(loop)

func applyMovement(loop):
	var velocity = calcVelocity(loop)
#	loop.oldPos = loop.pos
	loop.velocity = velocity
	loop.velocity.y += GRAVITY

func calcVelocity(loop):
	return loop.velocity * RESISTANCE * FRICTION
#	return (loop.pos - loop.oldPos) * RESISTANCE * FRICTION

func constrainLinks():
	for link in links:
		var vector = calcLinkVector(link)
		var distance = calcAppliedVelocity(link.childLoop).distance_to(calcAppliedVelocity(link.parentLoop))
		var difference = CHAIN_LINK_LENGTH - distance
		var percentage = difference / distance
		vector *= percentage
		link.childLoop.velocity += vector
#		link.childLoop.pos += vector

func calcLinkVector(link):
	return link.childLoop.pos - link.parentLoop.pos
	
# Possibly not needed, childLoop.pos - parentLoop.pos seems to be working but other things are failing rn
func calcAppliedVelocity(loop):
	return loop.pos + loop.velocity
	
func renderFrame():
	for link in links:
		link.childLoop.position = link.childLoop.pos
		positionLinkBetweenLoops(link)
		rotateLinkBetweenLoops(link)

func positionLinkBetweenLoops(link):
	link.position = link.parentLoop.pos + (calcLinkVector(link) / 2)

func rotateLinkBetweenLoops(link):
	link.global_rotation = link.parentLoop.pos.angle_to_point(link.childLoop.pos)
