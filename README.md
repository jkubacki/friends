[In development]

Ruby on Rails JSON API backend for Friends app

React frontend https://github.com/jkubacki/friends-front


Automatic scheduling for groups of friends busy with their lives.


It checks availability in google calendar and pings friends with a proposition (twilio sms or push notification).

We are going to use it for scheduling RPG sessions.

Tech:
* Ruby on Rails
* [JSON API](https://jsonapi.org/)
* OAuth2 & Google login
* grape / devise / doorkeeper / pundit
* RSpec
* Twilio (sms) # TBA
* Google calendar api # TBA
* Sidekiq # TBA
* AWS / Docker infrastructure # TBA

Setup:

`bundle install`

`rake db:setup`
