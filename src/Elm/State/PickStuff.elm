module State.PickStuff exposing (updatePickStuff)

import List.Extra exposing (replaceIf, find)

import Types exposing (..)

updatePickStuff : PickStuffMsg -> Model -> (Model, Cmd Msg)
updatePickStuff msg model =
  case msg of
    SetPickedItemState daId itemId selected ->
      let
        maybeItem = find (\i -> i.id == itemId) model.pickedItems
      in
        case maybeItem of
          Just item ->
            let
              daInList = List.member daId item.pickedDeclareAreas
              updatedPickedDeclareAreas = getUpdatedPickedDeclareAreasForItem daId daInList selected item
              updatedItem = { item | pickedDeclareAreas = updatedPickedDeclareAreas }
            in
              { model | pickedItems = replaceIf (\x -> x.id == itemId) updatedItem model.pickedItems } ! []

          Nothing -> model ! []

    SetPickedItemsLocked locked ->
      { model | pickedItemsLocked = locked} ! []

getUpdatedPickedDeclareAreasForItem : Int -> Bool -> Bool -> PickItem -> List Int
getUpdatedPickedDeclareAreasForItem daId daInList daSelected item =
  if not daInList && daSelected then daId :: item.pickedDeclareAreas
  else if daInList && not daSelected then List.filter (\d -> d /= daId) item.pickedDeclareAreas
  else item.pickedDeclareAreas