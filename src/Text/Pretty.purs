-- | This module defines a set of combinators for pretty printing text.

module Text.Pretty
  ( Doc
  , width
  , height
  , render
  , empty
  , text
  , beside
  , atop
  , Stack(..)
  , vcat
  , Columns(..)
  , hcat
  ) where

import Prelude
import Data.Array (length, range, take, zipWith)
import Data.Foldable (class Foldable, foldl, foldMap, intercalate)
import Data.Newtype (ala, class Newtype, wrap)
import Data.String as S
import Data.String.CodeUnits as SCU
import Data.Unfoldable (replicate)

-- | A text document.
newtype Doc = Doc
  { width  :: Int
  , height :: Int
  , lines  :: Array String
  }

-- | Get the width of a document.
width :: Doc -> Int
width (Doc doc) = doc.width

-- | Get the height of a document.
height :: Doc -> Int
height (Doc doc) = doc.height

-- | Render a document to a string.
render :: Doc -> String
render (Doc doc) = intercalate "\n" doc.lines

-- | An empty document
empty :: Int -> Int -> Doc
empty w h =
  Doc { width: w
      , height: h
      , lines: case h of
                 0 -> []
                 _ -> range 1 h $> ""
      }

-- | Create a document from some text.
text :: String -> Doc
text s =
  Doc { width:  foldl max 0 $ map S.length lines
      , height: length lines
      , lines:  lines
      }
  where
  lines = S.split (wrap "\n") s

-- | Place one document beside another.
beside :: Doc -> Doc -> Doc
beside (Doc d1) (Doc d2) =
  Doc { width:  d1.width + d2.width
      , height: height_
      , lines:  take height_ $ zipWith append (map (padRight d1.width) (adjust d1)) (adjust d2)
      }
  where
    height_ :: Int
    height_ = max d1.height d2.height

    -- Adjust a document to fit the new width and height
    adjust :: { lines :: Array String, width :: Int, height :: Int } -> Array String
    adjust d = d.lines <> replicate (height_ - d.height) (emptyLine d.width)

    emptyLine :: Int -> String
    emptyLine w = SCU.fromCharArray (replicate w ' ' :: Array Char)

    padRight :: Int -> String -> String
    padRight w s = s <> emptyLine (w - S.length s)

-- | Place one document on top of another.
atop :: Doc -> Doc -> Doc
atop (Doc d1) (Doc d2) =
  Doc { width:  max d1.width d2.width
      , height: d1.height + d2.height
      , lines:  d1.lines <> d2.lines
      }

-- | Place documents in columns
hcat :: forall f. Foldable f => f Doc -> Doc
hcat = ala Columns foldMap

-- | Stack documents vertically
vcat :: forall f. Foldable f => f Doc -> Doc
vcat = ala Stack foldMap

-- | A wrapper for `Doc` with a `Monoid` instance which stacks documents vertically.
newtype Stack = Stack Doc

derive instance newtypeStack :: Newtype Stack _

instance semigroupStack :: Semigroup Stack where
  append (Stack d1) (Stack d2) = Stack (d1 `atop` d2)

instance monoidStack :: Monoid Stack where
  mempty = Stack (empty 0 0)

-- | A wrapper for `Doc` with a `Monoid` instance which stacks documents in columns.
newtype Columns = Columns Doc

derive instance newtypeColumns :: Newtype Columns _

instance semigroupColumns :: Semigroup Columns where
  append (Columns d1) (Columns d2) = Columns (d1 `beside` d2)

instance monoidColumns :: Monoid Columns where
  mempty = Columns (empty 0 0)
