module Views.DeclareStuff exposing (declareStuffView)

import Html exposing (..)
import Html.Attributes exposing (class, name, type', checked, attribute)
import Html.Events exposing (onClick, onInput)

import Types exposing (..)
import Views.ViewUtils exposing (..)

declareStuffView : Model -> Html Msg
declareStuffView model =
  let
    declareAreas = List.sortBy .id model.declareAreas |> List.map (getArea model.declareAreasLocked)
  in
    div []
      [ if model.declareAreasLocked then div [ class "row" ] [ getLockedInformation ] else text ""
      , div [ class "row" ] [ div [ class "list-group" ] declareAreas ]
      , div [ class "row" ] [ getLockToggleButton model.declareAreasLocked <| UpdateDeclareStuff << SetDeclareAreaLocked ]
      ]

getArea : Bool -> DeclareArea -> Html Msg
getArea areaLocked area =
  div [ class "list-group-item" ] 
    [ div [ class "form-inline" ] 
      [ h4 [ class "pull-left list-group-item-heading" ] [ text area.title ]
      , div [ class "pull-right" ] [ if areaLocked then getPickAreaLevel area else getActivePickAreaLevel area ]
      ]
    , div [ class "clearfix"] []
    , if areaLocked then getReadOnlyDescription area.description else getEditableDescription area
    ]

getReadOnlyDescription : String -> Html Msg
getReadOnlyDescription description =
  p [ class "list-group-item-text" ] [ text description ]

getEditableDescription : DeclareArea -> Html Msg
getEditableDescription area =
  div [ class "form-group" ] 
    [ textarea [ class "form-control", attribute "rows" "6", onInput <| getUpdateDescription area ] [ text area.description ] ]

getUpdateDescription : DeclareArea -> String -> Msg
getUpdateDescription area newDescription =
  UpdateDeclareStuff <| UpdateArea { area | description = newDescription }

getActivePickAreaLevel : DeclareArea -> Html Msg
getActivePickAreaLevel area =
  let
    areaNameSuffix = toString area.id
    radioButtons = List.map (\a -> radio area areaNameSuffix a <| UpdateDeclareStuff <| UpdateArea { area | level = a }) [Low, Medium, High]
  in
    fieldset [] radioButtons

radio : DeclareArea -> String -> AreaLevel -> msg -> Html msg
radio area nameSuffix areaLevel msg =
  let
    title = toString areaLevel
    areaLevelColor = getActiveLevelColor areaLevel
  in
    label [ class <| "radio-inline " ++ areaLevelColor ]
      [ input [ type' "radio", name <| "areaLevel-" ++ nameSuffix, onClick msg, checked <| area.level == areaLevel ] []
      , text title
      ]

getActiveLevelColor : AreaLevel -> String
getActiveLevelColor areaLevel =
  case areaLevel of 
    Low -> "text-success"

    Medium -> "text-warning"

    High -> "text-danger"