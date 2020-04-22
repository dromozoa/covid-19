#! /usr/bin/env lua

-- https://twitter.com/schwarz_bach/status/1250708628895457281
-- https://www.iwanami.co.jp/kagaku/Kagaku_202005_Makino_preprint.pdf

-- 全人口は100万人
-- R=1のときにグラフがたいらになる
local N = 1000000
local I = 10 -- infected

local function step(x, y, r, t)
  local dx_dt = r * (1 - x - y) * x - x
  local dy_dt = x

  x = x + dx_dt * t
  y = y + dy_dt * t

  return x, y, dx_dt, dy_dt
end

local X = I / N
local Y = 0
local R0 = 2.5

-- 256tickが1週間
local tick = 256

local M = tick * 16
local T1 = tick * 5
local T2 = T1 + tick
local T3 = T2 + tick

-- \gamma = 2週間
local t = 1 / (tick * 2)
local x1, y1, r1 = X, Y, R0
local x2, y2, r2 = X, Y, R0
local x3, y3, r3 = X, Y, R0
local x4, y4, r4 = X, Y, R0

for i = 1, M do
  if i < T1 then
    r1 = R0
    r2 = R0
    r3 = R0
    r4 = R0
  elseif i < T2 then
    r1 = R0 * 0.2
    r2 = R0 * 0.3
    r3 = R0 * 0.6
    r4 = R0 * 0.8
  elseif i < T3 then
    r1 = R0 * 0.2
    r2 = R0 * 0.3
    r3 = R0 * 0.4
    r4 = R0 * 0.8
  else
    r1 = R0 * 0.2
    r2 = R0 * 0.3
    r3 = R0 * 0.2
    r4 = R0 * 0.8
  end

  local dx1, dx2, dx3
  local dy1, dy2, dy3

  x1, y1, dx1, dy1 = step(x1, y1, r1, t)
  x2, y2, dx2, dy2 = step(x2, y2, r2, t)
  x3, y3, dx3, dy3 = step(x3, y3, r3, t)
  x4, y4, dx4, dy4 = step(x4, y4, r4, t)

  local d1 = dx1 + dy1
  local d2 = dx2 + dy2
  local d3 = dx3 + dy3
  local d4 = dx4 + dy4

  print(x4 * N, x3 * N, x2 * N, x1 * N)
end
