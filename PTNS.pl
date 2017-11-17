% Defined Train Stations
	%Stations
		%Metropolitan
			station(al, [metropolitan]). 				%aldgate
			station(bs, [metropolitan]). 				%baker_street
			station(fr, [metropolitan]). 				%finchley_road
			station(ls, [metropolitan,central]). 		%liverpool_street
			station(kx, [metropolitan,victoria]).		%kings_cross
		%Central
			station(bg, [central]).	 					%bethnal_green
			station(cl, [central]). 					%chancery_lane
			station(lg, [central]). 					%lancaster_gate
			station(nh, [central]). 					%notting_hill_gate
			station(tc, [central,northern]). 			%tottenham_court_road
		%Victoria
			station(br, [victoria]). 					%brixton
			station(fp, [victoria]). 					%finsbur_park
			station(vi, [victoria]). 					%victoria
		%Bakerloo
			station(ec, [bakerloo]). 					%elephant_and_castle
			station(em, [bakerloo, northern]). 			%embankment
			station(pa, [bakerloo]). 					%paddington
			station(wa, [bakerloo]). 					%warwick_avenue
			station(oc, [bakerloo,central,victoria]). 	%oxford_circus
		%Northern
			station(eu, [northern]). 					%euston
			station(ke, [northern]). 					%kennington
			station(ws, [northern,victoria]). 			%warren_street

%--------------------------------------------------------------------------------------------------------------------------------

% Check if two stations ar adjacent to each other
	%Two_way_rule
		adjacent(X,Y):- adjacent_stations(X,Y).
		adjacent(X,Y):- adjacent_stations(Y,X).

		/*To call this rule, you must call adjacent(Station, Station).
		  The rule above specifies that the values of X and Y apply in both ways.
		  For example : Adjacent(X, Y) and Adjacent(Y, X) produce the same result.
		*/

	%adjacent
		/*This data diction below declares all adjacent stations for all lines. The rule only needs to specify one way.*/
		%bakerloo_line
			adjacent_stations(wa,pa).  /*adjacent_stations(X, Y) can be interpreted as term(Atom, Atom).*/
			adjacent_stations(pa,oc).
			adjacent_stations(oc,em).
			adjacent_stations(em,ec).

		%central_line
			adjacent_stations(nh,lg).
			adjacent_stations(lg,oc).
			adjacent_stations(oc,tc).
			adjacent_stations(tc,cl).
			adjacent_stations(cl,ls).
			adjacent_stations(ls,bg).

		%metropolitan
			adjacent_stations(fr,bs).
			adjacent_stations(bs,kx).
			adjacent_stations(kx,ls).
			adjacent_stations(ls,al).

		%northern
			adjacent_stations(eu,ws).
			adjacent_stations(ws,tc).
			adjacent_stations(tc,em).
			adjacent_stations(em,ke).

		%victoria
			adjacent_stations(br,vi).
			adjacent_stations(vi,oc).
			adjacent_stations(oc,ws).
			adjacent_stations(ws,kx).
			adjacent_stations(kx,fp).

%--------------------------------------------------------------------------------------------------------------------------------

% Check if two stations are on the same line
	%Sameline
		sameline(Station1, Station2, Line):-
			station(Station1, Line1), 			/*Declares Station1 as the Atom of station. For Example: Station1 = station(al, ([metropilitan])). */
			station(Station2, Line2),			/*Declares Station2 as an atom of station.*/
			member(Line, Line1),      			/*Checks if Line is a member of Line1.*/
			member(Line, Line2).	  			/*Checks if Line is a member of Line2.*/

			/*Essentially, the SameLine rule is an if Statement which reads,
				sameline(Station1, Station2, Line) equals true if,
					station(Station1, Line1) equals true
					And station(Station2, Line2) equals true,
					And Line is a member of Line1,
					And Line is a member of line2.

				If all the above equal true, sameline(Station1, Station2, Line) will equal true.
			*/

%--------------------------------------------------------------------------------------------------------------------------------

% Find all stations on a line
		findAllStations(Line, ListOfStations):-
			findall(Station,(station(Station,NewLine), member(Line, NewLine)), ListOfStations).

		/*The rule above returns all stations associated with the inputed line.
			The input "findAllStations(metropilitan, X)."
			calls a findall function.

			The find all function displays all results of the Station within a backtrackable rule such as,
			(station(Station,NewLine).

			The find all function also checks all bindings of Line as a member of NewLine.
			This checks the line associated with the station thus ensuring the function displays all stations associated with a line.

			Finally, FindAll creates a list called ListOfStations based on all bindings of Station associated with line1 members of line.
			This will return all stations based on a line input by the user.
		*/

%--------------------------------------------------------------------------------------------------------------------------------

% Check how many trains pass through a station
		numberOfLines(Station, NumberOfLines) :-
			station(Station,Line),
			length(Line, NumberOfLines).

		/*The rule above will display the number of lines which pass through a station.
		  numberOfLines(Station, NumberOfLines) will return a value based on the variable Line.
		  the answer will be displayed as the length of Line within a new variable called NumberOfLines.
		*/

%--------------------------------------------------------------------------------------------------------------------------------

% Check if station is adjacent to an interchange
		adjacent2interchange(NonInterStation,InterchangeStation) :-
			station(NonInterStation, ListOfLines1), length(ListOfLines1, NumberOfLines1),
			NumberOfLines1 == 1,
			station(InterchangeStation, ListOfLines2), length(ListOfLines2, NumberOfLines2),
			NumberOfLines2 > 1,
			adjacent(NonInterStation, InterchangeStation).

		/*This rule diplays whether a Station is adjacent to an interchance but not an interchance itself.

		  The rule returns true If the following conditions are met.
				*   station(NonInterStation, ListOfLines1) equals true IF		This declares a new form of station such as station(Al, [Metropolitan])
				*   length(ListOflines1, NumberOfLines) equals X AND			This creates a new variable. ListOfLines1 is a member of NumberofLines. This variable will be called later.
				*   NumberOfLines1 is equals to 1.								This is a conditino. NonInterStation equals true of NumberOfLines is equal to 1.
				*
				*   station(InterchangeStation, ListOfLines2) equals true IF	This declares a new form of station such as station(Al, [Metropolitan])
				*   length(ListOflines1, NumberOfLines) equals X AND			This creates a new variable. ListOfLines2 is a member of NumberofLines. This variable will be called later.
				*   NumberOfLines2 is greater than 1							This is a conditino. InterchangeStation equals true of NumberOfLines is greater than 1.
				*	adjacent(NonInterStation, InterchangeStation).              This is the final condition, if all the conditions above have been met, this rule checks if NonInterStation is adjacent to an interchange.
				*
		*/

%--------------------------------------------------------------------------------------------------------------------------------

% Route between two stations
		route(Station1, Station2, Route):-							 	/*Main rule for declaring the route between two stations*/
				route1( Station1, Station2, [], RouteReturn),
				reverse([Station2|RouteReturn],Route).

		route1(Station1, Station2, TempRoute, Route):- 					/*Main rule for finding route between two stations*/
				adjacent(Station1, Station2),
				\+member(Station1, TempRoute),
				Route = [Station1|TempRoute].

		route1(Station1, Station2, TempRoute, Route):-					/*Recursive rule */
				adjacent(Station1,Next),
				Next \== Station2,
				\+member(Station1, TempRoute),
				route1(Next, Station2, [Station1|TempRoute], Route).

	/*
		This is a rather complex section of code which performs as follows.
		To explain the code, I will use the following example:
			route(eu, bg, X).  							This is the user called function within SWI.
			    1).		route1(eu, bg, [], X) 				Calling route called a sub rule called route1

 			    2).		adjacent(eu, bg) 					After calling route1, the rule checks if the two stations are adjacent.
			    3).		adjacent(eu, bg)					If the stations are not adjacent the code will redo to ensure this is correct.

 			    4).		route1(eu, bg, [], X)				Once the code has established Station 1 and Station2  are not adjacent, the recursive rule is called.
			    5). 	adjacent(eu, Next)					When repeating, adjacent checks for the station adjacent to Station1.
			    6).  	adjacent(eu, ws)					adjacent(eu, Next) establishes ws as the next station in line and rechecks to confirm WS is adjacent to EU. 
			    7).  	ws\==bg ? creep						After checking the next station, the code cofirms it is not Station 2 and thus must continue.
			    8).     member(eu, []) 						member(eu, [])  declares EU as a member of [] which is temporary route.

			    10).	route1(ws, bg, [eu], X).			Once the above actions have been completed. Station1 will become a part of TempRoute and the process will repeat with Next station becoming From.
	*/

%--------------------------------------------------------------------------------------------------------------------------------

% Basic Route Time Rule
		routeTime(Station1, Station2, Route, RouteTime):-  	/*routeTime is called a user called method.*/
			route(Station1, Station2, Route),				/*route(Station1, Station2, Route) inherits the route algorithm above.*/
			length(Route, Time),							/*Length(Route, Time) returns length of the route and the time.*/
			RouteTime is (Time -1) * 4.						/*Returns the time it takes to travel.*/

		/*
			This rule specified the time it takes to complete a route input by the user.
			The time is based on route input by the user.
			Length returns the length of the route and the time.
			RouteTime returns the overal time based on the equasion (TIME - 1) * 4.
			Essentially, time is -1 to take into account the first station which you're already at.
			*4 is based on the average time between stations.
		*/


%--------------------------------------------------------------------------------------------------------------------------------
