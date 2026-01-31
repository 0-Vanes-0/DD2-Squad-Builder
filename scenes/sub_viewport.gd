class_name RankSubviewport
extends SubViewport

const SIZE := Vector2i(380, 80)
const IN_TEXT_SIZE := SIZE / 4

@export_group("Required Children")
@export var rank_manager: RankManager


func _ready() -> void:
	assert(rank_manager)


func get_image(ranks_text: String, is_hero: bool) -> Texture2D:
	rank_manager.apply_ranks(ranks_text, is_hero)
	await RenderingServer.frame_post_draw
	var image := self.get_texture().get_image()
	return ImageTexture.create_from_image(image)
