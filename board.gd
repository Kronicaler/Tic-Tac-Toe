extends Sprite2D

enum State {circle, cross, none}

var currently_playing: State = State.circle
signal playing_signal(player: State)

@onready
var right = $right
@onready
var center = $center
@onready
var left = $left
@onready
var btm = $btm
@onready
var btm_right = $btm_right
@onready
var btm_left = $btm_left
@onready
var top = $top
@onready
var top_right = $top_right
@onready
var top_left = $top_left

func _ready():
	for node in get_tree().get_nodes_in_group("board_tile"):
		node.empty_pressed.connect(_on_empty_button_pressed)
	
	playing_signal.emit(currently_playing)

func _on_empty_button_pressed() -> void:
	match currently_playing:
		State.circle:
			currently_playing = State.cross
			playing_signal.emit(currently_playing)
		State.cross:
			currently_playing = State.circle
			playing_signal.emit(currently_playing)
	
	var board = [[top_left,top,top_right], [left,center,right], [btm_left,btm,btm_right]]
	
	var is_a_tie=true
	for i in 3:
		for j in 3:
			if board[i][j].state==0:
				is_a_tie=false
				break
	
	if is_a_tie:
		game_over(State.none)
	
	for i in 3:
		if board[i][0].state == 1 && board[i][1].state == 1 && board [i][2].state == 1:
			game_over(State.circle)
		if board[0][i].state==1 && board[1][i].state==1 && board [2][i].state ==1:
			game_over(State.circle)
		if board[i][0].state == 2 && board[i][1].state == 2 && board [i][2].state == 2:
			game_over(State.cross)
		if board[0][i].state==2 && board[1][i].state==2 && board [2][i].state ==2:
			game_over(State.cross)
	
	if board[0][0].state==1 && board[1][1].state==1 && board[2][2].state==1:
		game_over(State.circle)
	if board[0][2].state==1 && board[1][1].state==1 && board[2][0].state==1:
		game_over(State.circle)
	if board[0][0].state==2 && board[1][1].state==2 && board[2][2].state==2:
		game_over(State.cross)
	if board[0][2].state==2 && board[1][1].state==2 && board[2][0].state==2:
		game_over(State.cross)

func game_over(who_won: State):
	var board = [[top_left,top,top_right], [left,center,right], [btm_left,btm,btm_right]]
	
	for i in 3:
		for j in 3:
			remove_child(board[i][j])
	
	match who_won:
		State.circle:
			self.texture=load("res://circle  won.png")
		State.cross:
			self.texture=load("res://cross  won.png")
		State.none:
			self.texture=load("res://no one won.png")
	
	$"RestartButton".show()
