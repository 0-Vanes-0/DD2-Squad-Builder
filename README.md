# DD2 Squad Builder

Link to the page: http://0-vanes-0.github.io/DD2-Squad-Builder/

<img width="1849" height="928" alt="image" src="https://github.com/user-attachments/assets/8cac0bd7-0011-4716-b2da-46ff9f41b39b" />

[Report issue/suggestion](https://github.com/0-Vanes-0/DD2-Squad-Builder/issues)

Also feel free to fork and suggest a pull request if you'd like to make the utility better or to help with one of tasks from the roadmap.

## USAGE
• This web utility helps to build a squad for [Darkest Dungeon 2](https://store.steampowered.com/app/1940340/Darkest_Dungeon_II/) and to share it with anybody.
E.g. someone asks: 
> *"Recommend me a broken comp for K3"*

and instead of writing
> "PD Physician, Jester Wanderer, BH, Leper Monarch"
>
> and much text about skills

you can just send **squad code** that also includes chosen skills for each hero. The one who asked will just copy-paste it here to see heroes and skills (allow browser to see your clipboard data).

• How to form a squad?              
1. In Heroes tab, drag&drop a hero-path to one of rank slots. You should fill all 4 ranks.
2. In Skills tab, drag&drop skills to one of skill slots. You should fill all 5 slots (in case of Abomination - 9 slots).
3. Look at the summary below, copy or save your current squad (it will appear in Saved Squads tab).

• Skills order doesn't matter here. However, I recommend to sort them by upgrade (mastering) priority: skill on the top must be upgraded ASAP, skill on the bottom has the least importance.

• Having a hero with some skills applied, you may replace the hero with another path which preserves skills assigned to the hero. However, if you drag & drop a **different** hero — **assigned skills will be erased**!

• You can move heroes between ranks and even swap between each other.

• Once you have all 4 heroes with all skills set, click Save, give your squad a name and it will be saved in Saved Squads. **WARNING!** The squads are saved in **browser's cookies** (you shouold allow them); if you clean them — all squads data will be erased as well!

• While you're creating a squad, the text below is being updated. It makes a summary of your squad, highlighting its advantages and other properties. Revealing all disadvantages of the squad is your own responsibility.

• You also may find useful to see [DD2's wiki website](https://darkestdungeon.wiki.gg/wiki/Heroes_(Darkest_Dungeon_II)), just if you need additional information or strategies.

• If you've found some bug or if you want to suggest some functional/visual changes — click [Report issue/suggestion](https://github.com/0-Vanes-0/DD2-Squad-Builder/issues).

## ROADMAP (in priority order)

- [x] ~~Create drag & drop system for heroes-paths and skills~~
- [x] ~~Create automatic properties summary of squad~~
- [x] ~~Do the same for each hero and add switch button~~
- [ ] Show descriptions of heroes-paths
- [ ] Show descriptions of skills
- [ ] Hook localizations from the game
- [ ] Paste squad to game????? in HeroSelect scene
- [ ] Visual improvements of UI

## CREDITS

RedHook — Darkest Dungeon 2 itself, its images and mechanics.

Catabbro (me) — DD2 Squad Builder developer.

[darkestdungeon.wiki.gg](https://darkestdungeon.wiki.gg/wiki/Heroes_(Darkest_Dungeon_II)) — all the data about heroes, all pngs used in this project

GitHub — repository storage and free public hosting of the web page.

Powered by [Godot Engine](https://godotengine.org/), a free open-source engine for games and applications.
