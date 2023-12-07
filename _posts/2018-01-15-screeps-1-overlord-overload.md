---
layout: post
title: "Screeps #1: Overlord overload"
date: 2018-01-15
tags: screeps
thumbnail: /assets/img/aidiagram.png
typora-root-url: ../
redirect_from: /blog/2018/01/15/screeps-1-overlord-overload/
---

In [my last post](https://bencbartlett.wordpress.com/2017/12/19/screeps-0-a-brief-history-of-game-time/) I mentioned I'd be rewriting my Screeps AI. And what a rewrite this has been. After 8547 additions and 9953 deletions over the last few commits, I've completely overhauled a huge amount of how my AI works. At first, there wasn't any way to do this incrementally, the only strategy being "turn it off and see what breaks" and at times I felt like I was wading through the compiler errors like a fat mining creep wading through a swamp: ![Screen Shot 2017-12-26 at 5.55.40 PM](/assets/img/screen-shot-2017-12-26-at-5-55-40-pm.png){:class="img-fluid rounded z-depth-0"}

# My shiny new AI

I've made a lot of changes to the organization of the Overmind framework and I'm super happy with how they've turned out. I think it's getting very close to a 1.0 version which can be run as an opponent on private servers, and I almost decided to make this the 0.9 release, but I want to finish a few half-baked automation features first. I'll discuss each of the major changes in more detail below, but first, here's a fancy new diagram!

![AIdiagram.png](/assets/img/aidiagram.png){:class="img-fluid rounded z-depth-0"}

If you've seen the [previous version of this diagram](https://github.com/bencbartlett/Overmind/blob/d6c399273d96b084718b065a027cf4a69e85a477/assets/AIdiagram.png), the first change you've probably noticed is that there are no more roles! Each `Role` used to govern the creep control logic for a certain type of creep. All creep control logic, including what used to be on `HiveCluster`s, and spawn request logic has been combined in the new `Overlord` class.

Nerdy tangent: conceptually, the new `Overlord` class is actually the Overseer class I mentioned at the end of my last post, but I decided the name "Overlord" fit better thematically, since Overlords are responsible for relaying orders to the Zerg in Starcraft, which is what the class does. The remaining functionality of what used to be the colony Overlord is now the colony `Overseer`, which also thematically fits, since part of its function is to look for certain conditions in rooms and respond to them.

# The Overmind hierarchy

Now let's get in to how it all works. I'll explain the main components of the AI in decreasing order of hierarchy, but first, a brief glossary:

- **[Overmind](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Overmind.ts)**: the top-level object that contains and runs colonies and wraps all game objects
- **[Colony](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Colony.ts)**: groups together rooms and their objects into a single unit and instantiates HiveClusters
- **[HiveCluster](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/hiveClusters/HiveCluster.ts)**: groups together structures with related functionality and their logic
- **[Directive](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/directives/Directive.ts)**: a wrapper for a flag with contextual behavior changes
- **[Overlord](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/Overlord.ts)**: handles creep spawning and control for a specific goal; can be plopped on any of the above three objects
- **[Overseer](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Overseer.ts)**: tracks directives and overlords as they are instantiated and runs them by priority; places new directives to respond to stimuli
- **[Task](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/tasks/Task.ts)**: a customizable object which you can hand to a creep with `creep.task = Tasks.*`; generalizes the notion of "do action X to thing Y until condition Z is met"
- **[Zerg](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Zerg.ts)**: task- and overlord-contextualized wrapper for a creep

## Level 0: Overmind and the tick cycle

I've simplified the structure of my [main loop](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/main.ts) considerably in this rewrite. Excluding memory checking and sandbox code, there are now three major phases in each tick, each of which is executed by a call to the [Overmind](https://github.com/bencbartlett/Overmind/blob/12ed8718608c51eccd998a22acad0ba486cdc385/src/Overmind.ts):

1. `build()` All caching and object instantiation is done in this phase. [Colonies and their overlords are instantiated](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Overmind.ts#L31), then [colonies instantiate their hive clusters](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Colony.ts#L149) and their overlords. Finally, [directives and their overlords are instantiated](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Overmind.ts#L92). (More on overlords below.)
2. `init()` This phase handles all pre-state-changing actions, primarily various requests like [creep spawning requests](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/Overlord.ts#L106) and [transport and link requests](https://github.com/bencbartlett/Overmind/tree/dfcc17146de408112c1186b1a552d2be6572751c/src/resourceRequests).
3. `run()` This is where the action happens. All state-changing actions happen here; most will require information that is populated in the `init()` phase. HiveClusters will look through their various requests to determine what actions should be taken ([spawning the highest priority creep(s)](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/hiveClusters/hiveCluster_hatchery.ts#L169) from the requests, [loading/unloading the storage link](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/overlord_commandCenter.ts#L78), etc.). Overlords will scan through their Zerg and assign new tasks through a decision tree to each one that `[isIdle](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Zerg.ts#L260)`, such as [maintaining a miningSite](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/overlord_mine.ts#L41), [determining which structures to supply](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/overlord_supply.ts#L38), or [hauling back energy from a remote source](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/overlord_haul.ts#L52). The Overseer examines each room to look for any anomalous conditions, such as an [invasion](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Overseer.ts#L29) or a [colony crash](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/Overseer.ts#L39), and responds by placing Directives accordingly.

## Level 1: Colonies, Hive Clusters, and Directives

Not much has changed here; as before, the main idea behind colonies and hive clusters is to organize what belongs to what in a hierarchical manner based on what each object is instantiated by. Colonies are instantiated by an owned room and a list of outpost rooms (determined by directives) and organize these rooms into a single unit. HiveClusters are instantiated by a RoomObject belonging to a colony and group multiple structures and components together which share related functionality. Both Colonies and HiveClusters can have overlords put on them.

Directives are on the same hierarchical level as HiveClusters, but they are a little different, since the colony does not directly instantiate them. They are instantiated from flags by the Overmind and assigned to a colony based on their location. Directives don't have much internal logic (some will remove themselves, but that's about as complex as it gets right now) but their main function is to be a conditional attachment point for overlords. Directives are categorized by color codes, with the primary color indicating a category and a secondary color indicating the specific type. I've currently only written a few of the most essential directives, but the categories I have in mind are:

- Purple: colony directives - territory (claiming/reserving rooms and grouping rooms in colonies) and colony operations (incubating lil' babby colony)
- Red: military directives - defend against NPC invaders, attack a room, etc.
- Orange: operational directives - deal with non-standard colony conditions, like recovering from a crash with a bootstrapping directive
- Yellow: energy and resource directives
- White: RoomPlanner directives (more about this in the next post!), which allow for guided planning of colonized rooms, such as positioning hive clusters and placing road routing waypoints.

## Level 2: Overlords and Overseers

Overlords are really the heart of this update, if you couldn't tell by the title of this post. An Overlord is a generalization of a set of related things that need to be done in a colony like mining from a site, bootstrapping a new colony, guarding against invaders, or building construction sites. Overlords handle spawning or obtaining suitable creeps to do these things and contain the actual implementation of doing them, replacing the messy `Objective` system in the older AI. If HiveClusters are the organs of a colony, Overlords are the biological processes which make those organs function.

One of the biggest (and hardest) design decisions I had to make with this rewrite was how to handle instantiation of Overlords. Initially, I was drawn toward using directives as the only instantiation method, such that every process in a colony would have its own flag. However, I decided against this idea for two reasons: (1) it seemed to be unnecessary and unintuitive to use directives for normal operation (HiveClusters would need to be changed to be instantiated from flags, which is against their design, or would have a split cluster-directive nature which I didn't like) and (2) there is speculation that the flag cap may eventually be lowered from 10,000 to 100, so I don't want to rely on flags too heavily.

Eventually, I decided that an overlord can be instantiated from anything that has the following properties:

- `name`: for generating unique Overlord references
- `room`: an Overlord handles operations which primarily take place in one room
- `pos`: Overlords must be instantiated from a physical object
- `colony`: for assigning which colony handles the spawn requests (I added a self-referencing `Colony.colony` property so that Colonies could instantiate Overlords as well)
- `memory`: Overlord memory is stored in `instantiator.memory.overlords[this.ref]`

This allows Overlords to be instantiated from a Colony, HiveCluster, or Directive, which makes them a very versatile control model. Colony overlords are for constant, colony-wide operations, like handling workers to build new things. HiveCluster overlords are more specialized but still always present, like spawning miners for a site or a dedicated Hatchery attendant. Directive overlords tend to be conditional, like guarding against NPC invaders or claiming a new room.

When an Overlord is instantiated with a specified priority, it automatically adds itself to a priority queue on the colony `Overseer`. The Overseer is responsible for running all Directives and Overlords, as well as placing new Directives to respond to various stimuli.

# What else is new?

The changes I've discussed above are the largest changes that affect the core architecture of the AI, but I've added a ton of other improvements over the last month(s).

## `Overlord` overload, `Interface` underload

If you've looked at my codebase before, you've probably noticed that almost every parent-level class was declared as `export class Foo implements IFoo`, where `IFoo` is an interface enumerating the public properties and methods of `Foo` declared in one of the [declaration files](https://github.com/bencbartlett/Overmind/tree/31b721ba01750e27ab74877908fcf96539c07721/src/declarations), a similar paradigm to header files in C. In many cases, this is unnecessary in TypeScript, since the compiler can directly infer the types of class instances from the class declaration itself.

However, there was a method to my madness: because of the very hierarchical structure of my AI, I needed a top-level globally accessible object so that game objects could access "virtual" game objects with prototype extensions, such as:

`flag.colony --> Overmind.Colonies[Overmind.colonyMap[flag.room.name]`

In order for the object to be globally declared, it must be declared in a declaration file. Since [declaration files can't contain top-level imports](https://stackoverflow.com/questions/39040108/import-class-in-definition-file-d-ts), the objects must be either typed as `any`, which I didn't like, or must have their properties enumerated by an interface.

However, this got pretty tiring to maintain after a while, since every time I added or changed a method or property of a class, I'd need to keep updating the corresponding interface. With this update, I moved farther away from prototypes, deleting or moving a huge amount of prototypes I had in previous versions. The reduced use of prototypes allowed me to limit the number of top-level references, changing the typing of `global.Overmind` to `any`. (Any time this is referenced, the corresponding request is wrapped as a definitely-typed output; for example, many things reference `Directive.colony`, which references `Overmind.colony`.) Since removing most of the use of interfaces in my code, I've found development speed has increased noticeably.

## A whole family of `Task`s!

I've cleaned up my Task code a little bit, but the biggest change is that tasks can now have parents! When a task is finished executing, it automatically sets `this.creep.task = this.parent` (which is `null` by default). This means you can call `task.fork()` to chain tasks together, which will come in handy for some of the logistics refactoring I'm planning in the future. For example, if you wanted to retrieve energy from two mining sites on a similar route and then drop off at storage, you could do:

```ts
let task = Tasks.withdraw(miningSite1.output); 
task.parent = Tasks.withdraw(miningSite2.output); 
task.parent.parent = Tasks.deposit(colony.storage); 
creep.task = task;
```

Also, because I'm a little bit OCD about code aesthetics, I've added a new `Tasks` module to wrap task instances, changing the default task assignment paradigm from `creep.task = new TaskFoo(target)` to `creep.task = Tasks.foo(target)`.

## A better "feed me" box

If you look at my code for [haulers](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/overlord_haul.ts) and [suppliers](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/overlords/overlord_supply.ts), you'll notice that there's very little logic for figuring out what structures to deposit to or withdraw from. Aside from bootstrapping after a crash, almost every resource-moving operation in the AI now uses `[TransportRequests](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/resourceRequests/TransportRequestGroup.ts)` to get what they need. This was in previous versions of the AI, but I've added a lot of improvements and, with the removal of the objective system, generally use it more consistently throughout the code.

# Coming soon™ to a repository near you

I think that Overmind is (finally) nearing a workable release that could be run as an opponent on a private server. It's not quite ready yet, so don't expect much if you download it and leave it to its own devices, but it's almost there. Here's a few of the finishing touches it needs:

- I've been able to hammer away bugs a lot faster with the new AI framework, but there are still a few bugs I'm trying to fix (including one very annoying bug where creeps will very occasionally get stuck in an infinite loop of entering and exiting a room on exit tiles).
- The defense code is still pretty simplistic, and I haven't yet implemented SK mining or (re-)implemented boosting and mineral processing, but I think the new framework will allow me to work pretty quickly toward these goals.
- I want to respawn to shard1 or shard2 and move the new code to the public server! I'm hoping I can do this in the next week or so to make the February leaderboards without having to start the month from a fresh spawn.
- For an AI to be run as a bot on a private server, it needs to be completely autonomous. I still have to implement reservation- and claiming-planning systems, but at a surface level [this seems to be a relatively straightforward optimization problem](https://xkcd.com/793/), so I'm hopeful this won't be too much of an undertaking.
- I've been working on some automated [room planning features](https://github.com/bencbartlett/Overmind/blob/dfcc17146de408112c1186b1a552d2be6572751c/src/roomPlanner/RoomPlanner.ts) which can be run in automatic or guided-manual modes. These features are basically finished as of the [latest commit](https://github.com/bencbartlett/Overmind/tree/dfcc17146de408112c1186b1a552d2be6572751c), but I've already been rambling for a long time and I think they're cool enough to deserve their own post, so I'll talk about them in the next one.