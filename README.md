# Herobot: #heroku IRC Bot

Herobot is the IRC bot in the #heroku channel on Freenode. It is written
in Coffeescript and uses the Jerk library to respond to commands:

    !google term
      Returns a Google search URL
    !article slug
      Returns the Heroku article on Devcenter with the given slug
    !search term
      Returns the URL to the Devcenter search page for term
    !tag term
      Returns the URL to the list of articles with given tag
    heroku, heroku: ...
      Messages the user with basic information about Heroku support

Each of these commands can be 'sent' to a given user by prefixing it
with their name, e.g.:

    <  apple> banana: !google heroku
    <herobot> banana: http://www.google.com/search?q=heroku

If this prefix is omitted, the user requesting the command will be used
instead.
