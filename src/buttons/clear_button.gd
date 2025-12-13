class_name ClearButton
extends Button

@export var rank4_box: RankBox
@export var rank3_box: RankBox
@export var rank2_box: RankBox
@export var rank1_box: RankBox


func _ready() -> void:
	assert(rank4_box and rank3_box and rank2_box and rank1_box)


func _on_pressed() -> void:
	rank1_box.hero_path_draggable.hero_path = Data.HeroesPaths.NONE
	rank1_box.hero_path_draggable.texture_rect.texture = Data.heroes_textures[Data.HeroesPaths.NONE]
	rank2_box.hero_path_draggable.hero_path = Data.HeroesPaths.NONE
	rank2_box.hero_path_draggable.texture_rect.texture = Data.heroes_textures[Data.HeroesPaths.NONE]
	rank3_box.hero_path_draggable.hero_path = Data.HeroesPaths.NONE
	rank3_box.hero_path_draggable.texture_rect.texture = Data.heroes_textures[Data.HeroesPaths.NONE]
	rank4_box.hero_path_draggable.hero_path = Data.HeroesPaths.NONE
	rank4_box.hero_path_draggable.texture_rect.texture = Data.heroes_textures[Data.HeroesPaths.NONE]
