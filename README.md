# Do things with stuff
This is a project for learning Elm 0.17 (and other languages on the server side later). I'll begin with implementing a web page with static data and then add the server when "the time has come".

The idea behind the project is to let concurrent users do changes synced by a web socket server.

## How to compile and run
If you for whatever reason want to test it out, run `build-elm.sh` first to compile, and then `run_server.sh` to start the server (requires Python 2). Open a browser and navigate to `http://localhost:8000`.