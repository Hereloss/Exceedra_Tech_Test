# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# AMEND RATING TO POINTS!

## Usage Endpoints

GET /players : list all users
GET /players?search_type=nationality&nationality = x : searches for users with x nationality
GET /players?search_type=points&points = x : searches for users with greater than x rating
GET /players?search_type=rank&rank = x : searches for users in the given rank

POST ENDPOINTS:

POST /players with JSON {user_details {first_name, last_name, nationality, dob, rating}} : creates new user with following details. Will send back error if fails or duplicates
eg. curl "localhost:3000/players" -X POST -H "Content-Type: application/json" -d '{"player_details": {"first_name":"bill","last_name":"batson","dob":"23-09-1996","nationality":"American"}}'
eg. curl "localhost:3000/players" -X POST -H "Content-Type: application/json" -d '{"player_details": {"first_name":"John","last_name":"Jones","dob":"23-09-1996","nationality":"American"}}'
eg. curl "localhost:3000/players" -X POST -H "Content-Type: application/json" -d '{"player_details": {"first_name":"James","last_name":"Jones","dob":"23-09-1996","nationality":"American"}}'

POST /matches with JSON {match_details {winner_id, winner_name,loser_id,loser_name}}: Creates a new match and fixes players scores accordingly
eg. curl "localhost:3000/matches" -X POST -H "Content-Type: application/json" -d '{"match_details": {"winner_id":"2","winner_name":"John Jones","loser_id":"3","loser_name":"James Jones"}}'

NOTE: Uppercase and lowercase defaults should be considered!
