module Views.ViewUtils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Types exposing (..)

getPickAreaLevel : DeclareArea -> Html Msg
getPickAreaLevel area =
  span [ class ("label big-label " ++ (getAreaLevelColor area.level)) ] [ text <| toString area.level ]

getAreaLevelColor : AreaLevel -> String
getAreaLevelColor areaLevel =
  case areaLevel of
    Low -> "label-success"

    Medium -> "label-warning"

    High -> "label-danger"

getLockToggleButton : Bool -> (Bool -> a) -> Html a
getLockToggleButton locked msg =
  let
    buttonText = if locked then "Unlock" else "Lock"
    buttonType = if locked then "btn-default" else "btn-success"
  in
    button [ class <| "btn " ++ buttonType, onClick (msg <| not locked) ] [ text buttonText ]

getLockedInformation : Html a
getLockedInformation =
  div [ class "alert alert-success text-center" ] [ text "This area is locked and no changes can be made!"]