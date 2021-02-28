extends KinematicBody2D
signal Health_updated(Health)
signal killed()

var Damage = 25
var BulletSpeed = 250
var Motion = Vector2()
var Speed = 400
var Bullet = preload("res://Bullet.tscn")
export (float) var Max_Health = 100
var score = 0

onready var Health = Max_Health setget _set_Health
onready var invulnerability_time = $invulnerability
onready var Animation = $AnimationPlayer
onready var audio = $AudioStreamPlayer2D
onready var death = $Audio


func get_input():
	Motion = Vector2()
	if Input.is_action_pressed("up"):
		Motion.y -=1
	if Input.is_action_pressed("down"):
		Motion.y +=1
	if Input.is_action_pressed("left"):
		Motion.x -=1
	if Input.is_action_pressed("right"):
		Motion.x +=1
		
	Motion = Motion.normalized() * Speed 
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		fire()
		
func fire():
		var bullet_instance = Bullet.instance()
		bullet_instance.position = get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(BulletSpeed,0).rotated(rotation))
		get_tree().get_root().call_deferred("add_child" ,bullet_instance)
		audio.play()
	
	
func _physics_process(delta):
	get_input()
	Motion = move_and_slide(Motion)
	
func kill():
	get_tree().reload_current_scene()
	
	





func _set_Health(value):
	var prev_Health = Health
	Health = clamp(value, 0, Max_Health)
	if Health != prev_Health:
		emit_signal("Health_updated" , Health)
	if Health == 0:
		kill()
		emit_signal("killed")




func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		kill()
		death.play()
		if invulnerability_time.is_stopped():
			invulnerability_time.start()
			Animation.play("Damage")


func _on_Powerup_body_entered(body):
	Speed = 1000
