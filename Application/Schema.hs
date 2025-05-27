module Application.Schema where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data ProcessedMap = ProcessedMap
    { id :: Id ProcessedMap
    , originalFileName :: Text
    , mapType :: Text
    , processedImageData :: Text
    , countriesData :: Text
    , createdAt :: UTCTime
    , updatedAt :: UTCTime
    } deriving (Eq, Show, Generic)

deriveModel ''ProcessedMap
