extends Node

var score = 0
@onready var score_label: Label = $ScoreLabel

func add_point():
	score += 1
	score_label.text = "Congrats! You collected %s coins."%[score]
	if score == 6:
		score_label.text = "Congrats!! You collected all 6 coins!"
