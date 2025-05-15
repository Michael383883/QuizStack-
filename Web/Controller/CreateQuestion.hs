module Web.Controller.CreateQuestion where

import Web.Controller.Prelude
import Web.View.CreateQuestion.New

instance Controller CreateQuestionController where
    action NewCreateQuestionAction = do
        render NewView