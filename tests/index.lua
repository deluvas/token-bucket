
local lu = require( './tests/lib/luaunit' )
require( './tests/token_bucket_tests' )

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")

os.exit( runner:runSuite() )