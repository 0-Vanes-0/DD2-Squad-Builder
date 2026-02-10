class_name ExportSubViewport
extends SubViewport

@export var export_image: ExportImage


func generate_texture() -> Texture:
	var export_image_size: Vector2 = await export_image.apply_info_and_get_size()
	self.size = export_image_size
	await RenderingServer.frame_post_draw
	return self.get_texture()
