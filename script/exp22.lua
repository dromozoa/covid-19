#! /usr/bin/env lua

local function p(t, v)
  -- print(t, v)
end

local function p2(t, v)
  -- print(t, v)
end

local function p3(t, v)
  print(v)
end


local function pweibull(a, b, x)
  return 1 - math.exp(- (x/b) ^ a)
end

local incubation = {
[0] = 0;
0.006757188;
0.08290307;
0.1574671;
0.1674516;
0.1438761;
0.1128469;
0.08490792;
0.06271797;
0.04601597;
0.03374603;
0.02482204;
0.0183479;
0.01364334;
0.01021094;
0.007693292;
0.005835361;
0.004455439;
0.003423805;
0.002647494;
0.002059542;
0.001611443;
0.001267844;
0.001002822;
0.0007972436;
0.0006369047;
0.0005111925;
0.0004121316;
0.0003336938;
}

-- 発症日から診断日
local onsettolabconf = {
[0] = 0;
0.02345696;
0.05282007;
0.0721969;
0.08448698;
0.09074771;
0.09193884;
0.08907535;
0.08319566;
0.0752958;
0.06626916;
0.05686459;
0.04766585;
0.03909009;
0.03140133;
0.02473341;
0.01911769;
0.01451138;
0.01082347;
0.007936675;
0.005724349;
0.004062637;
0.002838208;
0.001952447;
0.001322952;
0.0008831976;
0.000581073;
0.0003768457;
0.0002409629;
}

local generation = {}
local scale = 2.345
local shape = 5.452

for t = 1, 28 do
  local v = pweibull(scale, shape, t) - pweibull(scale, shape, t - 1)
  generation[t] = v
end

local I_0 = 12.369648219600455
local data = {}

for t = 0, 20 do
  local x = I_0 * math.exp(0.186929153188229 * t)
  data[t] = x
  p(t, x)
end

for t = 21, 80 do
  local v = data[t]
  local sum = 0
  for tau = 1, math.min(t, 28) do
    local u = data[t - tau]
    local g = generation[tau]
    sum = sum + u * g
  end
  local x = 0.875 * sum
  data[t] = x
  p(t, x)
end

local data2 = {}

for t = 0, 80 do
  local v = 0
  for tau = 0, math.min(t, 28) do
    v = v + data[t - tau] * incubation[tau]
  end
  data2[t] = v
  p2(t, v)
end

local data3 = {}

for t = 0, 80 do
  local v = 0
  for tau = 0, math.min(t, 28) do
    v = v + data2[t - tau] * onsettolabconf[tau]
  end
  data3[t] = v
  p3(t, v)
end
