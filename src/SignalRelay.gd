extends Node


signal some_signal
signal damage_delt

func _on_some_signal(sig, val = null):
	emit_signal(sig, val)
