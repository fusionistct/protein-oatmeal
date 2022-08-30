extends Node2D

onready var textbox = $Textbox
onready var textLabel = $Textbox/RichTextLabel
onready var textTimer = $Textbox/Timer

onready var player = $Player

var itemsObtained = 0

var hasProtein = false
var hasOats = false
var hasMilk = false

var hasEverything = false

var finishGame = false
var quitGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnText(["Ugh, I'm so tired... I'd love to look at Sophie's reply, but I need a hearty bowl of protein-enhanced oatmeal to start my morning!", "Now where did I leave those OATS, ALMOND MILK, and PROTEIN POWDER?"])

func spawnText(dialog):
	textLabel.dialog = dialog
	textLabel.set_bbcode(dialog[0])
	textLabel.set_visible_characters(0)
	textLabel.page = 0
	textbox.visible = true
	textTimer.start()

func _process(delta):
	if !textbox.visible and finishGame:
		endGame()
	if !textbox.visible and quitGame:
		get_tree().quit()
	else:
		player.canMove = !textbox.visible
		if player.canInteract and Input.is_action_just_pressed("ui_accept"):
			print_debug(player.interactItem)
			player.velocity = Vector2.ZERO
			player.canInteract = false
			var pageOne = ""
			var pageTwo = ""
			if itemsObtained == 0 and player.interactItem != "Stove":
				if player.interactItem == "Protein":
					pageOne = "Got the PROTEIN POWDER!"
					pageTwo = "Still gotta find OATS and ALMOND MILK!"
					hasProtein = true
				elif player.interactItem == "Oats":
					pageOne = "Got the OATS!"
					pageTwo = "Still gotta find PROTEIN POWDER and ALMOND MILK!"
					hasOats = true
				elif player.interactItem == "Milk":
					pageOne = "Got the ALMOND MILK!"
					pageTwo = "Still gotta find OATS and PROTEIN POWDER!"
					hasMilk = true
				spawnText([pageOne, "*Bzzt, bzzt*", "Another text?? Jeez, I waited 3 years of high school to say that stuff, you can wait 3 minutes for me to finish my breakfast!", pageTwo])
				itemsObtained += 1
			elif itemsObtained == 1 and player.interactItem != "Stove":
				if player.interactItem == "Protein":
					hasProtein = true
					pageOne = "Got the PROTEIN POWDER!"
					if hasOats:
						pageTwo = "Whoops, can't get distracted, still need ALMOND MILK!!"
					elif hasMilk:
						pageTwo = "Whoops, can't get distracted, still need OATS!!"	
				elif player.interactItem == "Oats":
					hasOats = true
					pageOne = "Got the OATS!"
					if hasProtein:
						pageTwo = "Whoops, can't get distracted, still need ALMOND MILK!!"
					elif hasMilk:
						pageTwo = "Whoops, can't get distracted, still need PROTEIN POWDER!!"
				elif player.interactItem == "Milk":
					hasMilk = true
					pageOne = "Got the ALMOND MILK!"
					if hasOats:
						pageTwo = "Whoops, can't get distracted, still need PROTEIN POWDER!!"
					elif hasProtein:
						pageTwo = "Whoops, can't get distracted, still need OATS!!"
				spawnText([pageOne, "*Bzzt, bzzt*", "Maybe she completely ignored the text I spent 4 hours writing, and is asking about the Health assignment. Yeah, that's it! Claaassic Sophie.", pageTwo])
				itemsObtained += 1
			elif itemsObtained == 2 and player.interactItem != "Stove":
				if player.interactItem == "Protein":
					pageOne = "Got the PROTEIN POWDER!"
					hasProtein = true
				elif player.interactItem == "Oats":
					pageOne = "Got the OATS!"
					hasOats = true
				elif player.interactItem == "Milk":
					pageOne = "Got the ALMOND MILK!"
					hasMilk = true
				itemsObtained += 1
				hasEverything = true
				spawnText([pageOne, "*Bzzt, bzzt*", "...If I make oatmeal forever, I'll never have to check my phone...", "Hey, that's not a bad idea! To the stove!!"])
			elif player.interactItem == "Stove":
				if !hasEverything:
					spawnText(["I'll need to use this to cook after I get everything."])
				else:
					spawnText(["This is nice. Just me, stirring my oatmeal forever.", "Nothing about this circular motion reminds me of the spiral of anxiety I'm currently in and why did she stop texting me and oh wow oatmeal's done let's eat!!"])
					finishGame = true

func endGame():
	player.canMove = false
	player.position = Vector2(564.904, 130.019)
	spawnText(["Here we go!", "...", "...", "...", "Yum!", "...", "...", "Love oatmeal.", "...", "...", "...", "...", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA FINE I'LL CHECK MY PHONE JUST REJECT ME AND GET IT OVER WITH ANYTHING IS BETTER THAN THIS WAKING HELL-", "...", "...", "Oh...", "Wow...", "You were just as nervous as me?", "...", ":)"])
	finishGame = false
	quitGame = true

func _on_InteractStove_body_entered(body):
	if body.name == "Player":
		player.canInteract = true
		player.interactItem = "Stove"

func _on_InteractStove_body_exited(body):
	player.canInteract = false
	player.interactItem = null


func _on_InteractProtein_body_entered(body):
	if body.name == "Player" and !hasProtein:
		player.canInteract = true
		player.interactItem = "Protein"


func _on_InteractProtein_body_exited(body):
	player.canInteract = false
	player.interactItem = null 


func _on_InteractOats_body_entered(body):
	if body.name == "Player" and !hasOats:
		player.canInteract = true
		player.interactItem = "Oats"


func _on_InteractOats_body_exited(body):
	player.canInteract = false
	player.interactItem = null 


func _on_InteractMilk_body_entered(body):
	if body.name == "Player" and !hasMilk:
		player.canInteract = true
		player.interactItem = "Milk"


func _on_InteractMilk_body_exited(body):
	player.canInteract = false
	player.interactItem = null 
