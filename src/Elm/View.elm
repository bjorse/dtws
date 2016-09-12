module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)

import Types exposing (..)
import SideMenu exposing (sideMenu)
import Views.ClientInfo exposing (clientInfoView)
import Views.DeclareStuff exposing (declareStuffView)
import Views.PickStuff exposing (pickStuffView)
import Views.WriteStuff exposing (writeStuffView)

view : Model -> Html Msg
view model =
  div []
    [ div [ class "row" ] 
      [ div [ class "page-header" ]
        [ h1 [] [ text "Do things with stuff ", small [] [ text "because it's fun!" ] ] ]
      ]
    , div [ class "row" ] (getViewToShow model)
    ]

getViewToShow : Model -> List (Html Msg)
getViewToShow model =
  case model.page of
    Login -> getLoginView model

    Main mainPage -> getMainView model mainPage

getLoginView : Model -> List (Html a)
getLoginView model =
  [ div [] [] ]

getMainView : Model -> MainPage -> List (Html Msg)
getMainView model mainPage =
  [ div [ class "col-md-2" ] [ sideMenu model ]
  , div [ class "col-md-10" ] [ getMainPageToShow model mainPage ]
  ]

getMainPageToShow : Model -> MainPage -> (Html Msg)
getMainPageToShow model mainPage =
  case mainPage of
    ClientInfo -> clientInfoView model

    DeclareStuff -> declareStuffView model

    PickStuff -> pickStuffView model

    WriteStuff -> writeStuffView model