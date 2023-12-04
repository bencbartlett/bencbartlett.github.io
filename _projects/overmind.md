---
layout: page
title: Overmind
description: Cooperative swarm intelligence for a multiplayer programming game
img: assets/img/overmind_screenshot.png
importance: 1
category: fun
---


Screeps is a [multiplayer strategy game for programmers](https://screeps.com/) where players write a swarm intelligence to control the actions of thousands of units in a persistent simulated game world, gathering resources, expanding the colony, and competing with other players for resources and territory. Because Screeps is an MMO, it takes place on a single server that runs 24/7, populated by every other player and their army of creeps. When you log off, your population continues buzzing away with whatever task you set them to. Screeps pits your programming prowess head-to-head with other people to see who can think of the most efficient methods of completing tasks or imagine new ways to defeat enemies.

I was a very active Screeps player from 2017-2020 and wrote the most popular open-source bot for the game, [Overmind](https://github.com/bencbartlett/Overmind), about 40k lines of TypeScript. At one point about a quarter of the player base was using my code, and I started a [server-wide war](https://web.archive.org/web/20210730202852/https://screepsworld.com/2019/03/the-unseen-war-purifiers-ncps-and-open-source-development/) in the game when I added the ability for all players running my codebase to automatically cooperate, a capability that many players saw as an existential threat.
<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
{% include repository/repo.html repository="bencbartlett/overmind" %}
</div>


Screeps is a really fascinating game with a tremendous amount of technical depth to it, prompting you to explore sub-problems from fast pathfinding algorithms and matrix convolutions to logisitical routing algorithms. I wrote a series of very technical [blog posts](/blog/tag/screeps) dicussing a lot of the design decisions behind Overmind. You can read them here:

<div class="table-responsive">
  <table class="table table-sm table-borderless">
    {% assign screeps_posts = site.posts | where_exp: "post", "post.tags contains 'screeps'" %}
    {% for post in screeps_posts %}
    <tr>
      <th scope="row">{{ post.date | date: "%b %-d, %Y" }}</th>
      <td>
          <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </td>
    </tr>
    {% endfor %}
  </table>
</div>