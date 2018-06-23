module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Text.Pretty (Doc, beside, atop, render, text)

main :: Effect Unit
main = log (render doc)
  where
    doc :: Doc
    doc = step (step (step (step init)))

    init :: Doc
    init = text "*"

    step :: Doc -> Doc
    step d = d `atop` (d `beside` d)
