extends KinematicBody2D

var y_positions = [100,150,200,500,550]
var initial_position = Vector2.ZERO
var direction = Vector2(1.5,0)
var wobble = 30.0


var health = 1

var Effects = null
onready var Bullet = load("res://Enemy/Bullet.tscn")
onready var Explosion = load("res://Effects/Explosion.tscn")

func _ready():
	initial_position.x = -100
	initial_position.y = y_positions[randi() % y_positions.size()]
	position = initial_position

func _physics_process(_delta):
	position += direction
	position.y = initial_position.y + sin(position.x/20)*wobble
	if position.x >= 1200:
		queue_free()

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		queue_free()


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		body.damage(100)
		damage(100)


func _on_Timer_timeout():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	Effects = get_node_or_null("/root/Game/Effects")
	if Player != null and Effects != null:
		var bullet = Bullet.instance()
		var d = global_position.angle_to_point(Player.global_position) - PI/2
		bullet.rotation = d
		bullet.global_position = global_position + Vector2(0,-40).rotated(d)
		Effects.add_child(bullet)
	
