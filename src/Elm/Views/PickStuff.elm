module Views.PickStuff exposing (pickStuffView)

import Html exposing (..)
import Html.Attributes exposing (class, type', attribute, href, checked)
import Html.Events exposing (onCheck)
import Html.Keyed as Keyed

import Types exposing (..)
import Views.ViewUtils exposing (..)

pickStuffView : Model -> Html Msg
pickStuffView model =
  if model.declareAreasLocked then getAreaViews model else getNotLockedWarning

getNotLockedWarning : Html a
getNotLockedWarning =
  div [ class "alert alert-danger" ] 
    [ span [ class "glyphicon glyphicon-exclamation-sign" ] []
    , b [] [ text " OMG! "]
    , text "You need to lock declare stuff before picking stuff!"
    ]

getAreaViews : Model -> Html Msg
getAreaViews model =
  let
    areasToPick = List.filter (\a -> a.level /= Low) model.declareAreas
    anyAreas = (not << List.isEmpty) areasToPick
  in
    if anyAreas then getAllAreasView areasToPick model else getNoAreasWarning

getNoAreasWarning : Html a
getNoAreasWarning =
  div [ class "alert alert-warning" ]
    [ span [ class "glyphicon glyphicon-exclamation-sign"] []
    , b [] [ text " LOL! " ]
    , text "There's no areas available (all are set to Low)!"
    ]

getAllAreasView : List DeclareArea -> Model -> Html Msg
getAllAreasView areas model =
  div [] 
    [ if model.pickedItemsLocked then (div [ class "row" ] [ getLockedInformation ]) else (text "")
    , div [ class "row" ] [ div [ class "list-group"] <| List.map (getAreaView model.pickedItems model.pickedItemsLocked) areas ]
    , div [ class "row" ] [ getLockToggleButton model.pickedItemsLocked (UpdatePickStuff << SetPickedItemsLocked) ]
    ]

getAreaView : List PickItem -> Bool -> DeclareArea -> Html Msg 
getAreaView allItems locked area =
  let
    daId = area.id
    areaItems = List.filter (\i -> List.member daId i.availableDeclareAreas) allItems
    pickedItems = getPickedItems daId allItems
  in
    div [ class "list-group-item" ]
      [ div [ class "form-inline" ]
        [ h4 [ class "pull-left list-group-item-heading" ] [ text area.title ] 
        , div [ class "pull-right" ] [ getPickAreaLevel area ]
        ]
      , div [ class "clearfix" ] []
      , div [ class "row" ]
        [ div [ class "col-md-8" ] [ text area.description ]
        , div [ class "col-md-4" ] <| if locked then [ getReadOnlyPickItemsView daId pickedItems area.level ] 
                                                else getPickItemsView daId areaItems
        ]
      ]

getReadOnlyPickItemsView : Int -> List PickItem -> AreaLevel -> Html a
getReadOnlyPickItemsView dsId items level =
    ul [ class "list-unstyled" ] <| List.map (getReadonlyItemInfo level) <| getPickedItems dsId items

getReadonlyItemInfo : AreaLevel -> PickItem -> Html a
getReadonlyItemInfo level item =
  li [ class "bottom-buffer" ] [ span [ class <| "label medium-label " ++ getAreaLevelColor level ] [ text item.title ]]

getPickItemsView : Int -> List PickItem -> List (Html Msg)
getPickItemsView daId items =
  let
    pickedItems = getPickedItems daId items
  in
    [ div [ class "row" ]
      [ div [ class "btn-group" ]
        [ button [ type' "button", class "btn btn-info dropdown-toggle", attribute "data-toggle" "dropdown" ]
          [ text "Select items " 
          , span [ class "caret" ] []
          ]
        , Keyed.ul [ class "dropdown-menu" ] <| getPickItemsEntries daId items
        ]
      ]
    , div [ class "row" ]
      [ Keyed.ul [ class "list-unstyled" ] <| getPickedItemsEntries daId pickedItems ]
    ]

getPickedItems : Int -> List PickItem -> List PickItem
getPickedItems daId items =
  List.filter (\i -> List.member daId i.pickedDeclareAreas) items

getPickedItemsEntries : Int -> List PickItem -> List (String, Html Msg)
getPickedItemsEntries daId items =
  List.map (getPickedItemEntry daId) items

getPickedItemEntry : Int -> PickItem -> (String, Html Msg)
getPickedItemEntry daId item =
  ((getItemId daId item), li [] [ getItemCheckbox daId item ])

getPickItemsEntries : Int -> List PickItem -> List (String, Html Msg)
getPickItemsEntries daId items =
  List.map (getPickItemEntry daId) items

getPickItemEntry : Int -> PickItem -> (String, Html Msg)
getPickItemEntry daId item =
  ((getItemId daId item), li [] [ a [ href "#" ] [ getItemCheckbox daId item ]]) 

getItemCheckbox : Int -> PickItem -> Html Msg
getItemCheckbox daId item =
  let
    selected = List.member daId item.pickedDeclareAreas
  in
    div [ class "checkbox" ] 
      [ label [] [ input [ type' "checkbox", checked selected, onCheck <| UpdatePickStuff << SetPickedItemState daId item.id ] []
      , text item.title ] 
      ]

getItemId : Int -> PickItem -> String
getItemId daId item =
  (toString daId) ++ "-" ++ (toString item.id)