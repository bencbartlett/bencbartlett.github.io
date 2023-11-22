---
layout: post
title: "Screeps #2: Interior Design"
date: 2018-02-06
tags: screeps
thumbnail: /assets/video/overmind_base_planner.webp
typora-root-url: ../
---

Now that the dust has settled following the recent [massive rewrite of my AI](https://bencbartlett.wordpress.com/2018/01/15/screeps-1-overlord-overload/), I've been able to turn my attention to adding more features to Overmind. Here's a few of the things I've been working on...

# Room planning

Overmind finally hired an interior decorator! I've been developing a semi-automatic room planning system for the last month or so, beginning slightly before the rewrite. I'm a little OCD about room layouts and aesthetics, so I wanted to design a system that could be fully automated but also would allow for user input when choosing the layout. I'll discuss it in more detail below, but here's a video of it in action:

{% include video.html path="/assets/video/Overmind_base_planner_h265.mp4" class="img-fluid rounded z-depth-1" controls="false" autoplay="true" loop="true"%}

Each colony now includes a [RoomPlanner](https://github.com/bencbartlett/Overmind/blob/8a9ca323091f15c56bb55957828cfc88da8aa4e2/src/roomPlanner/RoomPlanner.ts), referenced as `colony.roomPlanner`, which is responsible for generating a room layout and placing construction sites as needed to build the layout as the colony level increases. When you set `colony.roomPlanner.active = true` (I'm working on adding a set of console commands to make this simpler), the RoomPlanner opens a new planning session for you. The planned layout is drawn using RoomVisuals each tick while the session is active.

You can place flags of certain color codes (white/\* is reserved for this) to place different types of HiveClusters around the room. For example, placing a white/green flag will place a hatchery, while a white/blue flag will place a command center. Activating a planning session will display a list of flag commands in the console. The cluster layouts are pre-designed using the text output from [Dissi's building planner](https://screeps.dissi.me/buildingplanner/) and the layouts for each RCL are stored in a large JSON object (example: [hatchery](https://github.com/bencbartlett/Overmind/blob/master/src/roomPlanner/layouts/hatchery.ts)) containing the layouts and a bit of extra metadata. Placing a flag translates the layout to the appropriate location (set by the object which instantiates the corresponding hive cluster) and you can change `flag.memory.rotation` to set the rotation of the cluster. Some clusters, like mining sites, don't require manual placement since their position can be inferred.

The planner then computes the routes to connect the clusters appropriately with roads using my [Pathing](https://github.com/bencbartlett/Overmind/blob/master/src/pathing/pathing.ts) module (which interfaces heavily with Traveler), placing routes from the commandCenter to the hatchery, upgradeSite, and each miningSite. When `Pathing.routeRoadPath()` is called, it computes the shortest passable path between two locations, treating positions where a future building is planned as obstacles, and ignoring terrain values, such that every position has a cost of 2 in the pathfinder CostMatrix.

One of the cooler features I've added to the RoomPlanner is the ability to place routing hints with a white/white flag. These hints change the cost of the square they are placed on from 2 to 1, such that roads will preferentially be routed through the flag position, but only if the possible path lengths are degenerate. If the path planned using hints is longer than the shortest possible path, the errant path is drawn in red and a warning is displayed. This allows me to generate paths that would consistently satisfy functionality (being as short as possible) and aesthetics (no excessive zig-zags, merging nicely, etc.).

When you're happy with the planned layout and the RoomPlanner is also satisfied with it (requiring that a hatchery, a commandCenter, and an upgradeSite have been placed and that all planned building placements are valid), you can call `colony.roomPlanner.finalize()` to end your planning session and write everything to memory. This generates room plans for each RCL and serializes them into memory. Once the plan has been finalized, every $latex N$ ticks, the planner will check if there are structures and roads which need to be built and will place construction sites accordingly.

Upon ending a session, the planner also removes all planning flags (white/\*) you have placed across the colony, after saving the locations and types of them in its memory. You can reopen your session at a later time and the planner will restore the flags from the previous session, allowing you to easily modify the room plan in the future.

# Brave new ~~world~~ shard

After fixing a few final bugs in my AI (including one [incredibly frustrating one](https://screeps.com/forum/topic/2084/creep-spawning-false-and-creep-tickstolive-undefined-on-private-server) due to a bug in the private servers where overlords would occasionally spawn one additional creep beyond what was needed, depending on the state of the Hatchery's production queue), I decided I'm finally ready to deploy the new version to the public servers and respawn to a faster-ticking shard.

Earlier today, my Screeps abandoned [their ancestral home](https://screeps.com/a/#!/map/shard0?pos=-15.61,-87.714) and respawned to [shard2, E5S47](https://screeps.com/a/#!/room/shard2/E5S47). Feel free to check in if you're interested in following my progress.

# Organs for sale?

I'm very close to a 1.0 release of Overmind, and an idea I've been tossing around recently is making a separate `overmind-components` repository on Github to host some of the more polished parts of my AI as drag-and-drop plugins. I've spent a disproportionately large amount of time writing a clean framework to work with for Screeps (at the expense of developing features), and I've had several people message me on Slack/Reddit to ask for help integrating parts of my code into their AI's, so I think the demand could definitely be there.

To clarify, I would only be exporting "framework" code, such as my `Task` system, which can simplify the syntax and complexity of writing decision trees for creeps, rather than "feature" code, which is stuff like combat, mining, and processing minerals that people should write for themselves.

If you have thoughts on this or would be interested in helping me beta test these plugins, leave a comment here, in the [Reddit post](https://www.reddit.com/r/screeps/comments/7vkr3n/screeps_2_interior_design/), in the [#overmind](https://screeps.slack.com/messages/overmind) Slack channel, or send me a DM [@muon](https://screeps.slack.com/messages/muon). (I also accept carrier pigeons and, if you live near Palo Alto, smoke signals.)