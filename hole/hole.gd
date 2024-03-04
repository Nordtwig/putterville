extends Node3D

enum {AIM, SET_POWER, SHOOT, WIN}

@export var next_hole: PackedScene
@export var power_speed: float = 100
@export var angle_speed: float = 1.1
@export var mouse_sensitivity: float = 150

var angle_change: int = 1
var power: float = 0
var power_change: int = 1
var shots: int = 0
var state = AIM

@onready var hole: Area3D = $Hole


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    hole.body_entered.connect(on_hole_body_entered)
    $Arrow.hide()
    $Ball.position = $Tee.position
    $Ball.stopped.connect(on_ball_stopped)
    change_state(AIM)
    $UI.show_message("Get Ready!")


func _process(delta) -> void:
    if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
        return
    match state: 
        # AIM:
        #     animate_arrow(delta)
        SET_POWER:
            animate_power(delta)
        SHOOT:
            pass
    if state != WIN:
        $GimbalOuter.position = $Ball.position
   

func _input(event):
    if event.is_action_pressed("ui_cancel") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    if event is InputEventMouseMotion:
        if state == AIM:
            $Arrow.rotation.y -= event.relative.x / mouse_sensitivity
    if event.is_action_pressed("click"):
        if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
            return
        match state:
            AIM:
                change_state(SET_POWER)
            SET_POWER:
                change_state(SHOOT)


func change_state(new_state) -> void:
    state = new_state
    match state:
        AIM:
            $Arrow.position = $Ball.position
            $Arrow.show()
        SET_POWER:
            power = 0
        SHOOT:
            $Arrow.hide()
            $Ball.shoot($Arrow.rotation.y, power / 15)
            shots += 1
            $UI.update_shots(shots)
        WIN:
            $Ball.hide()
            $Arrow.hide()
            await get_tree().create_timer(1).timeout
            if next_hole:
                get_tree().change_scene_to_packed(next_hole)


func animate_arrow(delta: float) -> void:
    $Arrow.rotation.y += angle_speed * angle_change * delta
    if $Arrow.rotation.y > PI / 2:
        angle_change = -1
    if $Arrow.rotation.y < -PI / 2:
        angle_change = 1


func animate_power(delta: float) -> void:
    power += power_speed * power_change * delta
    if power >= 100:
        power_change = -1
    if power <= 0:
        power_change = 1
    $UI.update_power_bar(power)


func on_hole_body_entered(body: RigidBody3D) -> void:
    if body.name == "Ball":
        print("Win!")
        change_state(WIN)


func on_ball_stopped() -> void:
    if state == SHOOT:
        change_state(AIM)