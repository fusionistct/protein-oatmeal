extends KinematicBody2D

onready var interactIcon = $InteractIcon

export (int) var speed = 200
var canMove = true
onready var canInteract = false
var interactItem = null

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if canMove:
		velocity = velocity.normalized() * speed
	else:
		velocity = Vector2.ZERO

func _physics_process(delta):
	interactIcon.visible = canInteract
	get_input()
	velocity = move_and_slide(velocity)
