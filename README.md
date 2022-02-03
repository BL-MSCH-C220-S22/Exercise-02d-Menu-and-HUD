# Exercise-02d-Menu-and-HUD

Exercise for MSCH-C220

Fork the repository. When that process has completed, make sure that the top of the repository reads `[your username]/Exercise-02d-Menu-and-HUD`. Edit the LICENSE and replace BL-MSCH-C220-S22 with your full name. Commit your changes.

Press the green "Code" button and select "Open in GitHub Desktop". Allow the browser to open (or install) GitHub Desktop. Once GitHub Desktop has loaded, you should see a window labeled "Clone a Repository" asking you for a Local Path on your computer where the project should be copied. Choose a location; make sure the Local Path ends with "Exercise-02d-Menu-and-HUD" and then press the "Clone" button. GitHub Desktop will now download a copy of the repository to the location you indicated.

Open Godot. In the Project Manager, tap the "Import" button. Tap "Browse" and navigate to the repository folder. Select the project.godot file and tap "Open".

You will now see where we left off in Exercise-02c: Your ship should be able to shoot and destroy the asteroids (and the small ones they break into). An enemy will oscillate across the screen shooting at the ship. If your ship is destroyed, it will respawn.

This is what you will need to accomplish as part of this exercise:

Main Menu:
  - Create a new "User Interface" scene. Rename the resulting Control node "Main_Menu". The main menu should have a Label ("Welcome to the Space Shooter!"), a "Play" button, and a "Quit" button.
  - Attach a script to the Main_Menu node. Save it as `res://UI/Main_Menu.gd`
  - Attach signals to the Play and Quit buttons. Connect them to the Main_Menu script. If the Play button is pressed, execute the following: `var _scene = get_tree().change_scene("res://Game.tscn")`. If the Quit button is pressed, `get_tree().quit()`
  - Save the scene as `res://UI/Main_Menu.tscn`. In Project Settings->Application->Run, update the Main Scene to be `res://UI/Main_Menu.tscn`

Global.gd:
  - Update Global.gd to contain the following:
  ```
extends Node

var VP = Vector2.ZERO

var score = 0
var time = 100
var lives = 5

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()
	VP = get_viewport().size
	var _signal = get_tree().get_root().connect("size_changed", self, "_resize")

func _resize():
	VP = get_viewport().size

func reset():
	get_tree().paused = false
	score = 0
	time = 100
	lives = 5
  ```

Changing window sizes:
  - Everywhere you have included the value `1024` (most of the scripts), replace it with `Global.VP.x`. Everywhere you have included the value `600`, replace it with `Global.VP.y`

End-game Screen:
  - Create a new "User Interface" scene. Rename the Control node to "End_Game". The End-game screen should have a Label (empty for now), a Play button (labeled "Play again?") and a Quit button.
  - Attach a script to End_Game (`res://UI/End_Game.gd`). The `_ready()` callback should be as follows:
  ```
func _ready():
	$Label.text = "Thanks for playing! Your final score was " + str(Global.score) + "."
  ```
  - The functionality of the Play and Quit buttons should be the same as the main menu, except the Play button should first call `Global.reset()`
  - Save the scene as `res://UI/End_Game.tscn`


HUD:
  - In Game.tscn, add a new child to the Game node: a CanvasLayer node. Rename it "UI"
  - As a child of UI, add a Control node. Rename it "HUD" 
  - Add three Label nodes as children of UI: "Score", "Time", and "Lives". Score should be positioned in the top-left corner, Time should be right-justified in the top-right corner, and Lives should be in the bottom-left corner
  - Add a Timer node as a child of UI. Set it to AutoStart
  - Attach a script to UI: `res://UI/UI.gd`. It should be as follows
  ```
extends Control

func _ready():
	Global.update_score(0)
	Global.update_time(0)
	Global.update_lives(0)

func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_lives():
	$Lives.text = "Lives: " + str(Global.lives)

func update_time():
	$Time.text = "Time: " + str(Global.time)

func _on_Timer_timeout():
	Global.update_time(-1)
  ```
  - Connect a timeout() signal from the Timer node to the UI script. It should connect with the already-defined `_on_Timer_timeout()` callback


Back to Global.gd:
  - We now need to add the `update_score()`, `update_lives()`, and `update_time()` functions to `res://Global.gd`
  - `update_score()` will appear as follows. I will leave it to you to adapt the other two functions:
  ```
func update_score(s):
	score += s
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_score()

  ```
  - If the score or time ever go to zero, go to the end-game screen with this statement: `var _scene = get_tree().change_scene("res://UI/End_Game.tscn")`


Connecting everything up:
  - If the Player ever dies, call `Global.update_lives(-1)`
  - If the large Asteroid is destroyed, call `Global.update_score(100)`
  - If a small Asteroid is destroyed, call `Global.update_score(200)`
  - If a the Enemy is destroyed, call `Global.update_score(500)`


In-game Menu:
  - In `res://Game.tscn`, as a child of UI, add a new Control node. Rename it "Menu"
  - As a child of Menu, add a ColorRect, A Label, a Restart button, and a Quit button
  - The Color for the ColorRect should be RGBA: 0, 0, 0, 64. Center the ColorRect and cause it to take up most of the window
  - Attach a script to the Menu node: `res://UI/Menu.gd`:
  ```
extends Control

func _ready():
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		if not visible:
			get_tree().paused = true
			show()
		else:
			get_tree().paused = false
			hide()
  ```
  - Attach Signals to the Restart button and the Quit button and connect them to `res://UI/Menu.gd`
  - The Restart button should call `Global.reset()` and then should `var _scene = get_tree().change_scene("res://Game.tscn")`
  - If the Quit button is pressed, `get_tree().quit()`
  - Finally, select the Menu node, and in the Inspector, set the Pause Mode to "Process"


Test it and make sure this is working correctly. When you start the game, you should be presented with a main menu that will invite you into the game. While playing, you should see information on-screen which should indicate your score, lives, and remaining time. If you press escape, you should see an in-game menu. If the game ends, you should be presented with an end-game screen.

Quit Godot. In GitHub desktop, you should now see the updated files listed in the left panel. In the bottom of that panel, type a Summary message (something like "Completes the exercise") and press the "Commit to master" button. On the right side of the top, black panel, you should see a button labeled "Push origin". Press that now.

If you return to and refresh your GitHub repository page, you should now see your updated files with an indication of when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (`https://github.com/[username]/Exercise-02d-Menu-and-HUD`) on Canvas.

The final state of the file should be as follows (replacing my information with yours):
```
# Exercise-02d-Menu-and-HUD

Exercise for MSCH-C220

A basic space-shooter arcade game, created in Godot.

## Implementation

Created using [Godot 3.4.2](https://godotengine.org/download)

Assets are provided by [Kenney.nl](https://kenney.nl/assets/space-shooter-extension), provided under a [CC0 1.0 Public Domain License](https://creativecommons.org/publicdomain/zero/1.0/).

The explosion spritesheet was released into the public domain by [StumpyStrust](https://opengameart.org/content/explosion-sheet)

## References
None

## Future Development
Advanced features?

## Created by
Jason Francis
```
