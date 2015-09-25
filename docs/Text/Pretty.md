## Module Text.Pretty

This module defines a set of combinators for pretty printing text.

#### `Doc`

``` purescript
newtype Doc
```

A text document.

#### `width`

``` purescript
width :: Doc -> Int
```

Get the width of a document.

#### `height`

``` purescript
height :: Doc -> Int
```

Get the height of a document.

#### `render`

``` purescript
render :: Doc -> String
```

Render a document to a string.

#### `empty`

``` purescript
empty :: Int -> Int -> Doc
```

An empty document

#### `text`

``` purescript
text :: String -> Doc
```

Create a document from some text.

#### `beside`

``` purescript
beside :: Doc -> Doc -> Doc
```

Place one document beside another.

#### `atop`

``` purescript
atop :: Doc -> Doc -> Doc
```

Place one document on top of another.

#### `hcat`

``` purescript
hcat :: forall f. (Foldable f) => f Doc -> Doc
```

Place documents in columns

#### `vcat`

``` purescript
vcat :: forall f. (Foldable f) => f Doc -> Doc
```

Stack documents vertically

#### `Stack`

``` purescript
newtype Stack
  = Stack Doc
```

A wrapper for `Doc` with a `Monoid` instance which stacks documents vertically.

##### Instances
``` purescript
instance semigroupStack :: Semigroup Stack
instance monoidStack :: Monoid Stack
```

#### `stack`

``` purescript
stack :: Stack -> Doc
```

Turn a `Stack` back into a document.

#### `Columns`

``` purescript
newtype Columns
  = Columns Doc
```

A wrapper for `Doc` with a `Monoid` instance which stacks documents in columns.

##### Instances
``` purescript
instance semigroupColumns :: Semigroup Columns
instance monoidColumns :: Monoid Columns
```

#### `columns`

``` purescript
columns :: Columns -> Doc
```

Turn a collection of columns back into a document.


