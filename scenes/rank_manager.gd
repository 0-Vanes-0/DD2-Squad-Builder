class_name RankManager
extends Node2D

@export_group("Required Children")
@export var rank_1_empty: Line2D
@export var rank_2_empty: Line2D
@export var rank_3_empty: Line2D
@export var rank_4_empty: Line2D
@export var line_yellow: Line2D
@export var rank_1_yellow: Polygon2D
@export var rank_2_yellow: Polygon2D
@export var rank_3_yellow: Polygon2D
@export var rank_4_yellow: Polygon2D
@export var line_blue: Line2D
@export var rank_1_blue: Polygon2D
@export var rank_2_blue: Polygon2D
@export var rank_3_blue: Polygon2D
@export var rank_4_blue: Polygon2D

var original_points: PackedVector2Array


func _ready() -> void:
	assert(rank_1_empty and rank_2_empty and rank_3_empty and rank_4_empty and line_yellow and rank_1_yellow and rank_2_yellow and rank_3_yellow and rank_4_yellow and line_blue and rank_1_blue and rank_2_blue and rank_3_blue and rank_4_blue)
	original_points = line_yellow.points.duplicate()


func apply_ranks(ranks_text: String, is_hero: bool):
	_hide_all()

	var ranks := ranks_text.split()
	var is_group := false
	if ranks[ranks.size() - 1] == "-":
		is_group = true
		ranks.resize(ranks.size() - 1)

	var all_ranks := ["1", "2", "3", "4"]
	if is_hero:
		all_ranks = ["4", "3", "2", "1"]
	
	var points := PackedVector2Array()
	for i in all_ranks.size():
		if all_ranks[i] in ranks:
			if is_hero:
				_get_yellow(all_ranks[i]).show()
			else:
				_get_blue(all_ranks[i]).show()
			
			if is_group:
				points.append(original_points[i])
		else:
			_get_empty(all_ranks[i], is_hero).show()
	
	
	if is_group:
		if is_hero:
			line_yellow.clear_points()
			line_yellow.points = points
			line_yellow.show()
		else:
			line_blue.clear_points()
			line_blue.points = points
			line_blue.show()


func _get_empty(rank_number: String, is_hero := false) -> Line2D:
	if is_hero:
		match rank_number:
			"4":
				return rank_1_empty
			"3":
				return rank_2_empty
			"2":
				return rank_3_empty
			"1":
				return rank_4_empty
			_:
				assert(false, "Invalid rank number: %s" % rank_number)
				return null
	else:
		match rank_number:
			"1":
				return rank_1_empty
			"2":
				return rank_2_empty
			"3":
				return rank_3_empty
			"4":
				return rank_4_empty
			_:
				assert(false, "Invalid rank number: %s" % rank_number)
				return null


func _get_yellow(rank_number: String) -> Polygon2D:
	match rank_number:
		"4":
			return rank_1_yellow
		"3":
			return rank_2_yellow
		"2":
			return rank_3_yellow
		"1":
			return rank_4_yellow
		_:
			assert(false, "Invalid rank number: %s" % rank_number)
			return null


func _get_blue(rank_number: String) -> Polygon2D:
	match rank_number:
		"1":
			return rank_1_blue
		"2":
			return rank_2_blue
		"3":
			return rank_3_blue
		"4":
			return rank_4_blue
		_:
			assert(false, "Invalid rank number: %s" % rank_number)
			return null


func _hide_all():
	var all_ranks := ["1", "2", "3", "4"]
	for i in all_ranks.size():
		_get_blue(all_ranks[i]).hide()
		_get_empty(all_ranks[i]).hide()
		_get_yellow(all_ranks[i]).hide()
		line_blue.hide()
		line_yellow.hide()
