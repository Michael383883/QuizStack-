module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import GHC.Generics (Generic)



import Data.Aeson.TH (deriveJSON, defaultOptions)



data WebApplication = WebApplication deriving (Eq, Show)


data StaticController 
    = WelcomeAction
    | HomeAction 
    deriving (Eq, Show, Data)




data CreateQuestionController
    = NewCreateQuestionAction
    | NewCuestiontwoAction
    | PreviewquestionAction
    | PuzzleResolutionAction
    
    
    deriving (Eq, Show, Data)
    
-- Añade esto para el MapP

data PuzzlePiece = PuzzlePiece
    { pieceId :: Int
    , pieceName :: Text
    , pieceColor :: Text
    , pieceShape :: Text
    , isPlaced :: Bool
    } deriving (Show, Eq)

data PuzzleState = PuzzleState
    { availablePieces :: [PuzzlePiece]
    , selectedPiece :: Maybe PuzzlePiece
    , codeInstructions :: [Text]
    , mapProgress :: Int
    , isCompleted :: Bool
    } deriving (Show, Eq)

data PuzzleAction 
    = SelectPiece Int
    | MoveToPosition Text
    | RotatePiece
    | RepeatAction
    | BuildPiece
    | ExecutePuzzle
    deriving (Show, Eq)


