module Web.Controller.CreateQuestion where

import Web.Controller.Prelude
import Web.View.CreateQuestion.New
import Web.View.CreateQuestiontwo.NewCuestiontwo
import Web.View.Previewquestion.Previewquestion
import Web.View.PuzzleResolution.Index
import Web.View.CreateMapa.MapEditor

instance Controller CreateQuestionController where
    action NewCreateQuestionAction = do
        questions <- query @Question 
            |> orderByDesc #createdAt
            |> fetch
        render NewView { questions = questions }

    -- Nueva acción para crear la pregunta
    action CreateQuestionStepOneAction = do
        let questionText = param "question" :: Text
        let difficultyLevel = param "difficulty" :: Text
        
        -- Convertir el número de dificultad a texto
        let difficultyText = case difficultyLevel of
                "1" -> "Fácil"
                "2" -> "Medio"
                "3" -> "Difícil"
                _ -> "Fácil"  -- Valor por defecto
        
        -- Crear la nueva pregunta
        newQuestion <- newRecord @Question
            |> set #question questionText
            |> set #difficulty difficultyText
            |> createRecord
        
        -- Guardar la pregunta en la sesión para acceso posterior (mantener como respaldo)
        setSession "currentPuzzleQuestion" questionText
        setSession "currentPuzzleDifficulty" difficultyText
        setSession "currentQuestionId" (show $ get #id newQuestion)
        
        -- Redirigir al siguiente paso
        redirectTo NewCuestiontwoAction

    action NewCuestiontwoAction = do
        render NewCuestiontwoView
        
    action PreviewquestionAction = do
        render PreviewquestionView 
        
    -- ACCIÓN MODIFICADA: Recuperar la pregunta de la base de datos
    action PuzzleResolutionAction = do
        -- Recuperar la pregunta más reciente de la base de datos
        maybeLatestQuestion <- query @Question 
            |> orderByDesc #createdAt
            |> limit 1
            |> fetchOneOrNothing
        
        case maybeLatestQuestion of
            Just latestQuestion -> do
                let questionText = get #question latestQuestion
                -- Manejar el campo difficulty que puede ser Maybe Text
                let difficulty = case get #difficulty latestQuestion of
                        Just diff -> diff
                        Nothing -> "Fácil"  -- Valor por defecto si es Nothing
                
                -- Debug: Log para verificar que los datos se están recuperando
                putStrLn $ "📋 Pregunta recuperada: " <> questionText
                putStrLn $ "📊 Dificultad recuperada: " <> difficulty
                
                -- Renderizar la vista con la pregunta de la base de datos
                render PuzzleResolutionView { 
                    puzzleQuestion = questionText,
                    puzzleDifficulty = difficulty
                }
            Nothing -> do
                -- Debug: Log cuando no hay preguntas
                putStrLn "⚠️ No se encontraron preguntas en la base de datos"
                
                -- Si no hay preguntas en la base de datos, usar valores por defecto
                render PuzzleResolutionView { 
                    puzzleQuestion = "Resuelve el puzzle geográfico",
                    puzzleDifficulty = "Fácil"
                }
           
    action MapEditorAction = do  
        render MapEditorView