module State.Init exposing (init, subscriptions)

--import WebSocket

import Types exposing (..)
import StaticData exposing (..)

init : (Model, Cmd a)
init = (
  { page = Main DeclareStuff
  , client = initClient
  , declareAreas = initDeclareAreas
  , declareAreasLocked = False
  , pickedItems = initPickItems
  , pickedItemsLocked = False
  , notes = []
  , editingNote = Nothing
  , hasSearchedForNotes = False
  , selectedNoteSearchItems = []
  , noteSearchResult = []
  }
  , Cmd.none)

subscriptions : a -> Sub Msg
subscriptions model =
  Sub.none
--  WebSocket.listen "ws://localhost:3000" NewMessage