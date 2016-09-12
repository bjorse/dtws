module Views.ClientInfo exposing (clientInfoView)

import Html exposing (..)

import Types exposing (..)

clientInfoView : Model -> Html Msg
clientInfoView model =
  span [] 
    [ text "Yeah, the name of the client is "
    , strong [] [ text <| model.client.firstName ++ " " ++ model.client.lastName ]
    ]
