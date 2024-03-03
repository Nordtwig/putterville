extends Node3D

@export var cam_speed: float = PI / 2
@export var zoom_speed: float = 0.1

var zoom = 0.2


func _input(event):
    if event.is_action_pressed("cam_zoom_in"):
        zoom -= zoom_speed
    if event.is_action_pressed("cam_zoom_out"):
        zoom += zoom_speed
    