module Views.WriteStuff exposing (writeStuffView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Keyed as Keyed
import List.Extra exposing (find)
import String

import Types exposing (..)

writeStuffView : Model -> Html Msg
writeStuffView model =
  div []
    [ getUpperButtonToolbarView model
    , if not model.pickedItemsLocked then text "" else getEditNoteView model
    , hr [] []
    , getSearchToolbar model
    ]

getUpperButtonToolbarView : Model -> Html Msg
getUpperButtonToolbarView model =
  case model.editingNote of
    Just _ -> text ""

    Nothing -> getUpperButtonToolbar model 

getUpperButtonToolbar : Model -> Html Msg
getUpperButtonToolbar model =
  let
    locked = not model.pickedItemsLocked
    tooltip = if locked then "Picked stuff must be locked before creating notes" else ""
  in
    div [ class "row" ] 
      [ button 
        [ classList [("btn btn-success", True), ("disabled", locked)]
        , title tooltip
        , onClick <| UpdateWriteStuff EditNote
        , disabled locked
        ]
        [ text "Create a new note" ] 
      ]

getSearchToolbar model =
  div [ class "row" ]
    [ button [ type' "button", class "btn btn-default dropdown-toggle", attribute "data-toggle" "dropdown"]
      [ text "Select items" 
      , span [ class "caret" ] []
      ] 
    , button [ type' "button", 
               class "btn btn-primary left-buffer", 
               onClick <| UpdateWriteStuff <| SearchForNotes model.selectedNoteSearchItems ]
      [ span [ class "glyphicon glyphicon-search" ] []
      , text " Search for notes" 
      ] 
    ]

getEditNoteView : Model -> Html Msg
getEditNoteView model =
  case model.editingNote of
    Just note -> getEditNote model.pickedItems note

    Nothing -> text ""

getEditNote : List PickItem -> NoteEdit -> Html Msg
getEditNote items editingNote =
  let
    selectedItemId = case editingNote.item of
                       Just itemId -> itemId
                       Nothing -> 0
  in
    div [ class "row" ] 
      [ div [ class "panel panel-default" ] 
        [ div [ class "panel-heading" ] [ text "Create a new note" ]
        , div [ class "panel-body" ]
          [ div [ class "row" ] 
            [ div [ class "col-md-12" ] [ getItemsToSelect items selectedItemId <| getItemsToSelectText items editingNote.item ] ]
          , div [ class "row" ]
            [ div [ class "col-md-8" ] 
              [ textarea [ class "form-control top-buffer"
                         , attribute "rows" "6"
                         , onInput <| UpdateWriteStuff << UpdateTextInEditNote ] 
                [ text editingNote.text ] ]
            , div [ class "col-md-4" ] []
            ]
          , hr [] []
          , div [ class "row" ]
            [ div [ class "col-md-12" ]
              [ button [ class "btn btn-success"
                       , disabled <| (not << isPossibleToSaveNote) editingNote
                       , onClick <| UpdateWriteStuff (SaveEditedNote editingNote) ] 
                [ text "Save note" ]
              , button [ class "btn btn-default left-buffer"
                       , onClick <| UpdateWriteStuff CancelEditNote ] 
                [ text "Cancel" ]
              ]
            ]
          ]
        ]
      ]

isPossibleToSaveNote : NoteEdit -> Bool
isPossibleToSaveNote editingNote =
  editingNote.item /= Nothing && (not << String.isEmpty << String.trim) editingNote.text

getItemsToSelect : List PickItem -> Int -> String -> Html Msg
getItemsToSelect items selectedItemId buttonText =
  let
    availableItems = List.filter (\i -> (not << List.isEmpty) i.pickedDeclareAreas) items
  in
    div [ class "btn-group" ] 
      [ button [ type' "button", class "btn btn-default dropdown-toggle", attribute "data-toggle" "dropdown" ]
        [ text buttonText
        , span [ class "caret" ] [] 
        ]
      , Keyed.ul [ class "dropdown-menu" ]
          <| List.map (\item -> (toString item.id, getSelectableItem selectedItemId item)) availableItems
      ]

getSelectableItem : Int -> PickItem -> Html Msg
getSelectableItem selectedItemId item =
  li [ classList [ ("active", (item.id == selectedItemId)) ] ]
    [ a [ href "#", onClick <| UpdateWriteStuff (SelectItemInEditNote item.id) ] [ text item.title ] ]

getItemsToSelectText : List PickItem -> Maybe Int -> String
getItemsToSelectText items itemId =
  case itemId of
    Just id -> 
      case find (\i -> i.id == id) items of
        Just item -> item.title

        Nothing -> "Unknown item selected"
    
    Nothing -> "Select item"