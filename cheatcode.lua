local the_table
local current_table


local Cheatcode = {}
function Cheatcode:__call(map)
  the_table = {}

  for key, callback in pairs(map) do
    local last_table = the_table
    local i = 0 while true do i = i+1
      local char = key:sub(i,i)
      if char=='{' then
        char = ''
        while true do
          i = i+1
          local tmp_char = key:sub(i,i)
          if tmp_char=='}' or tmp_char==nil then break end
          char = char .. tmp_char
        end
      end

      if i>=#key then
        last_table[char] = callback
        break

      else
        if last_table[char]==nil then last_table[char] = {} end
        last_table = last_table[char]
      end

    end
  end

  current_table = the_table
end
function Cheatcode.handle(char)
  if char=='space' then char = ' ' end

  -- What's next?
    local next_table = current_table[char]

  -- If its empty, reset to the_table
  -- If we were trying deeper than the_table, resend their input
    if next_table==nil then
      local should_retry = current_table~=the_table
      current_table = the_table
      if should_retry then Cheatcode.handle(char) end
      return
    end

  -- We found a function! execute it and reset to the_table
    if type(next_table)=='function' then
      next_table()
      current_table = the_table
      return
    end

  -- Goto next table
    current_table = next_table
end

setmetatable(Cheatcode, Cheatcode)
return Cheatcode
