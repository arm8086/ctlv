local BOOTPROP_VER = "0.1.1"

local cout = Helix_ParseArgs(cout, function(arg)
  return type(arg) == "string" and arg:gsub("${(.-)}", getfenv()[arg:match("${(.-)}")]) or arg
end)

cout("Helix version ${BOOTPROP_VER} loaded.")
