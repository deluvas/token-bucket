local bucket = {}
local bucket_mt = { __index = bucket }

-- Instanciate a new token bucket
-- @param maxCapacity Maximum bucket capacity
-- @param replenishRate Default 1. Specify the token replenish rate in tokens/second
function TokenBucket( maxCapacity, replenishRate )
  if ( maxCapacity == nil ) then
    error( "maxCapacity cannot be nil" )
  end
  replenishRate = replenishRate or 1 
  
  local self = {
    maxCapacity = maxCapacity,
    capacity = maxCapacity,
    rate = 1 / replenishRate, -- 1 token / x sec
    lastReplenishTime = os.clock()
  }
  return setmetatable( self, bucket_mt )
end

-- Consumes n tokens from the bucket.
-- @param amount Amount of tokens to consume. Default 1.
-- @return true if the bucket has enough tokens or false otherwise
function bucket:consume( amount )
  amount = amount or 1;
  if ( amount < 0 ) then
    error( "amount cannot be negative" );
  end

  -- the amount to consume 
  -- is greater than the amount of tokens in the bucket
  if ( not self:canConsume( amount ) ) then
    return false; -- discard
  else
    self.capacity = self.capacity - amount;
    return true; -- allow
  end 
end

local function calculateCapacity( self )
  -- time difference in seconds (frac)
  -- since last consumption
  local timediff = os.clock() - ( self.lastReplenishTime )

  -- add tokens to the bucket proportional to the time difference
  -- since last replenish
  if ( timediff > 0 ) then
    local fractTokens = timediff / self.rate;
    self.capacity = math.min( self.maxCapacity, self.capacity + fractTokens );
    self.lastReplenishTime = os.clock();

    -- print( "adding "..fractTokens.." to bucket" );
    -- print( "capacity before: "..self.capacity.."diff: "..timediff )
  end

  return self.capacity;
end 

-- Calculates and returns the current capacity (in tokens) of the bucket.
-- @return int Nr of tokens in bucket
function bucket:getTokenCount()
  return math.floor( calculateCapacity( self ) )
end

-- Return whether the bucket can consume the amount of
-- given tokens
-- @return bool true/false
function bucket:canConsume( amount )
  return self:getTokenCount() >= amount
end

-- Rate in seconds (frac) at which the bucket replenishes
-- @return float
function bucket:getRate()
  return self.rate;
end