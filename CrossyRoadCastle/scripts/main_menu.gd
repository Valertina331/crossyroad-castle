extends Control

#I know this is super repetitive but it kept getting a bug I couldnt figure out how to solve
@onready var player_containers: GridContainer = $PlayerContainers
@onready var javid_tower_0: AnimatedSprite2D = $PanelContainer/TextureRect/JavidTower0
@onready var valentina_tower_1: AnimatedSprite2D = $PanelContainer/TextureRect/ValentinaTower1
@onready var xiaowei_tower_2: AnimatedSprite2D = $PanelContainer/TextureRect/XiaoweiTower2
@onready var locations: Label = $Locations


#Hiding for menus
@onready var title_image: TextureRect = $TitleImage
@onready var play_button: TextureButton = $PlayButton
@onready var grid_container: GridContainer = $GridContainer
@onready var panel_container: PanelContainer = $PanelContainer
@onready var control_button: Button = $ControlButton
@onready var credit_button: Button = $CreditButton
@onready var exit_button: Button = $ExitButton
@onready var credit_panel: Node2D = $CreditPanel
@onready var control_2: Node2D = $Control2





const PLAYER_SELECT = preload("res://scenes/player_select.tscn")

var towerSelectedint = 0
var device: int #This is to be stored in the player so the individual controllers can change the character
var playersPlaying = [] #This is necessary just for gathering players together, but true value is stored in dictionary
var devicesin = [] #This stops the repeating of devices
var towersavailable = []
var playersgood: int
var all_in = false


func _ready():
	towersavailable.append_array([javid_tower_0, valentina_tower_1, xiaowei_tower_2])
	GlobalAudioStreamPlayer.trackchoice = -1
	GlobalAudioStreamPlayer.play_music_level()
	Global.freshStart()
	_restore_players()
	Global.load_game()
	Global.gave_up()

func _on_ControlButton_pressed():
	control_2.visible = true
	Global.sidemenu = true
	
func _on_CreditButton_pressed():
	credit_panel.visible = true
	Global.sidemenu = true
#Function to get all available playable devices on computer
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	devices.append(-1)
	return devices


func _process(fixed):
	hide_for_side_menus()
	_multiplayer_setup()
	get_unjoined_devices()
	tower_animation()
	location_display(towerSelectedint)
	
	
	if playersPlaying.size() > 0 && playersPlaying.size() == Global.get_ready_players():
		all_in = true
	else:
		all_in = false
	
#Start button logic, can create safegaurd for everyone to say ready first
func _on_play_button_pressed():
	if all_in == true:
		var destination = Global.tower_Choice(towerSelectedint)
		var prefix = Global.typePrefix
		Global.freshStart()
		get_tree().change_scene_to_file(destination+str(Global.get_levels_climbed() +1)+prefix)
	
		


#Essentially takes all the devices and the moment someone hits A, or enter will add them as a player, assuming the device hasnt already been used
func _multiplayer_setup():
	for i in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(i, "MMCC"):
			if !devicesin.has(i):
				devicesin.append(i)
				playerjoin(i)
		if MultiplayerInput.is_action_just_pressed(i, "MMS"):
			await get_tree().create_timer(0.1).timeout
			_on_play_button_pressed()

#This is saying hey, if the player size isnt 4, create a player, add it to the people playing, give it this value and placement and add it visually to the screen
func playerjoin(device):
	if playersPlaying.size() <4 :
		var player = PLAYER_SELECT.instantiate()
		playersPlaying.append(player)
		
		var available_number = 1
		var taken_numbers = playersPlaying.map(func(p): return p.playerNumber)
		while available_number in taken_numbers:
			available_number +=1
		
		player.playerNumber = available_number
		player.device = device
		player.characterChoice = 0
		
		player_containers.add_child(player)
		player.connect("imout", Callable(self, "_on_im_out"))
			
		Global.add_to_dict(str(player.playerNumber), player.characterChoice, player.playerNumber, player.device)
		print(Global.playersPlaying)
			

#When this signal is detected removes player and device from arrays then updates number in code
func _on_im_out(value):
		var player_to_remove = null
		for player in playersPlaying:
			if player.device == value:
				player_to_remove = player
				break
				
		if player_to_remove:
			player_to_remove.queue_free()
			playersPlaying.erase(player_to_remove)
			devicesin.erase(value)
			
			
		var key_to_remove = null
		for key in Global.playersPlaying.keys():
			if Global.playersPlaying[key]["device"] == value:
				key_to_remove = key
				break
		if key_to_remove:
			Global.remove_entry(key_to_remove)
			_update_player_numbers()
		

#This is for updating UI needed chatgpt help
func _update_player_numbers():
	for i in range(playersPlaying.size()):
		var new_number = i + 1
		playersPlaying[i].playerNumber = new_number
		playersPlaying[i]._update_UI(new_number)
		Global.playersPlaying[str(new_number)] = {
		"characterChoice": playersPlaying[i].characterChoice,
		"device": playersPlaying[i].device,
		"playerNumber": new_number
		}
		

#Main Menu Repopulation fix
func _restore_players():
	for key in Global.playersPlaying.keys():
		var player_data = Global.playersPlaying[key]
		var player = PLAYER_SELECT.instantiate()
		playersPlaying.append(player)
		
		
		player.playerNumber = player_data["playerNumber"]
		player.device = player_data["device"]
		player.characterChoice = player_data["characterChoice"]
		
		player_containers.add_child(player)
		player.connect("imout", Callable(self, "_on_im_out"))
		playerjoin(player.device)
		devicesin.append(player.device)

func tower_animation():
	for i in towersavailable.size():
		if i != towerSelectedint:
			towersavailable[i].play("Unselected")
		else:
			towersavailable[i].play("Selected")
		
		
func location_display(val):
	match val:
		0:
			locations.text = "BEACH TOWER KINGDOM"
			return locations.text
		1:
			locations.text = "TOWER OF EASTER DAWN"
			return locations.text
		2:
			locations.text = "CANDY TOWER KINGDOM"
			return locations.text

func _on_tower_button_right_pressed():
	print(towerSelectedint)
	if towerSelectedint >= 2:
		towerSelectedint = 0
	else:
		towerSelectedint +=1
		

func _on_tower_button_left_pressed():
	print(towerSelectedint)
	if towerSelectedint <= 0:
		towerSelectedint = 2
	else:
		towerSelectedint -=1


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func hide_for_side_menus():
	if Global.sidemenu == true:
		title_image.visible = false
		play_button.visible = false
		grid_container.visible = false
		panel_container.visible = false
		control_button.visible = false
		credit_button.visible = false
		exit_button.visible = false
		locations.visible = false
		player_containers.visible = false
	else:
		title_image.visible = true
		play_button.visible = true
		grid_container.visible = true
		panel_container.visible = true
		control_button.visible = true
		credit_button.visible = true
		exit_button.visible = true
		locations.visible = true
		player_containers.visible = true
		credit_panel.visible = false
		control_2.visible = false
