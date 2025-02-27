extends Node

#This dictionary is what will call all the characters post character selection

var playersPlaying  = {}

# Everything here needs to be saved in Json
var levelsProgressed = 0
var goldCoin = 0
var purpleCoin = 0
var heartsActive = 3
var availableCharacters = 4 # Only two for testing purposes change to reflect full character list


#Early Implementation may delete later
enum{JavidTower, XiaoweiTower,ValentinaTower} # Javid = 0, Xiaowei = 1, Valentina = 2
var currentTower: int


#Booleans to save when characters are unlocked will flesh out more later


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Setting up foundation for vairables that will need to be accessed
# Character Selection Done via a sheet, frame # will determine character
# Frame # will always be the main way of determining whats what stored as characterChoice
# Device stores the device used to play
# PlayerNumber is repetitive but dont want to break it
func add_to_dict(key: String, characterChoice: int, playerNumber: int, device : int):
	playersPlaying[key] = {
		"characterChoice": characterChoice,
		"device": device,
		"playerNumber": playerNumber
		}
		
		
func get_entry(key:String) -> Dictionary:
	if playersPlaying.has(key):
		return playersPlaying[key]
	return{}

#Will use for deleting a choice
func remove_entry(key: String):
	playersPlaying.erase(key)
	

#All of these functions exist soleley for returning info for levels


func get_current_yellow_coins():
	return goldCoin

func get_current_purple_coins():
	return purpleCoin	
	
func change_yellow_coins(val: int):
	goldCoin += val
	
func change_purple_coins(val: int):
	purpleCoin += val

func add_to_floor_climbed(val):
	levelsProgressed += val

func get_levels_climbed():
	return levelsProgressed
	
func get_current_health():
	return heartsActive
	
func change_health(val):
	heartsActive += val
	return heartsActive
