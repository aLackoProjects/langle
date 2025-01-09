extends Control
var index = 1
var wordle_square = preload("res://words.tscn")
var letter_button = preload("res://letter_button.tscn")
@onready var letter_button_root = $letters/C

func submit(new_text):
	$words.set_index(index)
	index += 1
	GameGlobal.check(new_text)
	$words.set_active(index)
	if index == 6 or (GameGlobal.cur_guessed_word.to_upper() == GameGlobal.answer_word):
		$timerThing.start()
	GameGlobal.active_index = index

func reset():
	print("Resetting game using MAIN method")
	get_node("words").queue_free()
	get_node("words").name = "SJOIJDSIOJSIOJ"
	var ws = wordle_square.instantiate()
	ws.scale = Vector2(1.2,1.2)
	ws.anchors_preset = 5
	ws.connect("submit",submit)
	ws.name = "words"
	add_child(ws)
	ws.position = Vector2(1200,130)
	index = 1
	get_node("hud").call_deferred("reparent",$background)
	get_node('hud').call_deferred("reparent",self)
	for letter in letter_button_root.get_children():
		letter.queue_free()
	
	for i in range(len(GameGlobal.valid_letters)):
		var letter = GameGlobal.valid_letters[i]
		var lb = letter_button.instantiate()
		lb.scale = Vector2(1,1)
		lb.position = Vector2(floor(i % 3)*420,floor(i/3)*195)
		lb.letter = letter.to_upper()
		lb.connect("letter_pressed",on_alt_letter_press)
		letter_button_root.add_child(lb)
	letter_button_root.set_custom_minimum_size(Vector2(0,(floor(len(GameGlobal.valid_letters)/3))*195))
	get_node("letters").call_deferred("reparent",$background)
	get_node('letters').call_deferred("reparent",self)
	get_node("special_char").call_deferred("reparent",$background)
	get_node('special_char').call_deferred("reparent",self)

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		pass

func _ready():
	reset()

#OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://mods"))
func on_alt_letter_press(letter):
	$words.funky_alt_letter_press_openBracket_the_cooler_alt_letter_press_closeBracket(letter)

func scuffed_fix():
	$hud.end_game()
