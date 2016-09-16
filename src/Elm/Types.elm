module Types exposing (..)

import Date exposing (Date)

-- PAGES

type Page
  = Login
  | Main MainPage

type MainPage
  = ClientInfo
  | DeclareStuff
  | PickStuff
  | WriteStuff

-- MSG

type DeclareStuffMsg
  = UpdateArea DeclareArea
  | SetDeclareAreaLocked Bool

type PickStuffMsg
  = SetPickedItemState Int Int Bool
  | SetPickedItemsLocked Bool

type WriteStuffMsg
  = EditNote
  | SelectItemInEditNote Int
  | UpdateTextInEditNote String
  | CancelEditNote
  | SaveEditedNote NoteEdit
  | SaveNote NoteEdit Date
  | SetItemInNoteSearch Int Bool
  | ClearSelectedItemsInNoteSearch
  | SearchForNotes (List Int)

type Msg 
  = ChangePage Page
  | NewMessage String
  | UpdateDeclareStuff DeclareStuffMsg
  | UpdatePickStuff PickStuffMsg
  | UpdateWriteStuff WriteStuffMsg

-- MODEL

type alias Client =
  { id: Int 
  , firstName: String
  , lastName: String
  }

type AreaLevel = Low | Medium | High

type alias DeclareArea =
  { id: Int
  , title: String
  , level: AreaLevel
  , description: String
  }

type alias PickItem =
  { id: Int
  , title: String
  , availableDeclareAreas: List Int
  , pickedDeclareAreas: List Int
  }

type alias Note =
  { id: Int
  , text: String
  , item: Int
  , date: Date
  }

type alias NoteEdit =
  { text: String
  , item: Maybe Int 
  }

type alias Model =
  { page: Page
  , client: Client
  , declareAreas: List DeclareArea
  , declareAreasLocked: Bool
  , pickedItems: List PickItem
  , pickedItemsLocked: Bool
  , notes: List Note
  , editingNote: Maybe NoteEdit
  , hasSearchedForNotes: Bool
  , selectedNoteSearchItems: List Int
  , noteSearchResult: List Note
  }