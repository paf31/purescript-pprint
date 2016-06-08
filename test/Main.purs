module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Text.Pretty (Doc, beside, atop, render, text)

main :: forall eff. Eff (console :: CONSOLE | eff) Unit
main = log (render doc)
  where
    doc :: Doc
    doc = step (step (step (step init)))

    init :: Doc
    init = text "*"

    step :: Doc -> Doc
    step d = d `atop` (d `beside` d)
