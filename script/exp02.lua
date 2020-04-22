#! /usr/bin/env lua

-- https://twitter.com/schwarz_bach/status/1250708628895457281
-- https://www.iwanami.co.jp/kagaku/Kagaku_202005_Makino_preprint.pdf
-- https://twitter.com/ClusterJapan/status/1250364311144296454

--[[

S + I + R = N

dI/dt = beta S I - gamma I
      = beta (N - I - R) I - gamma I
dR/dt = gamma I

R0 = beta N / gamma
beta = gamma R0 / N

dI/dt = (gamma R0 / N) (N - I - R) I - gamma I
      = gamma (R0 (1 - I/N - R/N) I - I)
      = gamma I (R0 - 1 - R0 I / N - R0 R / N)
dR/dt = gamma I

]]

local function reproduction_number(t)
  if t <= 0 then
    return 2.5
  elseif t <= 7 then
    return 2.5 * 0.6
  elseif t <= 14 then
    return 2.5 * 0.4
  else
    return 2.5 * 0.2
  end
end

local function f(N, I, R, gamma, step)
  local a
  local b

  for t = -20, 70, step do
    local r = reproduction_number(t)

    local dR_dt = gamma * I
    local dI_dt = dR_dt * (r * (1 - I / N - R / N) - 1)

    I = I + dI_dt * step
    R = R + dR_dt * step

    if t == -5.5 then
      a = I
    elseif t == 0 then
      b = I
    end

    print(t, I, R)
  end

  -- local x = math.abs(a - 100) / 100
  -- local y = math.abs(b - 516) / 516
  -- local z = math.sqrt(x * x + y * y)
  -- return x, y, z
end

-- 1, 0.216216 (8/37)
-- 1, 32/149
-- 1, 256/1192
-- 1, x min => 256/1184
-- 1, y min => 256/1197

--[[
for i = 1, 10 do
  local I = i
  for j = 1000, 2000 do
    local gamma = 256/j
    local x, y, z = f(1000000, I, 0, gamma, 0.25)
    if x <= 1/10 and y <= 1/10 then
      print(I, j, x, y, z)
    end
  end
end
]]

f(10000000, 1, 0, 256/1197, 0.25)
-- f(1000000, 5, 0, 1/14, 0.25)
-- f(1000000, 5, 0, 1/28, 0.25)
