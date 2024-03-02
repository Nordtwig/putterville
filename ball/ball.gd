extends RigidBody3D

signal stopped


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
    if state.linear_velocity.length() < 0.1:
        stopped.emit()
        state.linear_velocity = Vector3.ZERO
    if position.y < -20:
        get_tree().reload_current_scene()


func shoot(angle: float, power: float) -> void:
    var force = Vector3.FORWARD.rotated(Vector3.UP, angle)
    apply_central_impulse(force * power)
