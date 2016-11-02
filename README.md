# Readme

Simple [token bucket](https://en.wikipedia.org/wiki/Token_bucket) implementation written in Lua. 

## Usage

````lua
require( './src/token_bucket' )

local bucket = TokenBucket( 10, 2 ); -- capacity, rate (tok/sec)
bucket:consume( 2 );
print( bucket:getTokenCount() ) -- 8
print( bucket:canConsume() ); -- true
````

## Run tests

````bash
lua ./tests/index.lua
````