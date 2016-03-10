## Synopsis

Codeminer42 challenge.

##### Backend:

The parser is made as follows, in line 16 I check when starting a new game, then create or empty variables.
In line 25 is where it appears the names of the players, so I created a regex to slice and add the names on the list.
In line 31 filter who killed who and if the player was killed by another player or otherwise.
In line 47 just caught in the death means and add to the list. Finally is added to the list of games all the collected data, starts the loop again to end log.

## Installation

##### Backend:

Just having the ruby and run bundler if you haven't installed the minitest gem.

<tt>bundle install</tt>

<tt>ruby main.rb</tt>

## Tests

##### Backend:

<tt>ruby tests/gameslog_test.rb</tt>
