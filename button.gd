extends Button

enum State {none, circle, cross}
enum Playing {circle, cross}
var circle = load("res://circle.png")
var cross = load("res://cross.png")
var state: State = State.none
var playing: Playing

var sprite: Sprite2D

signal empty_pressed

func _ready():
	sprite = $"Sprite2D"
	get_tree().get_first_node_in_group("board").playing_signal.connect(_on_board_playing_signal)

func _pressed():
	if state != State.none:
		return
		
	match playing:
		Playing.circle:
			sprite.texture = circle
			state = State.circle
		Playing.cross:
			sprite.texture = cross
			state = State.cross
			
	empty_pressed.emit()

func _on_board_playing_signal(player: int) -> void:
	playing = player
