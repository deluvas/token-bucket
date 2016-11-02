
require( 'src/token_bucket' )
local lu = require( './tests/lib/luaunit' )

function test_01_consume()
  local bucket = TokenBucket( 10 );
  lu.assertEquals( bucket:consume( 9 ), true );
  lu.assertEquals( bucket:getTokenCount(), 1 );
  lu.assertEquals( bucket:consume(), true );
  lu.assertEquals( bucket:consume(), false );
  lu.assertEquals( bucket:getTokenCount(), 0 );
end

function test_02_check_replenish()
  local bucket = TokenBucket( 10, 2 );
  lu.assertEquals( bucket:consume( 10 ), true );
  lu.assertEquals( bucket:getTokenCount(), 0 );
  sleep( 0.25 );
  lu.assertEquals( bucket:getTokenCount(), 0 );
  sleep( 0.25 );
  lu.assertEquals( bucket:getTokenCount(), 1 );
end

function test_03_test_constructor_params()
  local bucket = TokenBucket( 10, 3 )
  lu.assertEquals( bucket:getRate(), 1 / 3 );
  lu.assertEquals( bucket:getTokenCount(), 10 );
end


--
-- helper
--
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end