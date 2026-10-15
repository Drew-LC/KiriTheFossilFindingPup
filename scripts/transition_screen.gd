extends CanvasLayer

signal on_transition_finished

@onready var color: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skull_texture: ColorRect = $skullTexture

func _ready() -> void:
	color.visible = false 
	skull_texture.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transition(animation_name: String):
	color.visible = true 
	skull_texture.visible = true
	match animation_name:
		"travel":
			animation_player.play("fade_to_black")
		"skull":
			animation_player.play("fade_to_black_skull")

func _on_animation_finished(animation_name : String) -> void:
	match animation_name:
		"fade_to_black":
			on_transition_finished.emit()
			animation_player.play("fade_to_normal")
			
		"fade_to_normal":
			color.visible = false
			skull_texture.visible = false
			
		"fade_to_black_skull":
			on_transition_finished.emit()
			animation_player.play("fade_to_normal_skull")

		"fade_to_normal_skull":
			color.visible = false
			skull_texture.visible = false
