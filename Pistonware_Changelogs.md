[!] I did this so piston would let me out of colt gateway basements -scrxpted

[+] Added Teleport (3 methods, 3 modes, 6 sorting functions)
[+] Added PingBypass (extremely customizable)
[+] Added KeepInventory (attempts to save storage items when at risk of death, this will not save your swords/daggers/hammers/scythes)
[+] Added AntiLagback (tries to keep you from lagbacking)
[+] Added FpsBoostPlus (does a bunch of stuff to try to clean your game (BETA is painful to use))
[+] Added NoCheatPlus (detect infinitefly, antivoid, projectile exploit, scaffold, hammer aura, 3 simulation checks (BETA))
[+] Added FunnyKB (use the kb from the golem boss to boost around)
[+] Added ReducePackets (increase time between checks for killaura, autobuy, autobank, cheststealer, and both disablers. this is for if you have a skill issue with poor internet (starlink :troll:))
[+] Added ScaffoldPlus (removes the game animation (character and viewmodel) for placing blocks)
[+] Added Invis (3 modes)
[+] Added NewDisabler (customizable better disabler. use with PingBypass for faster speed)
[+] Added StaffNotifier (attempts to detect staff main/alt accounts)

[*] Added more animations to killaura (27 more, some of these are really old and terrible but I cba to remove them)
[*] Fix custom animations not playing while attacking with a scythe
[*] Added a Winning/Losing informative text to the vape targethud
[*] Fixed VClip clipping into blocks
[*] Rewrote ChatMover to allow moving the chat anywhere (vape ui must be open)
[*] Optimized NameHider
[*] Cleaned FunnyHighJump
[*] Cleaned and renamed DragonBreath to DragonBlowie
[*] Fixed Headless erroring with NULL parent
[*] Cleaned PartyPopperSpammer idk why you would use this
[*] Optimized PisscanCrosshair
[*] Rewrote FloatDisabler (uses flora, piston had this so idk if it works)
[*] Optimized InfiniteJump
[*] Optimized NoKillFeed
[*] Cleaned Night
[*] Added a small fix to allow vape private users to be notified of vape users even on a late injection
[*] Added Auto Config to NewDisabler to automatically configure 

== Backend Development ==
[*] Imported git library
[*] Imported rblx-t.lua
[*] Imported rblx-tutils.lua
[*] Imported ByteLib (unused and really bad)
[*] Added singleWarning (send ONLY one warning for the entire game)
[*] Created GuiHandler (for easily creating draggable objects which are saved)
[*] Imported MessageHandler (for showing the client messages. slightly bugged due to my decision to not hook vape's OnIncomingMessage)
[*] Made bedwarsStore.matchStateTick accessible
[*] Created a temporary fix for isnetworkowner using xylex's univeral lagback code