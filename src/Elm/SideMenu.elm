module SideMenu exposing (sideMenu)

import Html exposing (..)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)

import Types exposing (..)

sideMenu : Model -> Html Msg
sideMenu model =
  let
    menuItems = List.map (getMenuItem model) [ClientInfo, DeclareStuff, PickStuff, WriteStuff]
  in
    ul [ class "nav nav-pills nav-stacked" ] menuItems

getMenuItem : Model -> MainPage -> Html Msg
getMenuItem model page =
  li [ classList [ ("active", (model.page == Main page)) ] ] 
    [ a [ href "#", onClick <| ChangePage <| Main page ] [ text <| getMenuItemTitle page ] ]

getMenuItemTitle : MainPage -> String
getMenuItemTitle page =
  case page of
    ClientInfo -> "Client information"

    DeclareStuff -> "Declare stuff"

    PickStuff -> "Pick stuff"

    WriteStuff -> "Write stuff"