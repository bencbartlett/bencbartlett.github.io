---
layout: post
title: "Screeps #3: State of the Automated Union"
date: 2018-03-12
tags: screeps
thumbnail: /assets/img/screen-shot-2018-03-11-at-5-51-30-pm.png
typora-root-url: ../

---

_This will be a relatively short post. I was originally planning on the main topic of this post to be my overhauled logistics system, but I have a **lot** to say about that. It's easily one of the coolest things I've implemented in Screeps, so I'm giving it its own dedicated post - expect to hear from me again later this week!_

My respawn to shard2 has been really good for my expansion ranking. The faster tick times combined with my much more efficient AI have pushed me up the leaderboard from #322 in January to #67 currently, and rising. Thanks to my new colonization directives, I was able to claim about 1-2 new rooms per day once my first room reached RCL4, and once it reached RCL7, it was able to switch to incubation directives to kickstart new colonies even faster.

Here's a timelapse of one of my rooms getting set up. (Currently, walls and ramparts are the only remaining structures not automatically placed.)

{% include video.html path="/assets/video/Overmind_RCL_1-4_Timelapse_h265.mp4" class="img-fluid rounded z-depth-1" controls="true" autoplay="true" loop="true"%}


Unfortunately, I did have to displace several existing players in the respawn zone I picked into. The first few players I eliminated presented very little resistance - one or two towers with unreliable refilling code. A single sieger/healer pair was sufficient to take them out over the course of a few hours. I felt a little bad taking them out, but that's just the nature of the game.

# Nip it in the bud

After I had taken over about half of my sector, I noticed that Tigga, a very experienced player, had respawned from shard0 to one of the central rooms in my sector. He used to live a few sectors away from me in shard0, and I've watched his combat code work; it is much more developed than mine currently is. This (along with the fact that he has an additional 7 GCL on me) made me confident that I would not win a war of attrition if I allowed his colony to reach the point where boosts were available, so I prioritized dusting off some deprecated combat and boosting code to take out his room.

This was hardly a fair fight, however: I did have the huge advantage of having spawned over a week before he did, so I had a much larger economy to leverage. Tigga's code expands fast, and he was remote mining and poaching energy from my neighboring rooms as early as RCL2. I quarantined his room, placing persistent guard and swarmGuard directives on all neighboring rooms to slow his expansion while his safemode was active. His combat creeps put up a good fight, frequently beating mine in equally-sized conflicts with what was clearly very polished kiting code.

However, his AI seemed to prioritize fighting over expanding, and he kept pumping out fighters at the cost of under-saturating his own room's sources. Since I had far more resources at my disposal, I kept sending my comparatively dumb creeps to die to keep him occupied, and, in the end, I ended up taking out his RCL4 room with a pair of boosted destroyers. It seems that room quarantining was a very effective strategy here, and I've started writing a Ravager overlord that will harass and deny expansions more efficiently. I was able to use the boosting and combat code I had developed to clear out the rest of the sector, and things were peaceful until my respawn zone walls came down.

# Losing my first room

Almost immediately, my neighbor to the east, BrianRotel, started attacking my nearest room. According to [LoAN](http://www.leagueofautomatednations.com/map/shard2/bots), he is running KasamiBot, which has some decent dismantling code, and he already had a large number of RCL8 rooms and a much larger economy than mine. I had to leave for the weekend about an hour after his attack started, but I was able to quickly cobble together some decent [archer defense code](https://github.com/bencbartlett/Overmind/blob/master/src/overlords/combat/overlord_archer.ts) that I was confident would hold him off and deployed it before I had to leave.

Unfortunately, a subtle bug in the colony Overseer prevented it from triggering. Since I was unable to fix the bug over the weekend, he was able to take out my room and has, so far, thwarted my efforts to rebuild it. However, my defensive code works quite well now, as he has unsuccessfully attacked another one of my rooms, and since he is running an open-source bot with no noticeable modifications, I'm not too worried about defending against novel new attack strategies. So, for the time being, I've ignored my lost room and focused most of my efforts into finishing my overhauled logistics system.

I've never actually lost a room prior to this event (other than during the first week of me playing Screeps), so this was a good learning experience. It's also made me reconsider my classic "box and flower" room layout. It has a number of (mainly logistical) advantages to it: it allows for flexibility on where to place the important room components in the Command Center (box) without worrying about the bulk of the Hatchery (flower), it integrates well with my simple but flexible link management code, and I just generally like the aesthetics of the layout. However, I'm not sure that it's an optimal layout from a defensive standpoint: having walls far away from towers minimizes turret damage, and its two-part nature prevents me from defending inside the walls, as manager creeps need to safely get from the hatchery to the command center to keep the energy flow going. I may be switching to using bunkers in the near future, but that is a post for another day.

# Work smart, not hard

Combat has never really been my first priority in playing Screeps, but my recent power struggles have distracted me from fixing logistic inefficiencies. One item that has been on the back burner for a while now has been better road maintenance. Prior to my recent rewrite and respawn, every hauler had a single work part and would maintain the roads they were on. However, this can actually get surprisingly expensive, and the pricey work parts are only actively in use for a small portion of the time, so I got rid of this behavior in the rewrite.

Since then, I've slapped a bandaid on the problem and just had my workers stop what they are doing to repair any critical roads and to look for any roads within range 3 to repair whenever they can, if it won't interrupt whatever else they did that tick. A cute little [`canExecute()`](https://github.com/bencbartlett/Overmind/blob/master/src/Zerg.ts#L203) property I added allows my creeps to determine if a given action will block other actions they have tried to execute this tick; this way, I can stop looking up [what's probably the most-referenced page on the Screeps documentation](http://docs.screeps.com/simultaneous-actions.html).

I've waffled back and forth on how to make a permanent solution to this. I considered making a dedicated paver overlord to handle this, but this seemed redundant, as the creep would likely have a similar body to a worker creep, so I opted against this. I also considered adding work parts only to some haulers, and having them prioritize routes with low road health, but this would complicate my super-beautiful upcoming logistics system. _(Can you tell I'm excited about this?)_

Eventually, I settled on writing a [`RoadLogistics`](https://github.com/bencbartlett/Overmind/blob/master/src/logistics/RoadLogistics.ts) class which allows workers to more efficiently handle road maintenance. Each colony is given a roadLogistics object, which tells workers when they should repair the roads in a room. Only one worker is assigned to a given room needing maintenance, and maintenance is only needed if (1) there is a road below critical health in the room, or (2) the total amount of energy needed to repair the room reaches the worker's carryCapacity. This has allowed workers to waste less time traveling around random places to inefficiently repair roads and has cut back on the CPU overhead of having to look for nearby roads to idly repair.

# Now these points of data make a beautiful line...

Overmind now has graphs! Beautiful, beautiful graphs! I've finally gotten around to setting up Grafana using [ScreepsPlus](https://screepspl.us/services/grafana), and it was surprisingly straightforward. (Shoutout to ags131 for keeping this great service running!) If you're one of the half-dozen people running Overmind on the public servers, I'd highly recommend setting this up; bonzaiferroni has [a great tutorial](https://github.com/bonzaiferroni/bonzAI/wiki/Screepspl.us-agent-with-Compute-Engine) on how to get started. If you do set it up, here's what you can expect it to look like out of the box:

![Screen Shot 2018-03-11 at 5.51.30 PM](/assets/img/screen-shot-2018-03-11-at-5-51-30-pm.png){:class="img-fluid rounded z-depth-0"}

# ...and we're out of beta, we're releasing on time!

I've been saying this for a year now, but Overmind is almost ready for a v1.0 release. In fact, I finally made the very first (pre-)release on Github as v0.1! I'll make a v0.2 release containing many of the changes mentioned in this post when I deploy the updated logistics system on the public servers later this week.

I want to take the remainder of this post to talk about my plans for the near future of the project. At this point, here are the remaining things I want to implement before a v1.0 release:

- I want Overmind to be able to run completely autonomously, such that it can be run as an opponent on private servers, so I need to implement automated room planning. My [room planning system](https://bencbartlett.wordpress.com/2018/02/06/screeps-2-interior-design/) is already semi-automated, so I'm not anticipating this to be a huge hurdle, as I just need to design a system to calculate the best places to place the flags.
- I also need to implement automated room/expansion claiming. This will likely be a bit more involved, and will require me to write more extensive scouting code, but I don't think it will be a super long process to implement.
- I now already have some decent automated defensive code, but I need to make automatic harassment and attacking code. I have some ideas brewing for this, but I'm not sure how long it will take.
- As I mentioned in my previous post, I want to take some parts of my code, including Tasks, Colonies, and my new logistics system and release them as drag-and-drop plugins in a separate repository.

I haven't accepted any major contributions to the codebase yet, and I don't plan to until a v1.0 release, but after that, I think I'll open up the project for anyone who wants to contribute to it. (You may have noticed that I've added pull request and issue templates to the repository.)

# An anti-bot bot

Finally, I wanted to talk about the long-term future of Overmind as an open-source codebase. There was a really good [discussion](https://screeps.com/forum/topic/2000/on-the-topic-of-open-source-code-bases) about the use of open-source codebases on the Screeps forum a few months ago, and I've taken some ideas from there about this topic.

When I first started playing Screeps over a year ago, screeps-OCS comprised what seemed like a large portion of the player base, easily stomping newbies who play the game as it is meant to be played by writing their own code. The fact that someone could just download a 10000-line bot and use it to steamroll my AI almost caused me to quit playing Screeps, and I see the prevalence of people running open-source codebases that they don't actively contribute to as one of the single biggest flaws in the game.

Even before an "official release", I've seen several people running Overmind on the public servers. Although this is flattering, I don't want my AI to become a downloadable newbie-stomping oppression machine as it finishes development, so a while ago, I decided that my long term goal for Overmind is for it to be the "anti-bot bot". Now that there is an [easily accessible way](http://www.leagueofautomatednations.com/vk/bots/members.json) to determine if people are running bots on public servers, I'll eventually be adding in behavioral changes to the AI which will cause it to preferentially target players using non-Overmind bots on the public servers and to limit aggression to non-threatening players in recent newbie zones. These parts of the codebase will be obfuscated and made intentionally difficult to disable. (This is also the main reason for the fourth clause in the somewhat silly and probably completely unenforcible license that I recently added to the repository.) I'm not yet sure how feasible this plan will be, but in an ideal world, this would allow me to keep most of my codebase open sourced while slightly controlling its behavior on public servers.

_Remember back when I said this would be a relatively short post? Me neither! Check back later this week for a post on solving the generalized problem of resource transport..._