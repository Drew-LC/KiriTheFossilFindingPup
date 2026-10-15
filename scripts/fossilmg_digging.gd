extends Control

# Preload the dirt particle.
@onready var dirt_particle = preload("uid://busex87x6xojy")
# Variables determining the particles' properties.
@onready var num_particles := 100.0
@onready var particle_x_mostleft := 84.0 #In pixels.
@onready var particle_x_mostright := 1068.0 #In pixels.
@onready var particle_y_mosttop := 84.0 #In pixels.
@onready var particle_y_mostbottom := 556.0 #In pixels.
@onready var current_z_index := 0

#Node variables.
@onready var bg: AnimatedSprite2D = $BG

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Spawn in num_particles number of particles.
	for i in num_particles:
		var dirt_instance = dirt_particle.instantiate()
		add_child(dirt_instance)
		# Increment each new dig spot's z-index.
		dirt_instance.z_index = current_z_index
		current_z_index += 1
		# Randomize the position of the particles.
		dirt_instance.position = Vector2(randi_range(particle_x_mostleft, particle_x_mostright), randi_range(particle_y_mosttop, particle_y_mostbottom))
	match HUD.current_quest:
		"trex": bg.animation = "trex"
		"anky": bg.animation = "anky"
		"mame": bg.animation = "mame"
		"pter": bg.animation = "pter"
		"": bg.animation = "trex"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# For one click, make one dig sfx.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and SelectTools.selected_paw:
		AudioPlayer.play_sound_pitch("tool_paw")
