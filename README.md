# Project Summary
A game made in a months time with a group of people for the 2022 GameOff event. Due to size issues with having textures and mesh assets we will only be storing code and text data here until a solution can be implemented. 
 
# Godot 4.0 beta3
Link to the newest beta version of the game engine.

    https://downloads.tuxfamily.org/godotengine/4.0/beta3/

# Git Structure 

For each runnable version that gets exported a new branch with the version number as the name will be made, splitting off the main branch and no changes should be made to that branch.

        Runnable - ver#  ________
   
    main_______________/_______________


For each task a new branch should be made with the name and task name of that title. Once finished then merged to the main branch.
                        
      Movement - william _____________
   
    main_______________/_______________\_____________

# Version Number explained
We will be operating on the releases type version numbering 

* ### Major releases

   Also known as versions or upgrades. A major release represents a significant product change – a rollout of game-changing new features, an overhauled interface, a fresh new codebase. Typically, a major release will supersede previous versions of the software.
	
  On a major release the two other numbers zero out.
	
  Example:
		
    Befor 00.01.01  ->  Major release happens  ->  After 01.00.00
    
* ### Minor releases

  Also known as updates. A minor release edits the current version in a small way – usually to enhance existing functions. (Or, sometimes, to add lesser new features.) This will happen regularly and mostly in the background.
	    
   Increments the second column  00.01.00

* ### Patches

   Also known as bug fixes. A patch often isn’t part of a planned release, as it will generally come in response to an uncovered problem or a new security threat. They help keep your product running effectively, even if they don’t offer new functionality.
   
   Increments the first column  00.00.01
