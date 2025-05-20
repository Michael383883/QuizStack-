module Web.Controller.CreateQuestion where

import Web.Controller.Prelude
import Web.View.CreateQuestion.New
import Web.View.CreateQuestiontwo.NewCuestiontwo
import Web.View.Previewquestion.Previewquestion
import Web.View.PuzzleResolution.PuzzleResolution

instance Controller CreateQuestionController where
    action NewCreateQuestionAction = do
        render NewView

    action NewCuestiontwoAction= do
        render NewCuestiontwoView

    action PreviewquestionAction= do
        render PreviewquestionView 

    action PuzzleResolutionAction= do
        render PuzzleResolutionView      



