---
layout: post
title: "Teaching ChatGPT to do quantum computing with cat emojis 😺"
date: 2022-12-06
tags: physics ml
thumbnail: /assets/img/screen-shot-2022-12-06-at-1.11.52-pm.png
typora-root-url: ../
---

You have probably seen some of the things that you can do with OpenAI's new [ChatGPT](https://chat.openai.com/chat#) which was released last week: this unnervingly human-like language model can [invent a fictional language](https://maximumeffort.substack.com/p/i-taught-chatgpt-to-invent-a-language), [emulate a virtual machine](https://www.engraved.blog/building-a-virtual-machine-inside/), and [debug code for you](https://twitter.com/amasad/status/1598042665375105024).

Yesterday I finally spent some time playing around with ChatGPT and I am really impressed by how powerful it is. I decided to try to teach ChatGPT to implement a new computational model from the ground up. The model, based on "mewbits" is equivalent to quantum computing and qubits, but the catch is that I didn't tell ChatGPT what I was having it do; I just told it the rules of the game for this abstract computational model. Over the course of this transcript, the following happens:

- ChatGPT is introduced to a new computational model. The basic unit of information of this model is a "mewbit", which can be in any normalized linear combination of two states: 😾 and 😺.

- ChatGPT is introduced to how measurement (state collapse) behave for mewbits. I then introduce some basic operations you can do on mewbits, including not (Pauli-X) and H (Hadamard). It understands what these operations do and successfully completes several exercises I give to it.

- ChatGPT writes a `mewbit` class in Python, which tracks the internal state of the mewbit and has methods for operations and measurements you can do on a mewbit. It adds comments explaining what is going on.

- I explain the basics of quantum entanglement to ChatGPT. It constructs a program to emulate a system of multiple mewbits and understands how to generalize single-mewbit operations to this multi-mewbit system.

- I introduce the concept of a two-mewbit CNOT gate and I explain in plain english how to simulate joint measurements. ChatGPT understands, completes exercises successfully, and updates its Python class to incorporate this complex gate.

- I ask ChatGPT to write a script which would generate 100 entangled [Bell pair](https://en.wikipedia.org/wiki/Bell_state#Creating_Bell_states)s and measure the system states, then plot the results.

- Finally, I asked ChatGPT if any of this sounded familiar, and it understood that the "mewbits" I described to it were actually qubits!

## Teaching ChatGPT about mewbits

![](/assets/img/image.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-1.png){:width="75%" class="img-fluid rounded z-depth-0"}



## How does measurement work on mewbits?

![](/assets/img/image-4.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-5.png){:width="75%" class="img-fluid rounded z-depth-0"}



## Teaching ChatGPT about quantum gates

![](/assets/img/image-6.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-7.png){:width="75%" class="img-fluid rounded z-depth-0"}

At this point, ChatGPT makes the inference that 😾 = 1\*😾+0\*😺:

![](/assets/img/image-8.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-9.png){:width="75%" class="img-fluid rounded z-depth-0"}

Now we introduce a more complicated concept: the [Hadamard gate](https://en.wikipedia.org/wiki/Quantum_logic_gate#Hadamard_gate):

![](/assets/img/image-10.png){:width="75%" class="img-fluid rounded z-depth-0"}



## ChatGPT formalizes what it has learned into Python code

At this point ChatGPT clearly understands the concepts and answers examples correctly, but I would like to see what it thinks is actually going on under the hood, so I ask it to formalize what it has learned into Python code:

![](/assets/img/image-12.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-11.png){:width="75%" class="img-fluid rounded z-depth-0"}

And because all good code should have comments:

![](/assets/img/image-15.png){:width="75%" class="img-fluid rounded z-depth-0"}

Since it seems ChatGPT forgot to add measurement as a thing you could do to a mewbit, I asked it to add that in as well:

![](/assets/img/image-16.png){:width="75%" class="img-fluid rounded z-depth-0"}



## Multi-mewbit systems

At this point I made the considerable jump in complexity to explaining how multi-mewbit systems behave, explaining a simplified version of the mechanics of quantum entanglement to ChatGPT. I also explained how you can perform operations on a single mewbit in the system, changing the state of that mewbit but leaving the rest unchanged. Notably, ChatGPT inferred that this updates the state of the multi-mewbit system:

![](/assets/img/image-17.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-19.png){:width="75%" class="img-fluid rounded z-depth-0"}



## Multi-mewbit gates

![](/assets/img/image-20.png){:width="75%" class="img-fluid rounded z-depth-0"}

This was a complex idea to explain to an AI, and I admit I had to make a few attempts at explaining it properly before ChatGPT was able to understand what I meant. However, as you'll see, ChatGPT makes an error and then corrects itself:

![](/assets/img/image-21.png){:width="75%" class="img-fluid rounded z-depth-0"}

I now ask it to incorporate its new knowledge into its existing understanding of mewbit systems:

![](/assets/img/image-22.png){:width="75%" class="img-fluid rounded z-depth-0"}



## Joint measurement of multiple mewbits

![](/assets/img/image-23.png){:width="75%" class="img-fluid rounded z-depth-0"}

![](/assets/img/image-24.png){:width="75%" class="img-fluid rounded z-depth-0"}



## Putting it all together: Bell state preparation

![](/assets/img/image-25.png){:width="75%" class="img-fluid rounded z-depth-0"}

I'd also like for ChatGPT to plot the results:

![](/assets/img/image-26.png){:width="75%" class="img-fluid rounded z-depth-0"}

Unfortunately, ChatGPT doesn't allow me to run the code and we have some banter about arbitrary code execution:

![](/assets/img/image-28.png){:width="75%" class="img-fluid rounded z-depth-0"}



## Does ChatGPT understand what I just taught it about?

At this point I have described in plain English the basic principles of qubits, quantum systems, gates, entanglement, and measurement. ChatGPT has constructed code which would accurately simulate this, but does it understand what I just instructed it to build?

![image-29](/assets/img/image-29.png){:width="75%" class="img-fluid rounded z-depth-0"}

