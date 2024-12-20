extends Node

const PATH : String = "user://Keybinds.json" # The path to which you save your keybinds. 
const INPUTS : Array[String] = [ # The inputs you want to be able to rebind.
	"ui_up", "ui_down", "ui_left", "ui_right",
]
var looking : String # The button that's looking for an input to be changed. If "" it isn't looking for anything
signal complete # Tells the buttons you succesfully rebound something


func _ready() -> void:
	load_save() # Fetches all the saved inputs.


func _input(event: InputEvent) -> void:
	if looking and (event is InputEventKey or event is InputEventMouseButton) and event.pressed: 
		# If you're looking for an input, and the input is actually a button. 
		# Doesn't work on controller buttons yet
		InputMap.action_erase_events(looking) # Clear existing inputs and 
		InputMap.action_add_event(looking, event) # Adds the new one
		
		looking = "" # Stop looking for a new input
		await get_tree().create_timer(0.2).timeout # Wait a moment
		complete.emit() # Enable the buttons again
		save() 
		load_save() # By immediately reloading the data we prevent double click from being a problem and similar issues


func save():
	var events : Dictionary = {} # Empty dictionary to store all events
	
	for action_name in INPUTS: # For each input you want to rebind. For INPUTS constant see top of page
		for input in InputMap.action_get_events(action_name):
			var saved_input
			if input is InputEventKey: # inputs get formatted as ["key/mouse", int] where the int is the key. ["key", 65] is A for instance
				saved_input = ["key", input.keycode] 
			elif input is InputEventMouseButton:
				saved_input = ["mouse", input.button_index]
			if saved_input:
				events[action_name] = saved_input # Save to the intended event. Looks like "left: ["key", 65]"
	
	# Save the inputs to a JSON file
	var savedata = JSON.stringify(events)
	var save_game = FileAccess.open(PATH, FileAccess.WRITE)
	save_game.store_line(savedata)
	print('saved')


func load_save():
	var events = {} # Empty dictionary again not unlike the save() fuction but it gets fetched from the Json
	if FileAccess.file_exists(PATH):
		var savetext = FileAccess.get_file_as_string(PATH)
		var savedata = JSON.parse_string(savetext)
		if savedata:
			events = savedata
	
	if events: # IF we have save data. Else you'll default to the keys specified in the project settings
		for action in events.keys(): # For every item in the fetched dictionary we remove then rewrite a key
			InputMap.action_erase_events(action)
			if events[action][0] == "key": # Key and MouseButton events are built slightly differnetly and thus written slightly differently
				var input = InputEventKey.new() # Make a new InputEventKey
				input.keycode = events[action][1] # Override what key it's actually referring to
				InputMap.action_add_event(action, input) # And set the input for real
			elif events[action][0] == "mouse":
				var input = InputEventMouseButton.new()
				input.button_index = events[action][1]
				InputMap.action_add_event(action, input)
