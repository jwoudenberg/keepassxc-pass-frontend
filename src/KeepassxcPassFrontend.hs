module KeepassxcPassFrontend (main) where

import qualified System.Environment
import qualified System.Exit
import qualified System.Posix

main :: IO ()
main = do
  args <- System.Environment.getArgs
  case args of
    ["show", entry] -> showNotes entry
    ["show", "-c", entry] -> copyPassword entry
    ["--help"] -> help
    _ -> do help; System.Exit.exitFailure

showNotes :: String -> IO ()
showNotes entry = do
  database <- databasePath
  System.Posix.executeFile
    "keepassxc-cli"
    True
    ["show", "-y", "1", database, entry]
    Nothing

copyPassword :: String -> IO ()
copyPassword entry = do
  database <- databasePath
  System.Posix.executeFile
    "keepassxc-cli"
    True
    ["clip", "-y", "1", database, entry]
    Nothing

databasePath :: IO String
databasePath = System.Environment.getEnv "KEEPASSXC_PASSWORD_DB"

help :: IO ()
help = do
  putStrLn "A pass-like frontend to keepassxc."
  putStrLn "Currently supported commands:"
  putStrLn ""
  putStrLn "  pass show <entry>"
  putStrLn "  pass show -c <entry>"
