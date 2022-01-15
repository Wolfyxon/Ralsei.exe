extends Node

export var randomStuff = false

var toType = ""
var global_ip = []
var ip_config = []

func get_stuff_thread():
	OS.execute("CMD.exe", ["/c", "curl", '"http://myexternalip.com/raw"'],true, global_ip)
	global_ip = global_ip[0]
	
	toType += "Global IP:"+global_ip
	
	
	OS.execute("CMD.exe", ["/c", "ipconfig"],true, ip_config)
	ip_config = String(ip_config).replace("[","").replace("]","")
	
	
	toType += ip_config
	
	var systeminfo = []
	OS.execute("CMD.exe", ["/c", "systeminfo"],true, systeminfo)
	systeminfo = String(systeminfo).replace("[","").replace("]","")
	
	toType += systeminfo
	
onready var thread = Thread.new()
func _ready():
	OS.set_window_title(" ")
	thread.start(self,"get_stuff_thread")

	$AnimationPlayer.play("main")
	$AudioStreamPlayer.play()
	pass

func _physics_process(delta):
	OS.set_window_always_on_top(true)
	OS.move_window_to_foreground()
	
	$CPUParticles2D.emitting = randomStuff
	if $Label.get_visible_line_count() > 33: $Label.text = ""
	
	if randomStuff:

		OS.window_position.x += rand_range(-30,30)
		OS.window_position.y += rand_range(-30,30)
		
		OS.window_per_pixel_transparency_enabled = true
		
		if Input.is_action_just_pressed("close"):
			#OS.alert("Nice you found a way to close this \nit was just a joke virus, it doesn't harm your PC or leak your IP adress, hope you enjoyed lol")
			yield(get_tree().create_timer(3),"timeout")
			get_tree().quit()
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	
	OS.window_borderless = true
	$bigLabel.text = global_ip
	$bigLabel/AnimationPlayer.play("rgb")
	randomStuff = true
	
	for ch in toType:
		yield(get_tree().create_timer(0.01),"timeout")
		$Label.text += ch


func _on_Timer_timeout():
	if randomStuff:
		$Sprite.scale.x += random(-0.5,0.5,true)
		$Sprite.scale.y += random(-0.5,0.5,true)
		
		if random(0,15,false) == 1:
			$Sprite.self_modulate = Color(255,255,255,255)
			$Timer.stop()
			yield(get_tree().create_timer(0.05),"timeout")
			$Timer.start()
		else:
			$Sprite.self_modulate = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1)

#this function and rand_range returns random numbers in other way
func random(down, top,doubleVal):
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var rannum
	if doubleVal:
		rannum = RNG.randf_range(down, top)
	else:
		rannum = int(RNG.randf_range(down, top))
	
	return rannum
