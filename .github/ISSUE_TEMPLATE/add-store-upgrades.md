---
name: Add Store Upgrades
about: Add a way for users to purchase upgrades that increase sales multiplier
title: Add Store Upgrades
labels: enhancement, help wanted, good first issue
assignees: ''

---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

Right after the day summary is cleared from the terminal, add a menu for the users to purchase upgrades. Make sure that they cannot buy an upgrade if they cannot afford it. For the time being, just add one upgrade option that increases the sales_mult variable by 1. Increase the cost of upgrades as time progresses.

Bonus:
Maybe have the menu only show up if the player can buy upgrades. If they cannot afford any, do not display it.

Add a way to save the purchased upgrades to the saves file. For the time being, since there is only one upgrade, the sales_mult variable (which is written to the save file) cant determine the upgrade level. Therefore, refer to the saves_mult variable to determine what players have already bought its not offered again.
