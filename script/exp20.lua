#! /usr/bin/env lua

local incubation_data = {
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
local onsettolabconf_data = {
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

local data = {}

for t = 0, #incubation_data do
  for u = 0, #onsettolabconf_data do
    local x = t + u
    local y = incubation_data[t] * onsettolabconf_data[u]
    data[x] = (data[x] or 0) + y
  end
end

for t = 1, #data do
  print(t, data[t])
end

