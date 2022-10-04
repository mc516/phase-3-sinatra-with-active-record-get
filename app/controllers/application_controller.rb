class ApplicationController < Sinatra::Base

  # Add this line to set the Content-Type header for all responses
  set :default_content_type, 'application/json'

  get '/' do
    { message: "Hello world" }.to_json
  end

  get '/games' do
    # get all the games from the database
    games = Game.all
    # return a JSON response with an array of all the game data
    games.to_json
  end

  # use the :id syntax to create a dynamic route
  get '/games/:id' do
    # look up the game in the database using its ID
    # send a JSON-formatted response of the game data
    game = Game.find(params[:id])

    # game.to_json

    # include associated reviews in the JSON response
    game.to_json(include: :reviews)

    #We can even take it a level further, and include the users associated with each review:
    game.to_json(include: { reviews: { include: :user } })

    #We can also be more selective about which attributes are returned from each model with the only option:
    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end
end
