module Main where

import Lib
import Types

--Function composition
f :: Int -> Int
g :: Int -> Int
h :: Int -> Int
eventSubject :: Subject
eventSubject = "Un sujet"
createEvent :: * -> Event
f x = 2*x
g x = x+1
h = \x->g(f x)

main :: IO ()
main = do
	print $ h 3
	putStrLn eventSubject
