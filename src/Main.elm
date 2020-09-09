module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


-- main

main = Browser.element
  { init = init
  , update = update
  , view = view
  , subscriptions = subscriptions
  }

-- model

type alias Model =
  { p1Name : String
  , p1Score : Int
  , p2Name : String
  , p2Score : Int
  , mainDesc : String
  , subDesc : String
  }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { p1Name = "P1"
      , p1Score = 0
      , p2Name = "P2"
      , p2Score = 0
      , mainDesc = "Fight!"
      , subDesc = ""
      }
    , Cmd.none
    )

-- update

type Msg
  = P1Change String
  | P1ScoreChange (Int -> Int)
  | P2Change String
  | P2ScoreChange (Int -> Int)
  | MainDescChange String
  | SubDescChange String
  | ClearEverything

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClearEverything -> init ()
        P1Change name ->
            ( { model | p1Name = name }
            , Cmd.none
            )
        P1ScoreChange f ->
            let newModel = { model | p1Score = f model.p1Score }
            in
                ( newModel
                , Cmd.none
                )
        P2Change name ->
            ( { model | p2Name = name }
            , Cmd.none
            )
        P2ScoreChange f ->
            let newModel = { model | p2Score = f model.p2Score }
            in
                ( newModel
                , Cmd.none
                )
        MainDescChange str ->
            ( { model | mainDesc = str }
            , Cmd.none
            )
        SubDescChange str ->
            ( { model | subDesc = str }
            , Cmd.none
            )

-- subscriptions
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

-- view

view : Model -> Html Msg
view model =
    Element.layout [ Background.color black ] <|
    row [ centerX
        , centerY
        , spacing 4
        ]
        [ playerElement P1Change model.p1Name
        , column []
              [ btnElement "+" (P1ScoreChange (\x -> x+1)) grey
              , scoreElement (String.fromInt model.p1Score) (P1ScoreChange (\_ -> 0))
              , btnElement "-" (P1ScoreChange (\x -> x-1)) grey
              ]
        -- wip
        , column [centerX]
              [ infoElement MainDescChange model.mainDesc
              -- btnElement model.mainDesc ClearEverything white
              -- infoElement SubDescChange model.subDesc
              ]
        , column []
              [ btnElement "+" (P2ScoreChange (\x -> x+1)) grey
              , scoreElement (String.fromInt model.p2Score) (P2ScoreChange (\_ -> 0))
              , btnElement "-" (P2ScoreChange (\x -> x-1)) grey
              ]
        , playerElement P2Change model.p2Name
        ]

black = rgb255 0 0 0
white = rgb255 255 255 255
grey = rgb255 25 25 25
red = rgb255 255 0 0

btnElement str msg mainClr =
    Input.button [ Background.color black
                 , Element.focused [ Background.color black
                                   ]
                 , Element.mouseOver [ Font.color white
                                     ]
                 , Font.color mainClr
                 , Font.semiBold
                 , Font.family [ Font.external
                                     { name = "Roboto"
                                     , url = "https://fonts.googleapis.com/css?family=Roboto"
                                     }
                               , Font.monospace
                               ]
                 , padding 10
                 ]
    { onPress = Just msg
    , label = text str
    }

scoreElement str msg =
    Input.button [ Background.color white
                 , Element.focused [ Background.color white
                                   ]
                 , Element.mouseOver [ Font.color red
                                     ]
                 , Font.color black
                 , Font.semiBold
                 , Font.family [ Font.external
                                     { name = "Roboto"
                                     , url = "https://fonts.googleapis.com/css?family=Roboto"
                                     }
                               , Font.monospace
                               ]
                 , Border.rounded 5
                 , padding 10
                 ]
    { onPress = Just msg
    , label = text str
    }

infoElement msg modelField =
    Input.multiline [ Background.color black
               , Element.focused [ Background.color black
                                 ]
               , Font.color white
               , Font.extraBold
               , Font.center
               , Font.family [ Font.external
                                   { name = "Roboto"
                                   , url = "https://fonts.googleapis.com/css?family=Roboto"
                                     }
                             , Font.sansSerif
                             ]
               , Border.color black
               , Events.onDoubleClick ClearEverything
               ]
    { onChange = msg
    , text = modelField
    , placeholder = Nothing
    , label = Input.labelHidden ""
    , spellcheck = False
    }

playerElement msg modelField =
    Input.text [ Background.color black
               , Element.focused [ Background.color black
                                 ]
               , Font.color white
               , Font.extraBold
               , Font.center
               , Font.family [ Font.external
                                   { name = "Roboto"
                                   , url = "https://fonts.googleapis.com/css?family=Roboto"
                                     }
                             , Font.sansSerif
                             ]
               , Border.color white
               , Border.rounded 3
               ]
    { onChange = msg
    , text = modelField
    , placeholder = Nothing
    , label = Input.labelHidden ""
    }
