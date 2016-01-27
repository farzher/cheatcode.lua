-- the_map is some confusing structure for optimized performance.
-- If your codes are {apple=a, abc=b}
-- the_map will look like {a={p={p={l={e=a}}}, b={c=b}}}
local the_map
local current_map


local Cheatcode = {}

-- Initilize the_map
function Cheatcode:__call(codes_map)
  the_map = {}

  for key, callback in pairs(codes_map) do
    local last_table = the_map

    -- This is a while loop so we can screw with i
    local i = 0 while true do i = i+1
      local char = key:sub(i,i)

      -- {up} sets char='up' and increments i to skip over these chars next time
      if char=='{' then
        char = ''
        while true do
          i = i+1
          local tmp_char = key:sub(i,i)
          if tmp_char=='}' or tmp_char==nil then break end
          char = char .. tmp_char
        end
      end

      -- This is the last char in our code
      if i>=#key then
        last_table[char] = callback
        break
      end

      -- Go deeper
      if last_table[char]==nil then last_table[char] = {} end
      last_table = last_table[char]
    end
  end

  current_map = the_map
end

-- Called everytime a key is pressed, gotta go fast!
-- No loops! Runs in constant time! O(1)
function Cheatcode.handle(char)
  if char=='space' then char = ' ' end

  -- What's next?
  local next_table = current_map[char]

  -- If its empty, reset to the_map
  -- If we were trying deeper than the_map, resend their input
  if next_table==nil then
    local should_retry = current_map~=the_map
    current_map = the_map
    if should_retry then Cheatcode.handle(char) end
    return
  end

  -- We found a function! execute it and reset to the_map
  if type(next_table)=='function' then
    next_table()
    current_map = the_map
    return
  end

  -- Goto next table
  current_map = next_table
end

return setmetatable(Cheatcode, Cheatcode)
