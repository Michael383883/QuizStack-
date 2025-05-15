module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Static
import Web.Controller.CreateQuestion

instance FrontController WebApplication where
    controllers = 
        [  startPage HomeAction
            --startPage WelcomeAction
        -- Generator Marker
        , parseRoute @CreateQuestionController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
