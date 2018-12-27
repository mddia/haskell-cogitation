module Types where

import Data.Time
import qualified Data.Text as T

data Attendee = Person { fstName :: String
                        , lastName :: String
                        }
type Location = String
type Subject = String
type Schedule =  UTCTime
data Event = Event Subject Location Schedule [Attendee] Price Status Duration
data Price = Maybe Int
data Duration = Duration Int String
data Status = Open | Close

