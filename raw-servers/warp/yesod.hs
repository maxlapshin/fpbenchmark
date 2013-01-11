{-# LANGUAGE TypeFamilies, QuasiQuotes, MultiParamTypeClasses, TemplateHaskell #-}
import Yesod
 
data HelloWorld = HelloWorld
 
mkYesod "HelloWorld" [parseRoutes|
                     / HomeR GET
|]
 
-- Disable session
instance Yesod HelloWorld where
    makeSessionBackend = const $ return Nothing
 
-- Disable Hamlet
getHomeR = return . RepPlain . toContent $ "Hello World!"
 
main :: IO ()
main = warp 3000 HelloWorld
