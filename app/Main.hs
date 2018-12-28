{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Spock
import Web.Spock.Config
import Control.Monad.Trans
import Data.IORef
import Data.Monoid
import Lib
import qualified Data.Text as T
import Types
import Network.Mail.SMTP


--Function composition
f :: Int -> Int
g :: Int -> Int
h :: Int -> Int
eventSubject :: Subject
eventSubject = "Un sujet"
f x = 2*x
g x = x+1
h = \x->g(f x)

data MySession = EmptySession
data MyAppState = DummyAppState (IORef Int)


--main :: IO ()
--main = do
--	print $ h 3
--	putStrLn eventSubject
from       = Address Nothing "mamadou1.dia@gmail.com"
to         = [Address (Just "Jason Hickner") "mamadou1.dia@gmail.com"]
cc         = []
bcc        = []
subject    = "email subject"
bodyOfMail       = plainTextPart "email body"
htmlOfMail       = htmlPart "<h1>HTML</h1>"

mail = simpleMail from to cc bcc subject [bodyOfMail, htmlOfMail]



--sendEmailTo = sendMailWithLogin "smtp.gmail.com" "mamadou1.dia@gmail.com" "Nique Google" mail

main :: IO ()
main =
    do ref <- newIORef 0
       spockCfg <- defaultSpockCfg EmptySession PCNoDatabase (DummyAppState ref)
       runSpock 8787 (spock spockCfg app)

app :: SpockM () MySession MyAppState ()
app =
    do get root $
           text "Hello World!"
       get ("hello" <//> var) $ \name ->
           do (DummyAppState ref) <- getState
              visitorNumber <- liftIO $ atomicModifyIORef' ref $ \i -> (i+1, i+1)
              text ("Hello " <> name <> ", you are visitor number " <> T.pack (show visitorNumber))

       get ("send-email" <//> var) $ \emailAddr ->
           do (DummyAppState ref) <- getState 
              sendMailWithLogin "smtp.gmail.com" "mamadou1.dia@gmail.com" "Nique Google" mail
              text ("Email sent at " <> emailAddr)

