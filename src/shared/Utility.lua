local Utility = {}

local validCharacters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0","<",">","?","@","{","}","[","]","!","(",")","=","+","~","#"}
function Utility.generateUID(length)
	local UID = ""
	local length = length or 8
	for i=0, length, 1 do
		local char = validCharacters[math.random(#validCharacters)]
		UID = UID..char
	end
	return UID
end

local numToWordDict = {
	["1"] = "one",
	["2"] = "two",
	["3"] = "three",
	["4"] = "four",
	["5"] = "five",
	["6"] = "six",
	["7"] = "seven",
	["8"] = "eight",
	["9"] = "nine",
	["0"] = "zero"
}
function Utility.numToWord(num, shouldCapitalize)
	if num:IsA(num) then
		num = tostring(num)
	end
	local newString = numToWordDict[num]
	if shouldCapitalize then
		Utility.capitalize(newString)
	end
	return newString
end

function Utility.capitalize(text)
	return text:gsub("^%1", string.upper)
end 

function Utility.convertToPastTense(word)
	if word:sub(#word, #word) == "e" then
		return word.."d"
	end
	return word.."ed"
end

return Utility
