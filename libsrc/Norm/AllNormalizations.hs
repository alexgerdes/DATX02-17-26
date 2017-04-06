module Norm.AllNormalizations where

import CoreS.AST
import NormalizationStrategies
import Norm.NormFor
import Norm.CompAssignment
import AlphaR
import Norm.VarDecl
import Norm.ElimRedundant
import Norm.ElimDead
import Norm.IfElseEmpty
import Norm.DoWToWhile
import Norm.FloatToDouble

normalizations :: Normalizer CompilationUnit
normalizations = [ alphaRenaming, normForToWhile, normCompAss,
                   normMoveForTVD, normSingleTVDs, normVDIArrLeft,
                   normSplitInit, normVDTop ,normSortT,
                   normFlattenBlock, normEmptyBlock, normFilterEmpty,
                   normSingleton, normDeadIf, normDeadDo,
                   normDeadWhile, normDeadFor, normDoWToWhile,
                   normIESiEmpty, normIESeEmpty, normIEBothEmpty,
                   normFloatToDoubleVars, normFloatToDoubleRet]
