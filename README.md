# Exceedra Tech Test README

## Summary - API Tech Test

You are the president of the local Tennis Club. Your responsibilities include managing its players and their rankings. You’ve been asked to prepare a backend API in your preferred programming language that consists of the following endpoints:
1. ### An endpoint for registering a new player into the club
  - The only required data for registration is the player’s first name and last name, nationality, and the date of birth
  - No two players of the same first name and last name can be added
  - Players must be at least 16 years old to be able to enter the club
  - Each newly registered player should start with the score of 1200 points for the purpose of the ranking

2. ### An endpoint listing all players in the club.  
  It should be possible to list only players of particular nationality and/or rank name (see the bottom of the document) or all players.  
  The list should contain the following information for every player:
  - The current position in the whole ranking
  - First and last name
  - Age
  - Nationality
  - Rank name
  - Points  

  The players should be ordered by points (descending).  The unranked players should also be ordered by points (descending) but should appear at the bottom of the list, below all other ranks.  

3. ### An endpoint for registering a match that has been played

- It should require providing the winner and the loser of the match.
- The loser gives the winner 10% of his points from before the match (rounded down).  

For example:
- if Luca (1000 points) wins a match against Brendan (900 points), Luca should end up with 1090 points after the game and Brendan with 810.
- If Daniel (700 points) wins a match against James (1200 points), Daniel should end up with 820 points after the game and James with 1080.

The business logic behind calculating new player scores after a match should be unit-tested.

The code should be as readable and as well-organized as possible. Add any other information and/or extra validation for the above endpoints as you deem necessary.

### Rank List

| Rank    |Points|
|---------|------|
|Unranked |(The player has played less than 3 games)|
|Bronze| 0 – 2999|
|Silver | 3000 – 4999 |
|Gold | 5000 – 9999|
|Supersonic Legend| 10000 – no limit|


## Planning

### User Stories

As a user,  
So I can register for the club,  
I would like to be able to send over my details and register  

As a user,  
So I register correctly,  
I would like an error to be raised if my details are inccorect or incomplete

As a user,  
To avoid confusion,  
I would like to not be registered if I have the exact same name as another player

As a user,  
To have a minimum club age,  
I would like under 16's to not be able to register and raise an error

As a user,
So I know I registered succesfully,
I would like to recieve back confirmation of successful sign up

As a user,  
So I start on an even playing field,  
I would like the rating to default to 1200 upon signing up

As a user,  
So I can get a good start in the club,  
I would like to be Unranked for the first 3 games

As club manager,  
So I can see all players,  
I would like to have all players returned in a simple request

As club manager,  
So I can find certain categories of player,  
I would like to be able to fliter by nationality

As club manager,  
So I can find certain categories of player,  
I would like to be able to fliter by rank

As a user,  
So I can keep track of my games,  
I would like to be able to record a match

As a user,  
So I have my games recorded properly,  
I would like an error to be raised if the details are incorrect or incomplete  

As a user,  
So I have accurate results on how good I am,  
I would like my rating and rank to update after a game

As a user,  
So my games are kept track of accurately,  
I would like matches against non-club members to raise errors and not count

As a user,  
So I know my game was accurately recorded,  
I would like to see confirmation of the match and mine and my opponets new rating and rank

### Process

My process was to firstly think up some basic user stories from the summary and the endpoints that would be best to use. I then worked on firstly the simple GET endpoint for all players, before moving onto the POST endpoint for adding players. During this, I considered and added tests the edge cases, including incorrect dates, missing details in the JSON and fully blank JSONs.

Once this was done, I moved back to the GET endpoint and added in the search functionality and tidied up the code for the POST endpoint in the process. During both of these, I used TDD to create the tests first, then pass after these were written and failing. As well as this, I pulled some of the logic from the controller into the model to make the controller slimmer.

I then added in the last endpoint, the match POST endpoint, and Test drove this, also adding to the Player class in the process to ensure the methods were in the correct place. After this, I went back and considered any other edge cases, such as case sensitivity and the id in the JSON sent in with the match not matching the player name given.

Finally, I ran the de-linter and refactored some of the longer methods and code where possible, and ensured all methods were easily readable.

## Setup

### Versions Used

This API uses ruby 3.0.0. It also uses rails ('~> 7.0.2', '>= 7.0.2.3'). All other gems can be found in the gemfile and include Rspec, Rubocop and a Database cleaner (for use after tests). To install these gems, use 'bundle install' upon opening.

### Databases

This API uses a SQLite database. To set up, simply run 'bin/rails db:migrate' to set up the migrations. The database has 2 tables. They are:
Players, with columns:
- id
- first_name
- last_name
- nationality
- dob
- created_at
- updated_at
- rating
- rank
- globalranking
- matchesplayed  

And Matches, with columns:
- id
- winner_id
- winner_name
- loser_id
- loser_name
- created_at
- updated_at

### Tests
This API uses Rspec tests. To run all tests, after installing the bundle as above, and then simply run 'rspec' in the terminal.

## How to Use

This API has 3 endpoints, one GET and two POST as follows:

### GET /players(params) 
Lists all users, or searched for users depending on the params added. You can search by either nationality or rank with any nationality or rank listed in the summary. Their global ranking will be with respect to ALL players in the club, not just the ones searched for. If an invalid search type is stated, all players will be returned. Examples are:
- GET /players?search_type=nationality&nationality=English : will find all English players
- GET /players?search_type=rank&rank=Gold : will find all Gold ranked players
- GET /players?search_type=points : will return all players, as points isn't a valid search type

### POST /players
Will register a new player with the club. This endpoint must be accompanied with a JSON with at minimum specific information or it will not register and return an error. The JSON must be in the following format:  
**{user_details {first_name, last_name, nationality, dob, rating}}**  

If any of the above details are missing, an error will be returned. If the DOB is in the wrong format, the player is too young or the name is already taken an error will also be returned as a 422 error. 

### POST /matches
Will register a new match. This endpoint must be accompanied with a JSON with at minimum specific information or it will not register and return an error. The JSON must be in the following format:  
**{match_details {winner_id, winner_name,loser_id,loser_name}}**  

If any of the above details are missing, an error will be returned. If either player is not registered, or the ids do not match for either player an error will also be returned as a 422 error. 

## Feature Test

To run a feature test on your terminal, after running bundle install on one terminal type 'bin/rails server' whilst in the API directory. This will then be hosted locally (eg. localhost:3000) and then type in the following to test the API:

Create a first player with a POST request to /players:
- curl "localhost:3000/players" -X POST -H "Content-Type: application/json" -d '{"player_details": {"first_name":"bill","last_name":"banson","dob":"23-09-1996","nationality":"English"}}'  
**This will return a JSON confirming created**

Create a second player with a POST request to /players:
- curl "localhost:3000/players" -X POST -H "Content-Type: application/json" -d '{"player_details": {"first_name":"John","last_name":"Jones","dob":"23-09-1996","nationality":"American"}}'  
**This will return a JSON confirming created**

Create a third player with a POST request to /players:
- curl "localhost:3000/players" -X POST -H "Content-Type: application/json" -d '{"player_details": {"first_name":"James","last_name":"Jones","dob":"23-09-1996","nationality":"American"}}'  
**This will return a JSON confirming created**

Simulate a match between players 2 and 3 twice with two POST requests to /matches:
- curl "localhost:3000/matches" -X POST -H "Content-Type: application/json" -d '{"match_details": {"winner_id":"2","winner_name":"John Jones","loser_id":"3","loser_name":"James Jones"}}'
- curl "localhost:3000/matches" -X POST -H "Content-Type: application/json" -d '{"match_details": {"winner_id":"2","winner_name":"John Jones","loser_id":"3","loser_name":"James Jones"}}'  
**This will return a JSON each time confirming the match was added and their updated points**

Send a GET request for only American users:
- curl "localhost:3000/players?search_type=nationality&nationality=american"  
**This will return the two American users in an array of two hashes**

And then finally send a GET request for all users and see the final results:
- curl "localhost:3000/players   
**This will return the all three users in an array of three hashes**