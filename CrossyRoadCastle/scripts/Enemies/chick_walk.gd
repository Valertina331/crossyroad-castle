extends State
class_name Walk

@export var enemy: CharacterBody2D
@export var move_speed := 20.0

var move_direction : Vector2
var wander_time : float
var player: CharacterBody2D = null

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	enemy.get_node("Sprite").play("walk")
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player = null
	var closest_distance = INF
	print("Found players:", players.size())
	
	#only consider players visible, 
	#may change this func if the logic of multiplayer is changed
	for p in players:
		if !p.is_dead: 
			var distance = enemy.global_position.distance_to(p.global_position)
			print(distance)
			if distance < closest_distance:
				closest_distance = distance
				closest_player = p

	player = closest_player
	if player:
		print("Enemy targeting:", player.name)
	else:
		print("No valid players found11")
		#Transitioned.emit(self, "Idle")
	
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func Physics_Update(delta: float):
	if enemy:
		enemy.velocity.x = move_direction.x * move_speed
		
	if player == null or player.is_dead:
		#print("Warning: Target player is null or dead, switching to Idle")
		#Transitioned.emit(self, "Walk")
		return
		
	var direction = player.global_position - enemy.global_position
	enemy.target_position = player.global_position
	if direction.length() < 200:
		enemy.player_direction = Vector2(direction.x, 0).normalized()
		enemy.target_position = player.global_position
		Transitioned.emit(self, "Attack")
		
func _ready() -> void:
	if player:
		print("Target player is:", player.name, ", is_dead:", player.is_dead)
