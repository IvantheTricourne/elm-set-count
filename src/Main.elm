module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
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
  }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { p1Name = "P1"
      , p1Score = 0
      , p2Name = "P2"
      , p2Score = 0
      }
    , Cmd.none
    )

-- update

type Msg
  = P1Change String
  | P1ScoreChange (Int -> Int)
  | P2Change String
  | P2ScoreChange (Int -> Int)
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

-- subscriptions
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

-- view

view : Model -> Html Msg
view model =
    Element.layout [ Background.color black ] <|
    row [ centerX
        , centerY
        ]
        [ column []
              [ btnElement "+" (P1ScoreChange (\x -> x+1)) grey
              , btnElement (String.fromInt model.p1Score) (P1ScoreChange (\_ -> 0)) white
              , btnElement "-" (P1ScoreChange (\x -> x-1)) grey
              ]
        , inputElement P1Change model.p1Name
        , btnElement "vs" ClearEverything white
        , inputElement P2Change model.p2Name
        , column []
              [ btnElement "+" (P2ScoreChange (\x -> x+1)) grey
              , btnElement (String.fromInt model.p2Score) (P2ScoreChange (\_ -> 0)) white
              , btnElement "-" (P2ScoreChange (\x -> x-1)) grey
              ]
        ]

black = rgb255 0 0 0
white = rgb255 255 255 255
grey = rgb255 50 50 50

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

inputElement msg modelField =
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
               ]
    { onChange = msg
    , text = modelField
    , placeholder = Nothing
    , label = Input.labelHidden ""
    }
