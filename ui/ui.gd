extends CanvasLayer

@onready var shots = $MarginContainer/VBoxContainer/Shots
@onready var power_bar: TextureProgressBar = $MarginContainer/VBoxContainer/PowerBar

var bar_textures: Dictionary = {
    "green": preload("res://assets/bar_green.png"),
    "yellow": preload("res://assets/bar_yellow.png"),
    "red": preload("res://assets/bar_red.png"),
}


func update_shots(value: int) -> void:
    shots.text = "Shots: %s" % value


func update_power_bar(value: int) -> void:
    power_bar.texture_progress = bar_textures["green"]
    if value > 70:
        power_bar.texture_progress = bar_textures["red"]
    elif value > 40:
        power_bar.texture_progress = bar_textures["yellow"]
    power_bar.value = value


func show_message(text: String) -> void:
    $Message.text = text
    $Message.show()
    await get_tree().create_timer(2).timeout
    $Message.hide()
