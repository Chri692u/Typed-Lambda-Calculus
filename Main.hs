module Main where

import Syntax
import Scanner
import Evaluation

import Control.Monad
import Control.Monad.Trans
import System.Console.Haskeline
        
process :: String -> IO ()
process line = do
  let ast = parseExpr line
  case ast of
    Left error -> print error
    Right exp -> do
      let output = eval exp []
      print output

run :: String -> IO ()
run filename = do
    s <- readFile filename
    print s
    let ast = parseExpr s
    case ast of
        Left error -> print error
        Right exp -> do
            let output = eval exp []
            print output

main :: IO ()
main = runInputT defaultSettings loop
  where
  loop = do
    minput <- getInputLine "8) "
    case minput of
      Nothing -> outputStrLn "8("
      Just input -> do
          let first = head $ words $ input
          case first of
              ":run" -> (liftIO $ run ((words $ input)!!1)) >> loop
              _ -> (liftIO $ process input) >> loop
              
