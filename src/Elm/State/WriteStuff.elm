module State.WriteStuff exposing (updateWriteStuff)

import Task.Extra exposing (performFailproof)
import Date
import String

import Types exposing (..)

updateWriteStuff : WriteStuffMsg -> Model -> (Model, Cmd Msg)
updateWriteStuff msg model =
  case msg of
    EditNote ->
      { model | editingNote = Just { text = "", item = Nothing }} ! []

    SelectItemInEditNote itemId ->
      case model.editingNote of
        Just note ->
          let 
            updateNote = { note | item = Just itemId }
          in
            { model | editingNote = Just updateNote } ! []

        Nothing ->
          model ! []

    UpdateTextInEditNote text ->
      case model.editingNote of
        Just note ->
          { model | editingNote = Just { note | text = text }} ! []

        Nothing ->
          model ! []

    CancelEditNote ->
      { model | editingNote = Nothing } ! []

    SaveEditedNote note ->
      ({ model | editingNote = Nothing }, Date.now |> performFailproof (UpdateWriteStuff << SaveNote note))

    SaveNote note date ->
      let
        itemId = case note.item of 
                  Just id -> id 
                  Nothing -> 0
        newNote = { id = getNextNoteId model.notes, text = String.trim note.text, item = itemId, date = date }
      in
        { model | notes = newNote :: model.notes } ! []
      
    SetItemInNoteSearch itemId selected ->
      { model | selectedNoteSearchItems = if selected 
                                          then itemId :: model.selectedNoteSearchItems 
                                          else List.filter (\i -> i /= itemId) model.selectedNoteSearchItems} ! []
    
    ClearSelectedItemsInNoteSearch ->
      { model | selectedNoteSearchItems = [] } ! []
    
    SearchForNotes items ->
      { model | hasSearchedForNotes = True
              , noteSearchResult = if List.isEmpty items 
                                   then model.notes
                                   else List.filter (\n -> List.member n.item items) model.notes } ! []

getNextNoteId : List Note -> Int
getNextNoteId notes =
  case List.maximum (List.map .id notes) of
    Just id -> id + 1
    Nothing -> 1