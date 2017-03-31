module TestMatching where

import System.Directory
import System.FilePath

import EvaluationMonad
import GenStrat
import SolutionContext
import AlphaR
import NormalizationStrategies
import CoreS.AST
import qualified CoreS.ASTUnitype as AST
import CoreS.ASTUnitypeUtils
import CoreS.Parse
import Data.RoseTree
import Data.List

main = do
  args <- getArgs
  case args of
    [stud, mods] -> do
      studs   <- hasExtension <$> listDirectory stud
      mods    <- hasExtension <$> listDirectory mods
      results <- mapM (\stud -> checkMatches stud mods) studs
      let trues = [ () | (Just True) <- results ]
          all   = [ () | (Just _) <- results ]
          percentage = (genericLength trues / genericLength all) :: Double
      putStrLn "Total %: " ++ show percentage
    _ -> putStrLn "Bad args"

normalizations :: Normalizer CompilationUnit
normalizations = [ alphaRenaming ]

normalize :: CompilationUnit -> CompilationUnit
normalize = executeNormalizer normalizations

normalizeUAST :: AST.AST -> AST.AST
normalizeUAST  = AST.inCore normalize

checkMatches :: FilePath -> [FilePath] -> IO (Maybe Bool)
checkMatches stud mods = do
  let paths = Ctx stud mods
  (Ctx (stud) mods) <- resultEvalM ((fmap parseConv) <$> readRawContents paths)
  case stud of
    Left _     -> return Nothing
    Right stud ->
      return $ or [ matches
                    normalizeUAST
                    (AST.toUnitype $ normalize stud)
                    (AST.toUnitype (normalize mod))
                  | (Right mod) <- mods ]
