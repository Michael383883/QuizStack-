module Web.Controller.PuzzleResolution where

import Web.Controller.Prelude
import Web.View.PuzzleResolution.PuzzleResolution

instance Controller PuzzleResolutionController where
    action ShowPuzzleResolutionAction { puzzleId } = do
        puzzle <- fetch puzzleId
        pieces <- query @PuzzlePiece |> filterWhere (#puzzleId, puzzleId) |> fetchAll
        mapState <- getCurrentMapState puzzleId
        
        render PuzzleResolutionView { 
            puzzleId = puzzleId,
            currentPiece = Nothing,
            availablePieces = pieces,
            codeInstructions = getDefaultInstructions,
            mapState = mapState,
            isCompleted = False
        }
    
    action GetPieceAction { pieceId } = do
        piece <- fetch pieceId
        renderJSON $ object [
            "imageUrl" .= ("/images/puzzle-pieces/" <> get #pieceImage piece),
            "name" .= get #pieceName piece,
            "instructions" .= get #pieceInstructions piece
        ]
    
    action BuildPuzzleAction = do
        pieceId <- param "pieceId"
        code <- param "code"
        
        result <- validateAndBuildPiece pieceId code
        
        case result of
            Right mapState -> renderJSON $ object [
                "success" .= True,
                "mapState" .= mapStateToJSON mapState
            ]
            Left errorMsg -> renderJSON $ object [
                "success" .= False,
                "error" .= errorMsg
            ]
    
    action ExecutePuzzleAction = do
        puzzleState <- param "puzzleState"
        
        result <- executePuzzleLogic puzzleState
        
        case result of
            Right finalMap -> renderJSON $ object [
                "success" .= True,
                "finalMap" .= finalMapToJSON finalMap
            ]
            Left errorMsg -> renderJSON $ object [
                "success" .= False,
                "error" .= errorMsg
            ]
    
    action FinalizePuzzleAction = do
        puzzleId <- param "puzzleId"
        finalState <- param "finalState"
        
        -- Guardar estado final en la base de datos
        savePuzzleCompletion puzzleId finalState
        
        renderJSON $ object [
            "success" .= True,
            "redirectUrl" .= ("/puzzles/" <> show puzzleId <> "/results")
        ]

-- Funciones auxiliares
getCurrentMapState :: Int -> IO MapState
getCurrentMapState puzzleId = do
    -- Lógica para obtener el estado actual del mapa
    return $ MapState {
        completedRegions = [],
        currentMap = "southamerica-base.png",
        progress = 0.0
    }

getDefaultInstructions :: [Instruction]
getDefaultInstructions = [
    Instruction "Seleccionar" "#4CAF50" "SELECT",
    Instruction "Mover a..." "#2196F3" "MOVE_TO",
    Instruction "Girar" "#9C27B0" "ROTATE",
    Instruction "Repetir" "#FF9800" "REPEAT",
    Instruction "Si" "#F44336" "IF"
]

validateAndBuildPiece :: Int -> String -> IO (Either String MapState)
validateAndBuildPiece pieceId code = do
    -- Lógica para validar el código y construir la pieza
    -- Esto dependerá de tu lógica específica del puzzle
    return $ Right $ MapState {
        completedRegions = ["region1"],
        currentMap = "southamerica-progress-1.png",
        progress = 0.2
    }

executePuzzleLogic :: Value -> IO (Either String Value)
executePuzzleLogic puzzleState = do
    -- Lógica para ejecutar todo el puzzle
    return $ Right $ object [
        "finalImageUrl" .= ("/images/maps/southamerica-complete.png" :: String)
    ]

savePuzzleCompletion :: Int -> Value -> IO ()
savePuzzleCompletion puzzleId finalState = do
    -- Guardar en la base de datos
    return ()

-- Funciones de conversión JSON
mapStateToJSON :: MapState -> Value
mapStateToJSON MapState{..} = object [
    "completedRegions" .= completedRegions,
    "currentMap" .= currentMap,
    "progress" .= progress
]

finalMapToJSON :: Value -> Value
finalMapToJSON = id