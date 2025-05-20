module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


--data StaticController = WelcomeAction deriving (Eq, Show, Data)

data StaticController 
    = WelcomeAction
    | HomeAction -- Añadimos esta línea para nuestra página de inicio
    deriving (Eq, Show, Data)

data CreateQuestionController
    = NewCreateQuestionAction
    | NewCuestiontwoAction
    | PreviewquestionAction
    | PuzzleResolutionAction
    deriving (Eq, Show, Data)