module Web.Controller.Questions where

import Web.Controller.Prelude
import Web.View.Questions.New
import Web.View.Questions.Edit
import Web.View.Questions.Index
import Web.View.Questions.Show

instance Controller QuestionsController where
    action CreateQuestionAction = do
        question <- jsonBody
        question
            |> validateField #question nonEmpty
            |> validateField #difficultyLevel isPositive
            |> ifValid \case
                Left errors -> do
                    renderJson (jsonError errors)
                Right question -> do
                    question <- question |> createRecord
                    renderJson $ jsonSuccess (question :: Question)

    action UpdateQuestionAction { questionId } = do
        question <- fetch questionId
        questionPatch <- jsonBody
        let updatedQuestion = question
                |> fill questionPatch
        updatedQuestion
            |> validateField #question nonEmpty
            |> validateField #difficultyLevel isPositive
            |> ifValid \case
                Left errors -> renderJson (jsonError errors)
                Right updated -> do
                    updated <- updated |> updateRecord
                    renderJson $ jsonSuccess (updated :: Question)
