module Views.WriteStuff exposing (writeStuffView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onCheck)
import Html.Keyed as Keyed
import List.Extra exposing (find)
import String
import Date.Format exposing (format)

import Types exposing (..)

writeStuffView : Model -> Html Msg
writeStuffView model =
  div []
    [ getUpperButtonToolbarView model
    , if not model.pickedItemsLocked then text "" else getEditNoteView model
    , getSearchToolbar model
    , getSearchResult model.hasSearchedForNotes model.noteSearchResult model.pickedItems 
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

getSearchToolbar : Model -> Html Msg
getSearchToolbar model =
  div [ class "row top-buffer" ]
    [ div [ class "btn-group" ]
      [ button [ type' "button", class "btn btn-default dropdown-toggle", attribute "data-toggle" "dropdown"]
        [ text <| getItemsSelectText model.selectedNoteSearchItems model.pickedItems
        , span [ class "caret" ] []
        ] 
      , Keyed.ul [ class "dropdown-menu" ] <| getPickItemsEntries model.selectedNoteSearchItems model.pickedItems
      ]
    , button [ type' "button"
             , class "btn btn-default left-buffer"
             , onClick <| UpdateWriteStuff ClearSelectedItemsInNoteSearch ]
      [ text "Clear items" ]
    , button [ type' "button"
             , class "btn btn-primary left-buffer"
             , onClick <| UpdateWriteStuff <| SearchForNotes model.selectedNoteSearchItems ]
      [ span [ class "glyphicon glyphicon-search" ] []
      , text " Search for notes" 
      ] 
   ]

getItemsSelectText : List Int -> List PickItem -> String
getItemsSelectText selectedIds items =
  if List.isEmpty selectedIds
    then "All items"
    else (List.filter (\i -> List.member i.id selectedIds) items) |> List.map .title |> String.join ", "

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

getPickItemsEntries : List Int -> List PickItem -> List (String, Html Msg)
getPickItemsEntries selectedIds items =
  List.map (getPickItemEntry selectedIds) items

getPickItemEntry : List Int -> PickItem -> (String, Html Msg)
getPickItemEntry selectedIds item =
  ((toString item.id), li [] [ a [ href "#" ] [ getItemCheckbox selectedIds item ]]) 

getItemCheckbox : List Int -> PickItem -> Html Msg
getItemCheckbox selectedIds item =
  let
    selected = List.member item.id selectedIds
  in
    div [ class "checkbox" ] 
      [ label [] [ input [ type' "checkbox", checked selected, onCheck <| UpdateWriteStuff << (SetItemInNoteSearch item.id) ] []
      , text item.title ] 
      ]

getSearchResult : Bool -> List Note -> List PickItem -> Html a
getSearchResult hasSearchedForNotes searchResult pickedItems =
  if not hasSearchedForNotes
    then text ""
    else getSearchResultItems hasSearchedForNotes searchResult pickedItems

getSearchResultItems : Bool -> List Note -> List PickItem -> Html a
getSearchResultItems hasSearchedForNotes searchResult pickedItems =
  div [ class "row" ] 
    [ hr [] []
    , div [] 
      (if hasSearchedForNotes then getActualSearchResult searchResult pickedItems else getEmptySearchResult)
    ]

getEmptySearchResult : List (Html a)
getEmptySearchResult =
  [ div [] [ text "" ] ]

getActualSearchResult : List Note -> List PickItem -> List (Html a)
getActualSearchResult searchResult pickedItems =
  [ div [ class "list-group" ] 
    <| List.map (\sr -> a [ href "#", class "list-group-item" ] <| getSearchResultItem sr pickedItems) searchResult
  , p [] [ text ("Results found: " ++ (toString <| List.length searchResult)) ]
  ]

getSearchResultItem : Note -> List PickItem -> List (Html a)
getSearchResultItem searchResultItem pickedItems =
  let
    itemText = case find (\i -> i.id == searchResultItem.item) pickedItems of
      Just i -> i.title

      Nothing -> "Unknown item"
  in
    [ h4 [ class "list-group-item-heading" ] 
      [ text itemText
      , small [ class "left-buffer" ] [ text (format "%Y-%m-%d %H:%M" searchResultItem.date) ] ]
    , p [ class "list-group-item-text" ] [ text searchResultItem.text ]
    ]