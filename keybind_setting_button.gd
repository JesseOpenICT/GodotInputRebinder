extends HBoxContainer


@export var button : String # The input you want to bind to. Something like "ui_left" or "jump"
@export var label : String # The label for the button. This appears in the interface.
var keybind : InputEvent

func _ready() -> void:
	$Label.text = label # Overwrite the text shown
	Keybind.complete.connect(unwait) # Connect to the global variable
	reload() # Set the button contents


func reload() -> void:
	if InputMap.action_get_events(button):
		$Button.text = InputMap.action_get_events(button)[0].as_text()


func rebind() -> void: # this is the script that runs when you press the button
	Keybind.looking = button # Start looking for an input for this button's keybind
	$Button.text = "press key..." 
	$Button.disabled = true # Disables the button

func unwait() -> void:
	reload()
	$Button.disabled = false
