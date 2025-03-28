extends Control

#For removing a players device from the main menu screen
signal imout(value:int)
#All the variables needed for the square representation on the screen
@onready var player_frame_ext: TextureRect = $PlayerFrameExt
@onready var player_frame_int: TextureRect = $PlayerFrameInt
@onready var sprite: Sprite2D = $Sprite
@onready var player_num_label: Label = $PlayerNumLabel
@onready var maxvalue = Global.availableCharacters
@onready var readylabel: Label = $Ready

var sidemenu

var playerNumber : int
var characterChoice : int
var device: int

var playing = true
var playerReady = false

#Will always default to the first character in sheet, in this case fish legs
func _ready():
	characterChoice = 0
	_display_setup()


func _process(delta):
	var sidemenu = Global.sidemenu
	
	if sidemenu == true:
		visible = false
	else:
		visible = true
	
	letsgobuddy()
	if !Global.playersPlaying.has(str(playerNumber)):
		queue_free()
		return
	#this just allows for the updating of the character and its place in the dictionary in real time
	choose_Character()
	
	var player_key = str(playerNumber)
	var playerdata = Global.get_entry(player_key)
	
	if playing and playerdata["characterChoice"] != characterChoice:
			playerdata["characterChoice"] = characterChoice
 
	
func update_sprite(val): #Same method as before, character choice changes with values added on via button placement. these will instead be maniuplated by xiaoweis character select screen
	characterChoice += val
	characterChoice = min(characterChoice, maxvalue)
	characterChoice = max(0, characterChoice)
	sprite.frame = characterChoice

func choose_Character(): #Only the device assigned can change your character
	if playing && playerReady == false:
		if MultiplayerInput.is_action_just_pressed(device, "move_left"):
			_on_left_arrow_pressed()
		if MultiplayerInput.is_action_just_pressed(device, "move_right"):
			_on_right_arrow_pressed()
	
	#To drop out made sense to put this here
	if MultiplayerInput.is_action_just_pressed(device, "cancel"):
		if playerReady == true:
			playerReady = false
			readylabel.visible = false
			Global.change_ready_players(-1)
		else: 
			playerReady == false
			playing = false
			emit_signal("imout", device)
	
func letsgobuddy():
	if MultiplayerInput.is_action_just_pressed(device, "MMCC") && playerReady == false:
			Global.change_ready_players(+1)
			readylabel.visible = true
			playerReady = true

func _display_setup():
	match playerNumber: #Simply chanages the color and label
		1:
			player_frame_ext.modulate = Color.RED
			player_frame_int.modulate = Color.INDIAN_RED
			player_num_label.text = "P1"
		2:
			player_frame_ext.modulate = Color.ROYAL_BLUE
			player_frame_int.modulate = Color.DEEP_SKY_BLUE
			player_num_label.text = "P2"
			
		3:
			player_frame_ext.modulate = Color.LIME_GREEN
			player_frame_int.modulate = Color.GREEN
			player_num_label.text = "P3"
			
		4:
			player_frame_ext.modulate = Color.ORANGE
			player_frame_int.modulate = Color.YELLOW
			player_num_label.text = "P4"



func _on_right_arrow_pressed():#max value will be determined by the frames of available characters
	if characterChoice != maxvalue:
		update_sprite(+1)
	else:
		characterChoice = 0
		sprite.frame = characterChoice

func _on_left_arrow_pressed():
	if characterChoice !=0:
		update_sprite(-1)
	else:
		characterChoice = maxvalue
		sprite.frame = characterChoice

#Only working method to get the numbver to change
func _update_UI(new_number):
	playerNumber = new_number
	_display_setup()
	
