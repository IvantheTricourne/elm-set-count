module Main exposing (..)


import Browser
import Html exposing (Html, Attribute, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import File.Download as Download



-- MAIN


main = Browser.element
  { init = init
  , update = update
  , view = view
  , subscriptions = \_ -> Sub.none
  }



-- MODEL


type alias Model =
  { p1Name : String
  , p1Score : Int
  , p2Name : String
  , p2Score : Int
  }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { p1Name = ""
      , p1Score = 0
      , p2Name = ""
      , p2Score = 0
      }
    , Cmd.none
    )


playerNames : Model -> String
playerNames model =
    model.p1Name ++ " vs " ++ model.p2Name

playerScores : Model -> String
playerScores model =
    String.fromInt model.p1Score ++ " - " ++ String.fromInt model.p2Score



-- UPDATE


type Msg
  = P1Change String
  | P1ScoreChange (Int -> Int)
  | P2Change String
  | P2ScoreChange (Int -> Int)
  | SavePlayers


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        P1Change name ->
            ( { model | p1Name = name }
            , Cmd.none
            )
        P1ScoreChange f ->
            let newModel = { model | p1Score = f model.p1Score }
            in
                ( newModel
                , Download.string "score.txt" "text/plain" (playerScores newModel)
                )
        P2Change name ->
            ( { model | p2Name = name }
            , Cmd.none
            )
        P2ScoreChange f ->
            let newModel = { model | p2Score = f model.p2Score }
            in
                ( newModel
                , Download.string "score.txt" "text/plain" (playerScores newModel)
                )
        SavePlayers ->
            ( model
            , Download.string "players.txt" "text/plain" (playerNames model)
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
              [ input
                    [ placeholder "P1", value model.p1Name, onInput P1Change
                    ]
                    []
              ,  button [ onClick (P1ScoreChange (\x -> x - 1)) ] [ text "-" ]
              , text (String.fromInt model.p1Score)
              , button [ onClick (P1ScoreChange (\x -> x + 1)) ] [ text "+" ]
              , button [ onClick (P1ScoreChange (\_ -> 0)) ] [ text "c" ]
              ]
        , div []
              [ input
                  [ placeholder "P2", value model.p2Name, onInput P2Change
                  ]
                  []
              , button [ onClick (P2ScoreChange (\x -> x - 1)) ] [ text "-" ]
              , text (String.fromInt model.p2Score)
              , button [ onClick (P2ScoreChange (\x -> x + 1)) ] [ text "+" ]
              , button [ onClick (P2ScoreChange (\_ -> 0)) ] [ text "c" ]
              ]
        , button [ onClick SavePlayers ] [ text "save players" ]
        ]
