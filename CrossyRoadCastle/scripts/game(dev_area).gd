extends Node2D

@onready var player: player = $Player
@onready var player2: player = $Player2
@onready var player3: player = $Player3
@onready var player4: player = $Player4

# Called when the node enters the scene tree for the first time.
func _process(delta):
	pass
	
func _ready():
	_the_setup()
		


func _the_setup():
	if Global.isPlayer1active == true:
		$Player.visible = true
		$Player.playerChoice = Global.player1Choice
		$Player.device = Global.player1device

	if Global.isPlayer2active == true:
		$Player2.visible = true
		$Player2.playerChoice = Global.player2Choice
		$Player2.device = Global.player2device
		
	if Global.isPlayer3active == true:
		$Player3.visible = true
		$Player3.playerChoice = Global.player3Choice
		$Player3.device = Global.player3device
		
	if Global.isPlayer4active == true:
		$Player4.visible = true
		$Player4.playerChoice = Global.player4Choice
		$Player4.device = Global.player4device
