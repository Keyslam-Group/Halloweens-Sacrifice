local Concord = require("lib.concord")

return Concord.component(function(e, currentSpellIndex)
   e.currentSpellIndex = currentSpellIndex or 1
   e.spells = {
      require("src.classes.spells.spellBurst")(),
   }
end)
