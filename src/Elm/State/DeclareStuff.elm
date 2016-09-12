module State.DeclareStuff exposing (updateDeclareStuff)

import List.Extra exposing (replaceIf)

import Types exposing (..)

updateDeclareStuff : DeclareStuffMsg -> Model -> (Model, Cmd Msg)
updateDeclareStuff msg model =
  case msg of
    UpdateArea declareArea ->
      ({ model | declareAreas = replaceIf (\d -> d.id == declareArea.id) declareArea model.declareAreas }, Cmd.none)

    SetDeclareAreaLocked locked ->
      { model | declareAreasLocked = locked } ! []
      