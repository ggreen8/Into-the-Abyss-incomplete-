extends KinematicBody2D

var motion = Vector2()
var score = 0



func _physics_process(delta):
	var Labelnode = get_parent().get_node("Player/Hud/Control/Score")
	Labelnode.text = str(score)
	var Player = get_parent().get_node("Player")
	look_at(Player.position)
	position += (Player.position - position)/30
	move_and_collide(motion)


func _enemy_killed():
	queue_free()


func _on_Area2D_body_entered(body):
	var Labelnode = get_parent().get_node("Player/Hud/Control/Score")
	if "Bullet" in body.name:
		score +=1
		Labelnode.text = str(score + 1)
		_enemy_killed()
		


