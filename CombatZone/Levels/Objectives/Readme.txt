# Objective instructions.

Allowing objectives in your level
 1. In your level's gdscript, provide a way for the level to instance global objectives
 - This can be through the Global.register_all command which takes a player input, 
 or place a Global.register_objectives after player registration.

 Adding objectives to your level.
 Part 1: The Base Objective itself
 You need a level_objective class in order to have proper objectives in your level
 To do that:
   1. Goto res://Levels/Objectives and find the level_objective.tscn scene
   2. Drag that into your level scene, it can be parented to the root.
   3. Label it with an ID
       - (I tend to follow a formula, L#O# where L# stands for the level number and O# stands for objective number)
   4. Identify the priority, can be primary, secondary or hidden (if you want it to not be visible until it's completed.)
   5. Identify the type of objective, this will effect how one is meant to approach the objective.
   6. Fill in any requirments as well as make a breif description in the descriptor.


 Adding objective beacons to a level
 These are vital for actually having completable objectives. 
 They mark points or entities in the level that require intervention of somekind in order to complete the mission.
 This means placement of the beacon matters, 
 if you want an enemy killed or an item picked up, it must be a child of that entity
 In terms of adding them this is how it goes:
 1: Goto res://Levels/Objectives and find the objective_beacon.tscn scene
 2: Drag it into the level
 - Again, make sure it's parent is what it needs to be associated with
 - Is it just a marker to goto or stay in? It can have root as parent
 - Is it meant to mark an enemy to kill? Make sure the enemy is the parent.
 3: Label it as you wish, but make sure the 'Objective ID' is the same as the associated level objective
 - If it's meant to be a beacon for L1O1, make the id L1O1
 4: Adjust the rest of the settings accordingly, Beacon type and priority being the most important things to consider.

 Class information:
 =========================
 
 Objectives:
 
 ~~~~~~~~~~~~~~~
 Variables:
 +Objectives 	type:Array (PackedScenes)
 	Where the objectives are stored

 +CompletingBeatsLevel	type:Bool
 	If this is true, completing all objectives (No failure) will send you to the main menu.
 ----------------
 Functions:
 
 _get_objective(name:String) : Takes the Objective's ID as a string
  Returns the objective as a packed scene object.

 display(ply) : Takes in the player, assumed to be a PackedScene, or Global's player
 It will collect each objective found in the level, sort them by priority, and give the text needed to be displayed, that being the descriptors
 If completed or failed, it will add a strikethrough to the text. This uses BBCode so one can sneak BBcode into an objective's descriptor
 It also needs to know the player so that it knows what screen it's printing to. It calls _update_objectives for each objective, noting the description, status and priority.

 _redisplay_objectives() : Clears the player's screen for a frame as it calls display on the player to make sure it's all displayed up to date.
 This and display do not automatically call when you add objectives, but if you do add objectives mid game, call this, not display, so that you clear the player's screen before displaying it again.

 _remove_task(task:Node, destroy:bool) : Takes the objective in question as a node, and the bool signifies if we free it from the queue or not.
 Simply removes the objective from the objective queue (and from memory if destroy is true) While showing missions that require it completed/failed to display. If all objectives are completed and the objectives class is set to beat the level on complete, it will return to the main menu.
 
 _createClock(beacon) : Takes the beacon, treated as a packed scene.
 Creates a new instance of a clock to be displayed on the HUD, starting the timer right then and there. Adjusts y coordinate based on the quantity of clocks on the screen.
 
 _forceStopClock(id) : Takes the objective's ID
Stops a clock forcefully, making it end prematurely and remove itself from the queue and hud.

 _removeClock(id) : Takes the Objective's ID
 Removes the clock from the hud, taking into account if it was removed prematurely or not. It will also notify the objective if a beacon was completed or if the objective is to fail.

 _show_hidden_on_requirement(name:String) : Takes the objective's ID
 Changes the priority for all objectives currently hidden to their real priority given their 'on hidden requirement' matches the name provided.

 ****************
 
 Level Objectives:
 
 ~~~~~~~~~~~~~~~
 Variables:
 + Id - String
 	Personal identifier for the objective. Allows the objective's class to determine what beacons match up with which objective.
 	Make sure these are unique between each other.
 
 + Descriptor - String
 	A brief description that will be displayed on the player's hud as a tip of what they should be doing (or have done)


 + Priority - OBJECTIVE_PRIORITY
 	Determines the priority of the objective, primary, secondary or hidden.

 + Disabled - Bool
 	If this is set to true, this will be removed on creation. This was used for debugging purposes, so if you want to remove and objective and you're sure of it, just remove it.
 
 + Objective Requirement - String
 	The ID of the objective that is needed to be completed in order for this objective to show up.
 
 + Completing Beats Level - Bool 
 	Determines if completing the objective in question will end the level.

 + Remove On Complete - Bool
 	Tells the objective manager to remove this objective from memory once it's marked as completed/failed.

 + Obj Type - OBJECTIVE_TYPE
 	Determines the type of objective this sould be, ranging from destroying, securing, or collecting. This doesn't see much use typically, but could be used in custom objectives.

 ----------------
 Functions:

 _OnCompleted()
 	Called when the objective determines itself a success by a variety of means. It informs the objective manager of it's success and marks itself as such.

 _OnFail()
 	Called when the objective determines itself a failure by many means. Sets itself as such and informs the objective manager as well.

 _MarkBeaconComplete(name:String) - Takes the beacon name as a string.
 	Called when the objective finds a beacon associated with itself that had just marked itself as completed. It will then stop any clock associated with it, and remove the beacon from it's beacon tracker, also checking the size of the beacon tracker to see if the objective itself it to be completed.

 _CheckCompletionStatus()
 	A function called every tick to checks to see if there is at least one beacon in the scene that is incomplete. If There is none and nothing informed it of ever being a successful removal, the objective will fail.

 _get_objective_string()
 	Gets the descriptor of the objective, while adding strikethroughs surrounding it if the objective is out of the ongoing phase.

 ****************
 
 Objective Beacon:
 
 ~~~~~~~~~~~~~~~
 Variables:
 + Objective Id - String
 	The string value of the associated Objective's ID. Must match.
 
 + Is Timed - Bool
 	Determines if the beacon is on a time limit of some kind.
 
 + Timer Length - Float
 	Matters only if itTimed is true. This simply is the length of the timer in seconds.

 + Timer Start On Spawn - Bool
 	Only matters if it's timed. Rather than having to collide with a radius, the timer will start when the player spawns into the scene.

 + Collide With Player - Bool
 	Determines if the beacon's collision circle is meant only for the player. If this is false, anyone can collide with the beacon's sphere and possibly start a timer/complete an objective.

 + Objective Radius - Float
 	The radius of the objective's collision sphere. The bigger the radius the larger the collision range.

 + Beacon Type - BEACON_TYPE
 	The sort of goal of the beacon, whether it's to simply collide with it (approach), destroy it, or keep it safe.

 + Beacon Priority - BEACON_PRIORITY
 	Determines how the beacon is displayed in the world scene. Primary makes it yellow while secondary makes it silver. Anything else makes it hidden.

 ----------------
 Functions:
 
 _OnTimerExpire()
 	Determines based on the beacon type if the beacon is considered a failure or a success, destroying the beacon either way, but calling _OnBeaconDestroy either way.

 _OnBeaconDestroy(fail:bool) - fail determining if the beacon was a failure or not.
 	Called everytime we remove the beacon without it being removed by the parent entity. Let's the objective manager know if it was a failure or not and marks itself as such before the manager marks it as such.

 _MarkFailed()
 	Displays the associated failure icon based on priority.

 _MarkCompleted()
 	Displays the associated success icon based on priority.

 _MarkPriority(priority:int) : Priority is the integer value of the new priority. Refer to BEACON_PRIORITY for the integer values.
 	Simply changes the priority of the beacon to what's provided, and visually changes such in game.
 
 ****************
 
 Clock:
 
 ~~~~~~~~~~~~~~~
 Variables:
 ----------------
 Functions:
 ****************
 
 _Initialize(time, id, beacon) : Time as float, id as string, beacon as beacon's name as a string.
 	Sets the basic values of the timer including the time in minutes and seconds, it's associated objective and beacon, while declaring itself as ongoing and displaying for the first time.

 _updateDisplay() 
 	Simply gets the current time in minutes and seconds, converts and single digits into double digits with a leading zero, and updates the timer's text.

 _EndClockPremature()
 	Declares itself as not ongoing and claims it was ended prematurley so that it may proceed to remove itself on the next second.

 There are also two custom sets of level_objective and objective_beacon classes ready for use
 Both inherit level_objective and objective_beacon and have a set of classes that are called in each to allow for customization of each objective.

 It's recommended you create new objective classed from base_custom_objective and/or base_custom_beacon if you decide you need more than the basic fundamentals in your objective.

 ****************
 
 base_custom_objective:
 Inherits level_objective
 ~~~~~~~~~~~~~~~
 Variables:
 ----------------
 Functions:

 _OnReady()
 	Called just before the _ready() code is called for the level_objective.

 _OnPreCompletionProcess() 
 	Called just before the completion status of the objective is called in _process(), meant for checks before a completion check.

 _OnPostCompletionProcess()
 	Called just after a completion status check in the objective at _process, may or may not actually get to process this once it's labled complete.

 _PreFail()
 	Called just before an objective is marked a failure.

 _PreCompletion()
 	Called just before an objective is marked as a success.

 ****************
 
 base_custom_beacon:
 Inherits objective_beacon
 ~~~~~~~~~~~~~~~
 Variables:
 ----------------
 Functions:
 
 _OnReady() 
 	Called just before the beacon's initialization code.	

 _PreProcess()
 	Called just before the beacon's processing code.

 _PostProcess() 
 	Called just at the end of the beacon's processing code.

 _RadiusEnteredPre()
 	Called just as an entity enters the beacon's radius

 _RadiusEnteredPost()
 	Called just after an entity enters a beacon's radius with no effect. Meaning it was likley not the entity saught after.

 _PreDestroy()
 	Called just after the beacon is set to be destroyed.

 _PostDestroy()
 	Called just after the beacon's destroy code.

 _PreTimerExpire()
 	Called just as a timer is expired.

 _PostTimerExpire()
 	Called after the timer is expired and just before the beacon is removed due to it expiring.
 
 ****************
 
 