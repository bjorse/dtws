module App exposing (main) 

import Html.App as Html

import State.Init exposing (init, subscriptions)
import State.Update exposing (update)
import View exposing (view)

main =
  Html.program 
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions }