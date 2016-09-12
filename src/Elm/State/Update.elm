module State.Update exposing (update)

import State.DeclareStuff exposing (updateDeclareStuff)
import State.PickStuff exposing (updatePickStuff)
import State.WriteStuff exposing (updateWriteStuff)
import Types exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangePage page ->
      { model | page = page } ! []

    NewMessage contents -> 
      model ! []

    UpdateDeclareStuff daMsg ->
      updateDeclareStuff daMsg model

    UpdatePickStuff psMsg ->
      updatePickStuff psMsg model
    
    UpdateWriteStuff wsMsg ->
      updateWriteStuff wsMsg model