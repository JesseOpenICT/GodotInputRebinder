# GodotInputRebinder
Simple Godot script that lets users re-bind inputs. Loads the inputs when starting the game and saves them to a Json file.

I built this system because I was disgruntled with the complexity of the systems shown in available tutorials. This system is simple and short.

IMPORTANT
/!\ keybind.gd should be a global variable.
/!\ The system ONLY looks for keyboard key and mouse button inputs. More, such as controller inputs, could relatively easily be added.
/!\ The system currently only allows for a single input per key.
/!\ A default should still be set in the project settings. It will be used if no save data for the input is present.
/!\ Everything is saved to a seperate JSON file.



This folder contains:
- keybind.gd
  - This script should be added as a global variable.
  - It waits for its "looking" variable to be set to an input, then changes that input's keybind when a button is pressed.
    
- keybind_setting_button.gd
  - The script for a button with a label next to it. It exports two variables.
  - One variable sets the label's text for the user.
  - One variable sets what input the button rebinds.
 
- keybind_settings_button.tscn
  - The scene for the keybind settings.
  - Used in keybind_settings.tscn but you could put them anywhere.
  - Consider adding a theme, nobody likes an otherwise good looking game having default Godot UI.

- keybind_settings.tscn
  - A scene containing four keybind_settings_buttons.
  - They rewrite ui_left, ui_right, ui_up and ui_down.



Any changed inputs get loaded from and saved to a Json file. 
I love Json files they just kinda work which is exactly what I want from them.

If no saved data is available, the inputs specified in your project settings will be used.


The system currently has a weakness where it only permits for one keybind per key.
