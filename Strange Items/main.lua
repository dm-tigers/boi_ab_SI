local strange = RegisterMod("Strange Items", 1)

--variable declarations
local game = Game();
local player;
local room;
local level;
local resAllowed = false;
local modItems = {
	AMULET = Isaac.GetItemIdByName("Strange Amulet"),
	CLOAK = Isaac.GetItemIdByName("Strange Cloak")
}

local hasItems = {
	Amulet = false,
	Cloak = false;
}
local numStrangeItems = 0;
-----------------------------------

function strange:onUpdate(player, room)
	game = Game();
	player = game:GetPlayer(0);
	room = game:GetRoom();
	level = game:GetLevel();
	if player:IsDead() and player:HasCollectible(modItems.AMULET) and resAllowed == true and room.GetType() == RoomType.ROOM_BOSS then
		player:Revive();
		game:ChangeRoom(level:GetPreviousRoomIndex())
		if player:GetMaxHearts() == 0 then
			player:AddSoulHearts(6);
		else  
			player:AddHearts(player:GetMaxHearts());
		end
		
	--resAllowed = false;
	end
	end

	function strange:onCache(player,myCacheFlag)
	if myCacheFlag == CacheFlag.CACHE_FLYING then
		if player:HasCollectible(modItems.CLOAK) then
			player.CanFly = true;
			hasItems.CLOAK = true;
		end
	end
	if myCacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(modItems.AMULET) then
			player.Damage = player.Damage + 1.69;
			--player.Luck = player.Luck + 2;
			hasItems.AMULET = true;
			
		end
	end
end

function strange:onNewLevel()
	game = Game();
	level = Game():GetLevel();
	if level >= LevelStage.STAGE6 then
		resAllowed = true;
	end
end




strange:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, strange.Init)
strange:AddCallback(ModCallbacks.MC_POST_UPDATE, strange.onUpdate, EntityType.ENTITY_PLAYER)
strange:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, strange.onCache)
strange:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, strange.onNewLevel)

--strange:AddCallback(ModCallbacks.MC_POST_UPDATE, strange.onFirstFrame)
--strange:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, strange.onDamage,EntityType.ENTITY_PLAYER)
