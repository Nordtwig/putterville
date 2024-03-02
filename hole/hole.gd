extends Node3D

enum {AIM, SET_POWER, SHOOT, WIN}

@export var power_speed: float = 100
@export var angle_speed: float = 1.1

var angle_change: int = 1
var power: float = 0
var power_change: int = 1
var shots: int = 0
var state = AIM

@onready var hole: Area3D = $Hole


func _ready() -> void:
    hole.body_entered.connect(on_hole_body_entered)
    $Arrow.hide()
    $Ball.position = $Tee.position
    change_state(AIM)
    $UI.show_message("Get Ready!")


func _process(delta) -> void:
    match state: 
        AIM:
            animate_arrow(delta)
        SET_POWER:
            animate_power(delta)
        SHOOT:
            pass
   

func _input(event):
    if event.is_action_pressed("click"):
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
            $UI.show_message("Win!")


func animate_arrow(delta: float) -> void:
    $Arrow.rotation.y += angle_speed * angle_change * delta
    if $Arrow.rotation.y > PI / 2:
        angle_change = -1
    if $Arrow.rotation.y < -PI / 2:
        angle_change = KEY_1


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