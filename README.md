This is an online article I made some time ago for another website, I have written up a new PROLOG script and have decided to show this article here to demonstrate both, My understanding of PROLOG and how to use PROLOG in general. 

The attached PROLOG file is Train focussed compared to the article below. The attached PROLOG Script has more features which have all been commented. The original purpose of this article was to demonstrate the use of  PROLOG for simple application.

# Basic-Public-Transport-Navigation-System-in-PROLOG

## A report highlighting how to develop a simple navigational system using the Logic Programming language PROLOG. 
### Introduction

If you’re like me, you always look for the fastest and most efficient route to get from A to B. With the World Wide Web, there are many mediums available to assist people with navigation. Google Maps is a very popular form of navigational application. With Google being, Google… Maps is a highly advanced application which uses a plethora of techniques in order to provide the most accurate travel information, this includes traffic data, weather data and more. Can you imagine the million or more lines of code?

What if I told you; anyone can build a basic navigational system using Artificial Intelligence? You would say I am mad but it is entirely possible. I will show you how you can make a basic navigational system using simple artificial intelligence. 

Before I continue, we are not building a Skynet capable system. Instead, we’re using PROLOG to assist us.  Mann-net is a much better name in my humble, unbiased opinion.

### What is PROLOG?

PROLOG is a very simple and rather powerful logical programming language designed and developed in the early 70’s. The language is very popular with Artificial Intelligence and Computational Logic. Despite the age of the language, PROLOG has many uses in current technology. The IBM Watson Super Computer has a large amount of PROLOG programming despite its main structure built in Java. The supercomputer is currently used to assist medical decisions however, Watson is most popular for its logic in answering questions. Watson was a very good player of Jeopardy – a Quiz based game show.

### How to build a Navigational System using PROLOG

PROLOG requires a compiler in order to build scripts. SWI PROLOG is an extremly popular version. Do not install SWI PROLOG off the official website if you’re using Antivirus. The Executable Download file is mistaken as a Trojan resulting in the antivirus removing many important files to prevent “Spread”. Download at your own risk but the SWI PROLOG app on Portable Apps is just as good and has not caused me any issues compared to the official installer. This may be due to Portable Apps giving you a installed application prior rather than an executable. 

### Making a Data Dictionary

In order to make a navigable map, we need to know the two things. The locations and how to get there. For this example. I am going to pick 3 buses and about 5 stops per bus. 
v
Below is an example of a Data Dictionary:

    Bus A: (Village Bus)
        stop(harefield, [busA]). 
        stop(south_harefield, [busA]). 
        stop(denham_station, [busA]). 
        stop(southlands_road, [busA]). 
        stop(uxbridge, [busA])

    Bus B. (Town Bus)
        stop(hillingdon_hospital, [busB]).
        stop(brunel_sport_center, [busB]).
        stop(brunel_university, [busB]).
        stop(the_greenway, [busB]).
        stop(uxbridge, [busA, busB, busC]).

    Bus C. (Long Distance Bus).
        stop(watford, [busC]).
        stop(harefield, [busA, busC]).
        stop(uxbridge, [busA, busB, busC]).  

 

Take note how the data has been written out. It may look unusual but it has a sentence structure.

     “stop(harefield, [busA, busC]).”

stop is the bus stop. 

harefield is the name of the bus stop

busA and busC pass through the bus stop on their way to uxbridge. 
    
This can apply to any data, for example:
        
        son(Ashley, Rodney).
        
Ashley is the son of Rodney

#### So what does this Data mean?

We have just built a map. A map of three bus routes all heading to Uxbridge from random villages and towns in the local area. This can be applied to anything, you can make a scale replica of the london underground using this method of data declaration.

So what can we do with this?

well, as part of our navigation system, we can declare many things. As part of this demonstration, my navigational system will cover the following functions:
1. Displaying adjacent bus stops
2. Displaying the route between bus stops

### Displaying Adjacent Bus Stops:

If you’re making a map, you need to know how to get from A to B. This is where we define bus stops and their adjacent partners. In PROLOG this is done using Arcs and Nodes. H2O or Water is a cool example of Arcs and Notes. Hydrogen and Oxygen are the Nodes. The connections are the arcs.

To  map out the stations,  you write a new data dictionary. We have defined the stops, now we define the adjacencies. This will look like this:

    Bus A: (Village Bus)
        arc(harefield, south_harefield). 
        arc(south_harefield, denham_station). 
        arc(denham_station, southlands_road). 
        arc(southlands_road, uxbridge). 

    Bus B. (Town Bus)
        arc(hillingdon_hospital, brunel_sport_center).
        arc(brunel_sport_center, brunel_university).
        arc(brunel_university, the_greenway).
        arc(the_greenway, uxbridge).

    Bus C. (Long Distance Bus)
        arc(watford, harefield).
        arc(harefield, uxbridge).

 

You may notice this data dictionary only shows bus stops adjacent to the next on the route. This is to save time and space. A simple rule can be written to make the data above work both ways. This is how you write it:

    adjacents(X,Y):- adjacent_stops(X,Y).
    adjacents(X,Y):- adjacent_stops(Y,X).

This rule may seem a little confusing but this is how it works. The rule can be read as:

    adjacents(harefield, uxbridge) returns true IF adjacent_stops(X,Y) equals true.
        OR 
    adjacents(harefield, uxbridge) returns true IF adjacent_stops(Y,X) equals true.

Basically the rule returns true both ways thus shortening the code. Now that we have our map drawn out for say, we can plan a route!

### Displaying a route between two stops

With our map, we can finally map out a route to travel. Within Prolog, there is a very cool function known as findall. The function can be used or a variety of purposes. In this case, we are finding all bus stops between Uxbridge and Harefield. 

Here is the rule we will use to determine the route between two places:

Call /  Return:

    route(Stop1, Stop2, Route):- 
        route1( Stop1, Stop2, [], RouteReturn),
        reverse([Station2|RouteReturn],Route).

Base Case:

    route1(Stop1, Stop2, TempRoute, Route):-
        adjacent(Stop1, Stop2),
        \+member(Stop1, TempRoute),
        Route = [Stop1|TempRoute].

Recursive Case:

    route1(Stop1, Stop2, TempRoute, Route):- 
        adjacent(Stop1,Next),
        Next \== Stop2,
        \+member(Stop1, TempRoute),
        route1(Next, Stop2, [Stop1|TempRoute], Route).

This is a very long and very complex piece of PROLOG so I will try to explain it bit by bit.

The Call – the first piece of code is the main rule called when we make the route query. We are declaring that our rout will have three sections, A start, an end and the content in-between. 

route(Stop1, Stop2, Route):- 

    route1( Stop1, Stop2, [], RouteReturn),
    reverse([Station2|RouteReturn],Route).

The code above is a declaration, when route(Stop1, Stop2, Route) is called. route1 and reverse are declared.
route1 is the main route declaration. Stop1, Stop2, The route are all returned as RouteReturn later. 
Reverse is a function within PROLOG. In this instance, reverse returns the full route in the correct order. 

As clarification, the code above is looping. As a result, the first station is also the last station as more stations are included into the list. The result will be Stop2, [Inbetweenstations] and Stop1.

When route is called in the compiler, the base case begins searching for the route between two stations. This can be seen using a former rule we covered earlier:

route1(Stop1, Stop2, TempRoute, Route):-

    adjacent(Stop1, Stop2),
    \+member(Stop1, TempRoute),
    Route = [Stop1|TempRoute].

When route is called, route 1 is declared within the previous section we covered. This time, we have declared the empty string inside route1 to be TempRoute. To work out the route, the compiler first of all check if Stop 1 and Stop 2 are adjacent. \+ is a negation in PROLOG. This is similar to saying, the code will continue if Adjacent Stop 1 and Stop 2 cannot be proven else Route will be returned as the route between the two stations. 

PROLOG is a very simple to read, but hard to understand. “,” for example has many meaning. It can be seen as a step in a Sequence, an OR operator Or an AND operator. In this context, it is seen as an OR operator / Sequence. 

If adjacent Stop 1 and Stop 2 are not provable, the code will continue to a recursive rule. Recursion is the process of repeating a process. As you can see below, the code is very familiar to the piece above with a few differences. 

route1(Stop1, Stop2, TempRoute, Route):- 

    adjacent(Stop1,Next),
    Next \== Stop2,
    \+member(Stop1, TempRoute),
    route1(Next, Stop2, [Stop1|TempRoute], Route).

As a continuation, route 1 is repeated, but this time the compiler checks to see what station is adjacent to stop 1. This is the first step in finding the route between two stops. After discovering the next station, we confirm once again that the next stop is not stop 2. After checking this, the code once again states that stop 1 is not a member of temp route as we start placing stations into the temporary route. The final piece of code is rather unique:

    route1(Next, Stop2, [Stop1|TempRoute], Route).

Essentially, we are once again repeating route 1 but this time, the results a different. Now we are searching for the next set in the sequence after stop 1. “[Stop1|TempRoute]” means that next stop will go after Stop 1. The “|” symbol represents adding the next data to the beginning. This may seem very confusing according my my phrasal of this however. This is why we’re using the reverse function within the call. Once the full route has been produced. It is reversed to give the full result. After each loop, the data is input before the Stop 1. This means instead of displaying the route between Stop 1 and Stop 2. You are displaying the route between Stop 2 and Stop 1. 

