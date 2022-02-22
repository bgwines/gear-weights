{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}

module Main
  ( main
  ) where

import qualified ClientTypes
import qualified ServerAPI

import Data.Aeson.TH ( defaultOptions )
import Data.Aeson.TypeScript.TH
    ( TypeScript(getTypeScriptDeclarations),
      formatTSDeclarations,
      deriveTypeScript )
import Data.Proxy ( Proxy(..) )
import Servant.JS ( writeJSForAPI, vanillaJS )

$(deriveTypeScript defaultOptions ''ClientTypes.GearKind)
$(deriveTypeScript defaultOptions ''ClientTypes.GearItem)

main :: IO ()
main = do
  putStrLn "Writing API to `static/api.js`..."
  writeJSForAPI ServerAPI.limitedApi vanillaJS "static/api.js"

  putStrLn "Writing TS types to `static/types.ts`..."
  let decl1 = formatTSDeclarations (getTypeScriptDeclarations (Proxy :: Proxy ClientTypes.GearKind))
  let decl2 = formatTSDeclarations (getTypeScriptDeclarations (Proxy :: Proxy ClientTypes.GearItem))
  let decls = decl1 ++ "\n\n" ++ decl2
  writeFile "static/types.ts" decls
