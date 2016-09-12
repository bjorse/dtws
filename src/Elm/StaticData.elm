module StaticData exposing (..)

import Types exposing (..)

initClient : Client
initClient =
  { id = 1
  , firstName = "Kalle"
  , lastName = "Kula"
  }

initDeclareAreas : List DeclareArea
initDeclareAreas = 
  [ { id = 1
    , title = "First area"
    , level = Low
    , description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget ex eu ipsum tincidunt tempor sit amet et arcu. Ut molestie scelerisque placerat. Donec ligula diam, viverra consequat felis at, viverra imperdiet velit. Vestibulum velit magna, fringilla ut urna ut, tempor mattis purus. Proin elementum lectus ut leo commodo gravida. Nam id erat nisl. Integer a varius purus. Mauris pellentesque, ex non commodo efficitur, neque mi blandit ex, vitae rhoncus urna nulla quis nisi. Vivamus maximus dui vitae nibh feugiat, quis iaculis ex convallis. Cras ut sapien eu justo sollicitudin faucibus sit amet blandit ante. Curabitur arcu turpis, imperdiet sed nibh a, interdum aliquet ipsum. Maecenas fringilla interdum dui ac interdum. Mauris eget lorem sodales, blandit nisi nec, fermentum risus."
    },
    { id = 2
    , title = "Second area"
    , level = High
    , description = "Quisque mattis, est in malesuada iaculis, dui lorem lobortis mi, aliquet aliquam urna purus sit amet est. Integer hendrerit aliquam erat, a sagittis ante fermentum ut. Morbi rhoncus elit eget mi accumsan, eget pharetra ex sollicitudin. Vivamus posuere at leo quis congue. Nunc egestas quam et odio malesuada, id fringilla est mollis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut elementum mauris nec orci pulvinar iaculis. Integer tristique non leo interdum pretium. Quisque ac pellentesque urna. Phasellus accumsan erat lacus, nec tincidunt augue euismod eget. Maecenas eu ligula orci. Duis molestie neque nisi, at malesuada risus consectetur nec. Morbi egestas urna eu nisl finibus, laoreet vehicula ex egestas. Cras finibus accumsan semper."
    },
    { id = 3
    , title = "Third area"
    , level = Medium
    , description = "In liber definitiones vim, dicam eripuit mediocritatem per ex, ne feugait ocurreret quaerendum duo. Te dolor equidem erroribus vel, legimus albucius scribentur est et, est ex omnesque pertinax. At illum eirmod propriae mea, per ex rebum dolores consequuntur. Dicat ullum has ad, in quaeque numquam nominati mei, paulo salutandi dissentiet in sit. Posse phaedrum definitionem qui at. Et persius posidonium vel, ex pericula electram est."
    }
  ]

initPickItems : List PickItem
initPickItems =
  [ { id = 1
    , title = "First item"
    , availableDeclareAreas = [ 1, 2, 3 ]
    , pickedDeclareAreas = []
    },
    { id = 2
    , title = "Second item"
    , availableDeclareAreas = [ 2, 3 ]
    , pickedDeclareAreas = []
    },
    { id = 3
    , title = "Third item"
    , availableDeclareAreas = [ 1 ]
    , pickedDeclareAreas = []
    },
    { id = 4
    , title = "Fourth item"
    , availableDeclareAreas = [ 3 ]
    , pickedDeclareAreas = []
    },
    { id = 5
    , title = "Fifth item"
    , availableDeclareAreas = [ 2 ]
    , pickedDeclareAreas = []
    },
    { id = 6
    , title = "Sixth item"
    , availableDeclareAreas = [ 1, 2 ]
    , pickedDeclareAreas = []
    },
    { id = 7
    , title = "Seventh item"
    , availableDeclareAreas = [ 2, 3 ]
    , pickedDeclareAreas = []
    },
    { id = 8
    , title = "Eigth item"
    , availableDeclareAreas = [ 1, 2, 3 ]
    , pickedDeclareAreas = []
    },
    { id = 9
    , title = "Ninth item"
    , availableDeclareAreas = [ 2, 3 ]
    , pickedDeclareAreas = []
    },
    { id = 10
    , title = "Tenth item"
    , availableDeclareAreas = [ 1, 3 ]
    , pickedDeclareAreas = []
    },
    { id = 11
    , title = "Eleventh item"
    , availableDeclareAreas = [ 3 ]
    , pickedDeclareAreas = []
    }
  ]