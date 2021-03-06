-- --------
-- Entrance
-- --------
-- UPDATE `areatrigger_teleport` SET `required_level` = '80' WHERE `areatrigger_teleport`.`id` =5670;

UPDATE `creature` SET `spawntimesecs` = 7200 WHERE `map` = 631 AND (`spawntimesecs` BETWEEN 200 AND 7100 );

-- Sindragosa icewall

UPDATE `gameobject_template` SET `faction` = '0' WHERE `entry` = 201385;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`)
VALUES
	(null, 201385, 631, 15, 1, 4320.72, 2487.47, 211.202, 0.1399, 0, 0, 0.0698929, 0.997554, 25, 255, 0);

DELETE FROM `gameobject` WHERE `guid` = 913334;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`) VALUES
(913334, 202244, 631, 3, 1, -209.5, 2211.91, 199.97, 3.07661, 0, 0, 0.999472, 0.0324833, 0, 0, 1);

UPDATE `gameobject_template` SET `flags` = 0, `ScriptName` = 'go_icecrown_teleporter' WHERE `entry`  IN (202242,202243,202244,202245,202235,202223,202246);
UPDATE `gameobject` SET `phaseMask` = 1 WHERE `id`  IN (202242,202243,202244,202245,202235,202223,202246);
DELETE FROM `areatrigger_teleport` WHERE `id` = 5718 AND `target_map` = 631;

DELETE FROM `creature` WHERE `id` = 99322;
DELETE FROM `creature_template` WHERE `entry` = 99322;
DELETE FROM `locales_npc_text` WHERE `entry` = 99322;
DELETE FROM `npc_text` WHERE `ID` = 99322;
DELETE FROM `locales_npc_text` WHERE `entry` = 99323;
DELETE FROM `npc_text` WHERE `ID` = 99323;
DELETE FROM `gameobject` WHERE `guid` IN (913334);

UPDATE `instance_template` SET `ScriptName`='instance_icecrown_citadel' WHERE `map`=631;

-- fix for ytdb data on frostwing door/puddle

DELETE FROM `gameobject` WHERE `id`=201919;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(7807, 201919, 631, 1, 128, 4356.52, 2651.74, 351.1, 1.61378, 0, 0, 0.722138, 0.691749, 25, 255, 1);

-- Icecrown buff
DELETE FROM `spell_area` WHERE `spell` IN
(73762, 73824, 73825, 73826, 73827, 73828, -- Alliance
73816, 73818, 73819, 73820, 73821, 73822);
-- +5%
-- INSERT INTO `spell_area` (`spell`, `area`, `racemask`, `gender`, `autocast`) VALUES
-- (73762, 4812, 1101, 2, 1), -- Alliance
-- (73816, 4812, 690, 2, 1); -- Horde
-- +10%
-- INSERT INTO `spell_area` (`spell`, `area`, `racemask`, `gender`, `autocast`) VALUES
-- (73824, 4812, 1101, 2, 1), -- Alliance
-- (73818, 4812, 690, 2, 1); -- Horde
-- +15%
-- INSERT INTO `spell_area` (`spell`, `area`, `racemask`, `gender`, `autocast`) VALUES
-- (73825, 4812, 1101, 2, 1), -- Alliance
-- (73819, 4812, 690, 2, 1); -- Horde
-- +20%
-- INSERT INTO `spell_area` (`spell`, `area`, `racemask`, `gender`, `autocast`) VALUES
-- (73826, 4812, 1101, 2, 1), -- Alliance
-- (73820, 4812, 690, 2, 1); -- Horde
-- +25%
-- INSERT INTO `spell_area` (`spell`, `area`, `racemask`, `gender`, `autocast`) VALUES
-- (73827, 4812, 1101, 2, 1), -- Alliance
-- (73821, 4812, 690, 2, 1); -- Horde
-- +30%
-- INSERT INTO `spell_area` (`spell`, `area`, `racemask`, `gender`, `autocast`) VALUES
-- (73828, 4812, 1101, 2, 1), -- Alliance
-- (73822, 4812, 690, 2, 1); -- Horde

-- --------
-- Saurfang
-- --------

UPDATE `creature_template` SET `vehicle_id` = 639, `AIName`='', `PowerType` = 3, `ScriptName`='boss_deathbringer_saurfang' WHERE `entry`=37813;
UPDATE `creature_template` SET `vehicle_id` = 639, `AIName`='', `PowerType` = 3 WHERE `entry` IN (38402,38582,38583);
UPDATE `creature` SET `position_x` = -476.621,`position_y` = 2211.11,`position_z` = 541.197, `spawntimesecs` = 604800 WHERE `id` = 37813;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (37813, 38402, 38582, 38583);
UPDATE `creature_template` SET `ScriptName`='mob_blood_beast', `AIName`='' WHERE `entry`= 38508;
DELETE FROM `spell_script_target` WHERE `entry` IN (72260, 72202, 72278,72279,72280);
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES
('72260', '1', '37813'),
('72278', '1', '37813'),
('72279', '1', '37813'),
('72280', '1', '37813'),
('72202', '1', '37813');

DELETE FROM `spell_proc_event` WHERE entry IN (72178, 72256);
INSERT INTO `spell_proc_event` VALUES
(72256, 0x7F,  0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0.000000, 0.000000, 0),
(72178, 0x7F,  0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0.000000, 0.000000, 0);

-- Rune of Blood (Saurfang)
DELETE FROM `spell_proc_event` WHERE `entry` = 72408;
INSERT INTO `spell_proc_event` () VALUES
(72408, 0x00, 0x00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x0000000, 0x00000000, 0x00000000, 0x00000014, 0x00000003, 0, 0, 0);

-- Blood Link (Saurfang, Blood Beast)
DELETE FROM `spell_proc_event` WHERE `entry` = 72176;
INSERT INTO `spell_proc_event` () VALUES
(72176, 0x00, 0x00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x0000000, 0x00000000, 0x00000000, 0x00000014, 0x00000003, 0, 0, 0);

-- Scent of Blood
DELETE FROM `spell_script_target` WHERE `entry` = 72771;
INSERT INTO `spell_script_target` VALUES (72771, 1, 38508);

-- update attack speed for Saurfang
UPDATE `creature_template` SET baseattacktime = 1000 WHERE `entry` IN (37813, 38402, 38582, 38583);


-- ------------
-- Deathwhisper
-- ------------
DELETE FROM `creature_template` WHERE `entry` IN ('37890', '37949', '38009','38010', '38135');
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `modelid_1`, `modelid_2`, `modelid_3`, `modelid_4`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `minhealth`, `maxhealth`, `PowerType`, `minmana`, `maxmana`, `armor`, `faction_A`, `faction_H`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `mindmg`, `maxdmg`, `dmgschool`, `attackpower`, `dmg_multiplier`, `baseattacktime`, `rangeattacktime`, `unit_class`, `unit_flags`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `minrangedmg`, `maxrangedmg`, `rangedattackpower`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `unk16`, `unk17`, `RacialLeader`, `questItem1`, `questItem2`, `questItem3`, `questItem4`, `questItem5`, `questItem6`, `movementId`, `RegenHealth`, `vehicle_id`, `equipment_id`, `trainer_id`, `vendor_id`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`)
VALUES
('37890','38393','38628','38629','0','0','30967','0','0','0','Cult Fanatic','Cult of the Damned','','0','82','82','134810','134810','0','0','0','10328','21','21','0','1','1.14286','1','1','452','678','0','169','37.5','2000','2000','1','32768','0','0','0','0','0','0','362','542','135','7','8','0','0','0','0','0','0','0','0','0','71236','72495','70900','70659','0','0','0','0','0','0','0','','0','3','10','1','0','0','0','0','0','0','0','0','1','0','2065','0','0','0','0','mob_cult_fanatic'), 
('37949','38394','38625','38626','0','0','30965','0','0','0','Cult Adherent','Cult of the Damned','','0','82','82','107840','107840','0','183200','183200','8262','21','21','0','1','1.14286','1','1','330','495','0','124','16.5','2000','2000','8','0','0','0','0','0','0','0','264','396','99','7','8','0','0','0','0','0','0','0','0','0','71237','70901','70903','72498','0','0','0','0','0','0','0','','0','3','10','10','0','0','0','0','0','0','0','0','1','0','2067','0','0','0','0','mob_cult_adherent'),
('38009','38398','38630','38631','0','0','30968','0','0','0','Reanimated Fanatic','Cult of the Damned','','0','82','82','134810','134810','0','0','0','10328','21','21','0','1','1.14286','1','1','420','630','0','157','37.5','2000','2000','1','0','0','0','0','0','0','0','336','504','126','6','1032','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','','0','3','10','1','0','0','0','0','0','0','0','0','1','0','2065','0','0','0','0','mob_cult_fanatic'),
('38010','38397','39000','39001','0','0','30966','0','0','0','Reanimated Adherent','Cult of the Damned','','0','82','82','107840','107840','0','183200','183200','8262','21','21','0','1','1.14286','1','1','391','585','0','146','16.5','2000','2000','2','0','0','0','0','0','0','0','313','468','117','6','1032','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','','0','3','10','10','0','0','0','0','0','0','0','0','1','0','0','0','0','0','0','mob_cult_adherent'),
('38135','38395','38634','38635','0','0','22124','0','0','0','Deformed Fanatic','Cult of the Damned','','0','82','82','134810','134810','0','0','0','10328','21','21','0','0.5','1.14286','1','1','420','630','0','157','37.5','2000','2000','1','0','0','0','0','0','0','0','336','504','126','6','8','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','','0','3','10','1','0','0','0','0','0','0','0','84','1','0','2065','0','0','0','0','mob_cult_fanatic');

UPDATE `creature_template` SET `minhealth` = '202215', `maxhealth` = '202215' WHERE `entry` IN ('38398','38631','38395','38635');
UPDATE `creature_template` SET `minhealth` = '215680', `maxhealth` = '215680', `minmana` = '183200', `maxmana` = '183200' WHERE `entry` IN ('38397','39001');

UPDATE `creature_template` SET `ScriptName`='boss_lady_deathwhisper', `AIName`='' WHERE `entry`=36855;
UPDATE `creature_template` SET `mechanic_immune_mask` = '634339327' WHERE `entry`  IN (36855, 38106, 38296, 38297);
UPDATE `creature_template` SET `mechanic_immune_mask` = '1' WHERE `entry`  IN ('37890','38393','38628','38629','37949','38394','38625','38626','38009','38398','38630','38631','38010','38397','39000','39001','38135','38395','38634','38635');
UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 256 WHERE `entry` IN (38296, 38297); -- can't taunt on heroic mode
UPDATE `creature_template` SET `faction_A`=14, `faction_H`=14,`ScriptName`='mob_vengeful_shade', `AIName`='' WHERE `entry`= 38222;
UPDATE `creature_template` SET `ScriptName`='mob_cult_adherent', `AIName`='' WHERE `entry`= 37949;
UPDATE `creature_template` SET `ScriptName`='mob_cult_fanatic', `AIName`='' WHERE `entry`= 37890;

-- Vengeful Blast aura for shades
DELETE FROM `creature_template_addon` WHERE `entry` = 38222;
INSERT INTO `creature_template_addon` (`entry`, `auras`) VALUES (38222, "71494");

-- ---------
-- Marrowgar
-- ---------

UPDATE `creature_template` SET `ScriptName`='boss_lord_marrowgar', `AIName`='' WHERE `entry`= 36612;
UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201910,201911);
UPDATE `gameobject` SET `state` = '1' WHERE `guid` IN (72526,72525);
UPDATE `creature_template` SET `ScriptName`='mob_coldflame', `minlevel` = 82, `maxlevel` = 82, `modelid_1` = 11686, `modelid_2` = 11686, `modelid_3` = 11686, `modelid_4` = 11686, `faction_A` = 14, `faction_H` = 14, `AIName`=''  WHERE `entry`= 36672;
UPDATE `creature_template` SET `ScriptName`='mob_bone_spike', `AIName`='' WHERE `entry`= 38711;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (36612, 37957, 37958, 37959);

-- --------------
-- Gunship battle
-- --------------

UPDATE `creature_template` SET `ScriptName`='mob_spire_frostwyrm', `AIName`='' WHERE `entry`= 37230;
DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 37230;
UPDATE `creature_template` SET `ScriptName`='mob_frost_giant', `AIName`='' WHERE `entry` IN (38490, 38494) ;
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (38490, 38494);
DELETE FROM `creature` WHERE `guid` = 94094 AND `id` = 38490;

-- -------------------------
-- Gunship armory (override)
-- -------------------------
DELETE FROM `gameobject` WHERE `id` IN (201872,201873,201874,201875,202177,202178,202179,202180);
UPDATE `gameobject_template` SET `flags` = 0 WHERE `gameobject_template`.`entry` IN (201872,201873,201874,201875,202177,202178,202179,202180);
INSERT INTO `gameobject` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`) VALUES
(972541, 201872, 631, 1, 1, -428.141, 2421.34, 191.233, 3.10389, 0, 0, 0.999822, 0.0188489, -604800, 100, 1),
(972543, 201873, 631, 2, 1, -428.141, 2421.34, 191.233, 3.10389, 0, 0, 0.999822, 0.0188489, -604800, 100, 1),
(972545, 201874, 631, 4, 1, -428.141, 2421.34, 191.233, 3.10389, 0, 0, 0.999822, 0.0188489, -604800, 100, 1),
(972547, 201875, 631, 8, 1, -428.141, 2421.34, 191.233, 3.10389, 0, 0, 0.999822, 0.0188489, -604800, 100, 1),
(972551, 202177, 631, 1, 1, -447.493, 2003.5, 191.235, 0.153939, 0, 0, 0.0768933, 0.997039, -604800, 100, 1),
(972553, 202178, 631, 2, 1, -447.493, 2003.5, 191.235, 0.153939, 0, 0, 0.0768933, 0.997039, -604800, 100, 1),
(972555, 202179, 631, 4, 1, -447.493, 2003.5, 191.235, 0.153939, 0, 0, 0.0768933, 0.997039, -604800, 100, 1),
(972557, 202180, 631, 8, 1, -447.493, 2003.5, 191.235, 0.153939, 0, 0, 0.0768933, 0.997039, -604800, 100, 1);

-- -----------
-- Plague wing
-- -----------
-- Precious & Stinky scripts

UPDATE `creature_template` SET `ScriptName` = 'mob_stinky', `mechanic_immune_mask` = '667893759' WHERE `entry` = 37025;
UPDATE `creature_template` SET `ScriptName` = 'mob_precious', `mechanic_immune_mask` = '667893759' WHERE `entry` = 37217;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (37025, 38064, 37217, 38103);

-- -------
-- Rotface
-- -------

UPDATE `creature_template` SET `ScriptName`='boss_rotface', `AIName`=''  WHERE `entry`= 36627;
UPDATE `gameobject_template` SET `faction` = '114' WHERE `gameobject_template`.`entry` IN (201370);
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (36627, 38390, 38549, 38550);
UPDATE `gameobject` SET `state` = '0' WHERE `id` IN (201370);
UPDATE `creature_template` SET `ScriptName`='mob_little_ooze', `AIName`='' WHERE `entry`= 36897;
UPDATE `creature_template` SET `ScriptName`='mob_big_ooze', `AIName`='' WHERE `entry`= 36899;
UPDATE `creature_template` SET `minlevel` = 80, `maxlevel` = 80, `AIName` ='', `faction_A`= 14, `faction_H` = 14, `ScriptName`='mob_rotface_ooze_dummy', `AIName`='', unit_flags = 524288, flags_extra = flags_extra | 2 WHERE `entry` IN (37013, 37986, 38107, 38548);
UPDATE `creature_template` SET `minlevel` = 80, `maxlevel` = 80, `AIName` ='', `faction_A`= 2212, `faction_H` = 2212, `ScriptName`='mob_sticky_ooze', `AIName`='' WHERE `entry`= 37006;
UPDATE `creature_template` SET `minlevel` = 80, `maxlevel` = 80, `AIName` ='', `faction_A`= 2212, `faction_H` = 2212, `ScriptName`='mob_ooze_explode_stalker', `AIName`='' WHERE `entry` = 38107;

DELETE FROM `spell_script_target` WHERE `entry` IN (69508, 70881, 69782, 69783, 70079);
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES
('69508', '1', '37986'), -- Slime Spray
('70881', '1', '37986'), -- Slime Spray dummy
('69783', '1', '37013'), -- Ooze Flood
('70079', '1', '36627'); -- Ooze Flood remove

-- fix rotface combat reach was set to 40 he could hit u from across the room
DELETE FROM `creature_model_info` WHERE (`modelid`=31005);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (31005, 5, 4, 2, 0, 0);

-- fix stinky modelID info
DELETE FROM `creature_model_info` WHERE (`modelid`=30483);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (30483, 5, 1, 2, 0, 0);

-- fix flags of Puddle Stalkers
UPDATE `creature_template` SET `unit_flags` = 524288 WHERE `entry` = 37013;

-- fix visibility of stalkers
DELETE FROM `creature_template` WHERE `entry` = '37006';
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `modelid_1`, `modelid_2`, `modelid_3`, `modelid_4`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `minhealth`, `maxhealth`, `PowerType`, `minmana`, `maxmana`, `armor`, `faction_A`, `faction_H`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `mindmg`, `maxdmg`, `dmgschool`, `attackpower`, `dmg_multiplier`, `baseattacktime`, `rangeattacktime`, `unit_class`, `unit_flags`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `minrangedmg`, `maxrangedmg`, `rangedattackpower`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `unk16`, `unk17`, `RacialLeader`, `questItem1`, `questItem2`, `questItem3`, `questItem4`, `questItem5`, `questItem6`, `movementId`, `RegenHealth`, `vehicle_id`, `equipment_id`, `trainer_id`, `vendor_id`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`) VALUES('37006','0','0','0','0','0','1126','11686','0','0','Sticky Ooze',NULL,NULL,'0','80','80','1','1','0','0','0','9730','2212','2212','0','1','1.14286','1','0','420','630','0','157','1','2000','2000','1','33554434','0','0','0'
,'0','0','0','336','504','126','10','0','0','0','0','0','0','0','0','0','0','69776','0','0','0','0','0','0','0','0','0','0','','0','3','2','1','0','0','0','0','0'
,'0','0','0','1','0','0','0','0','0','0','mob_sticky_ooze');

DELETE FROM `creature_template` WHERE `entry` = '37013';
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `modelid_1`, `modelid_2`, `modelid_3`, `modelid_4`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `minhealth`, `maxhealth`, `PowerType`, `minmana`, `maxmana`, `armor`, `faction_A`, `faction_H`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `mindmg`, `maxdmg`, `dmgschool`, `attackpower`, `dmg_multiplier`, `baseattacktime`, `rangeattacktime`, `unit_class`, `unit_flags`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `minrangedmg`, `maxrangedmg`, `rangedattackpower`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `unk16`, `unk17`, `RacialLeader`, `questItem1`, `questItem2`, `questItem3`, `questItem4`, `questItem5`, `questItem6`, `movementId`, `RegenHealth`, `vehicle_id`, `equipment_id`, `trainer_id`, `vendor_id`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`)
VALUES
('37013','0','0','0','0','0','1126','11686','0','0','Puddle Stalker',NULL,NULL,'0','80','80','25200','25200','0','0','0','9730','14','14','0','1','1.14286','1','0','420','630','0','157','1','2000','2000','1','34078722','0','0','0',
'0','0','0','336','504','126','10','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','','0','4','2','1','0','0','0','0','0','0','0','0',
'1','0','0','0','0','0','2','mob_rotface_ooze_dummy');

-- ---------
-- Festergut
-- ---------

UPDATE `creature_template` SET `ScriptName`='boss_festergut', `AIName`=''  WHERE `entry`= 36626;
UPDATE `gameobject_template` SET `faction` = '114' WHERE `gameobject_template`.`entry` IN (201371);
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (36626, 37504, 37505, 37506);
UPDATE `gameobject` SET `state` = '0' WHERE `id` IN (201371);
UPDATE `creature_template` SET `ScriptName`='mob_vile_gas_malleable_goo', `AIName`='', `flags_extra` = `flags_extra` | 2 | 128  WHERE `entry` IN (38548, 38556);
-- orange gas stalker
UPDATE `creature_template` SET `faction_A` = 2212, `faction_H` = 2212,  `ScriptName`='', `AIName`='' WHERE `entry`= 36659;
DELETE FROM `spell_script_target` WHERE `entry` IN (69157, 69162, 69164);
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES
(69157, 1, 36659),
(69162, 1, 36659),
(69164, 1, 36659);

-- original auras from YTDB
DELETE FROM `creature_template_addon` WHERE `entry` = 36659;
-- INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `bytes2`, `emote`, `moveflags`, `auras`) VALUES
-- (36659, 0, 0, 1, 0, 0, '69126 69152 69154');

-- gas from valves
UPDATE `creature` SET `spawnMask` = 15, `modelid` = 11686, `spawntimesecs` = 300 WHERE `id`=37013;
DELETE FROM `spell_script_target` WHERE `entry` = 69125;
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES (69125, 1, 37013);

-- proper way for Gastric Bloat, but cooldowns for creatures not implemented yet
-- -- Gastric Bloat
DELETE FROM `spell_proc_event` WHERE `entry` = 72214;
-- INSERT INTO `spell_proc_event` VALUES
-- (72214, 0x00,  0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0.000000, 0.000000, 8);

-- fixed modelID info
DELETE FROM `creature_model_info` WHERE (`modelid`=31006);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (31006, 5, 4, 2, 0, 0);

-- fix peroicus modelID info
DELETE FROM `creature_model_info` WHERE (`modelid`=30483);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (30483, 5, 1, 2, 0, 0);

-- make triggers not visible
UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 33554432 | 2 WHERE entry IN (37013, 37986, 38107, 38548, 37006, 38107, 38548, 38556, 36659);

-- -------------------
-- Professor putricide
-- -------------------

UPDATE `creature_template` SET `ScriptName`='boss_professor_putricide', `AIName`='' WHERE `entry`= 36678;
UPDATE `creature_template` SET `PowerType` = 0, `vehicle_id` = 587 WHERE `entry` IN (36678, 38431, 38585, 38586);
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (36678, 38431, 38585, 38586);
UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201372,201614,201613, 201612);
UPDATE `gameobject` SET `state` = '1' WHERE `id` IN (201612,201614,201613);
UPDATE `gameobject` SET `state` = '0' WHERE `id` IN (201372);
UPDATE `creature_template` SET `ScriptName`='mob_icc_gas_cloud', `AIName`='' WHERE `entry`= 37562;
UPDATE `creature_template` SET `ScriptName`='mob_icc_volatile_ooze', `AIName`='' WHERE `entry`= 37697;
UPDATE `creature_template` SET `ScriptName`='mob_choking_gas_bomb', `AIName`='',`minlevel` = 82, `maxlevel` = 82, `faction_A` = 14, `faction_H` = 14, `scale` = 0.5 WHERE `entry`= 38159;
UPDATE `creature_template` SET `ScriptName`='mob_ooze_puddle',`scale` = '1.0', `AIName`='', `minlevel` = 82, `maxlevel` = 82, `modelid_1` = 11686, `modelid_2` = 11686, `modelid_3` = 11686, `modelid_4` = 11686, `faction_A` = 14, `faction_H` = 14  WHERE `entry`= 37690;
UPDATE `gameobject_template` SET `faction` = '0', `ScriptName` = 'go_plague_sigil' WHERE `gameobject_template`.`entry` IN (202182);

DELETE FROM `spell_script_target` WHERE `entry` IN (71412, 71415, 71617);
INSERT INTO `spell_script_target` VALUES
(71412, 1, 37824), -- Green Ooze
(71415, 1, 37824), -- Orange Ooze
(71617, 1, 38317); -- Tear Gas

-- delete Grow Stacker - handle in script
DELETE FROM `creature_template_addon` WHERE `entry` = 37690;

-- remove proc from Mutated Strength - currently cooldown for creatures not handled in core
DELETE FROM `spell_proc_event` WHERE `entry` IN (71604, 72673, 72674, 72675);
INSERT INTO `spell_proc_event` (`entry`, `procFlags`) VALUES
(71604, 256),
(72673, 256),
(72674, 256),
(72675, 256);

-- -----------
-- Abomination
-- -----------

DELETE FROM `creature_template_addon` WHERE `entry` IN (37672, 38285);
INSERT INTO `creature_template_addon` (`entry`, `auras`) VALUES
(37672, '70385'),
(38285, '70385');

UPDATE `creature_template` SET `PowerType` = 3, `vehicle_id`=591 WHERE `entry` IN (37672, 38605, 38786, 38787, 38285, 38788, 38789, 38790);

DELETE FROM `spell_script_target` WHERE `entry` IN (70360,72527);
INSERT INTO `spell_script_target` VALUES (70360,1,37690), (72527,1,37690);

UPDATE `creature_template` SET `ScriptName`='mob_mutated_amobination' WHERE `entry`=38285;
UPDATE `creature_template` SET `ScriptName`='mob_mutated_amobination' WHERE `entry`=37672;

-- GO Drink Me table --
UPDATE `gameobject_template` SET `ScriptName`='go_drink_me', `data3`=0 WHERE `entry`=201584;

-- ----------
-- Blood wing
-- ----------

UPDATE `gameobject_template` SET `faction` = '0', `ScriptName` = 'go_bloodwing_sigil' WHERE `gameobject_template`.`entry` IN (202183);
DELETE FROM `spell_script_target` WHERE `entry` IN (70952, 70981, 70982);
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES 
('70952', '1', '37970'),
('70981', '1', '37972'),
('70982', '1', '37973');
-- --------------
-- Lanathel intro
-- --------------

UPDATE `creature_template` SET `ScriptName`='boss_blood_queen_lanathel_intro', `AIName`='' WHERE `entry`= 38004;

UPDATE `creature_template` SET `minhealth` = 5647725, `maxhealth` = 5647725, `ScriptName`='npc_blood_orb_control', `AIName`='' WHERE `entry`= 38008;
UPDATE `creature_template` SET `minhealth` = 22590900, `maxhealth` = 22590900 WHERE `entry` = 38641;
UPDATE `creature_template` SET `minhealth` = 7600025, `maxhealth` = 7600025 WHERE `entry` = 38773;
UPDATE `creature_template` SET `minhealth` = 30469825, `maxhealth` = 30469825 WHERE `entry` = 38774;

-- --------
-- Taldaram
-- --------

UPDATE `creature_template` SET `ScriptName`='boss_taldaram_icc', `AIName`='' WHERE `entry`= 37973;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (37973, 38400, 38771, 38772);
UPDATE `creature_template` SET `ScriptName`='mob_ball_of_flames', `AIName`='',`minlevel` = 82, `maxlevel` = 82, `faction_A` = 14, `faction_H` = 14 WHERE `entry` IN (38332, 38451);

-- -------
-- Valanar
-- -------

UPDATE `creature_template` SET `ScriptName`='boss_valanar_icc', `AIName`='' WHERE `entry`= 37970;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (37970, 38401, 38784, 38785);
UPDATE `creature_template` SET `ScriptName`='mob_kinetic_bomb', `AIName`='',`minlevel` = 82, `maxlevel` = 82, `faction_A` = 14, `faction_H` = 14 WHERE `entry`= 38454;
UPDATE `creature_template` SET `ScriptName`='mob_shock_vortex', `AIName`='',`minlevel` = 82, `maxlevel` = 82, `faction_A` = 14, `faction_H` = 14 WHERE `entry`= 38422;
UPDATE `creature_template` SET `ScriptName`='mob_kinetic_bomb_target', `AIName`='' WHERE `entry`= 38458;

DELETE FROM `spell_proc_event` WHERE `entry` = 72059;
INSERT INTO `spell_proc_event` (`entry`, `SchoolMask`, `procFlags`, `procEx`) VALUES
(72059, 127, 0x00000008|0x00000020|0x00000080|0x00000200|0x00002000|0x00020000|0x00400000, 0x0010000);

-- --------
-- Keleseth
-- --------

UPDATE `creature_template` SET `ScriptName`='boss_keleseth_icc', `AIName`='' WHERE `entry`= 37972;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (36678, 38399, 38769, 38770);
UPDATE `creature_template` SET `ScriptName`='mob_dark_nucleus', `AIName`='',`minlevel` = 82, `maxlevel` = 82, `faction_A` = 14, `faction_H` = 14 WHERE `entry`= 38369;

DELETE FROM  `creature_template_addon` WHERE `entry` IN (37972,37973,37970,38401,38784,38785,38399,38769,38770,38400,38771,38772);


-- -----------------
-- Loot and deathstate for blood council (correct YTDB bugs, flags - from already killed princes)
-- -----------------

UPDATE `creature_template` SET `unit_flags` = '0' WHERE `entry` IN (37972,37973,37970,38401,38784,38785,38399,38769,38770,38400,38771,38772);

UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201920,201377,201378);
UPDATE `gameobject` SET `state` = '1' WHERE `id` IN (201920,201377,201378);
UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201376);
UPDATE `gameobject` SET `state` = '0' WHERE `id` IN (201376);

-- ---------------
-- Queen Lana'thel
-- ---------------

UPDATE `creature_template` SET `ScriptName`='boss_blood_queen_lanathel', `AIName`='' WHERE `entry`= 37955;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (37955, 38434, 38435, 38436);
UPDATE `creature_template` SET  `minlevel` = 80, `maxlevel` = 80, `AIName` ='', `faction_A`= 14, `faction_H` = 14,`ScriptName`='mob_swarming_shadows' WHERE `entry`= 38163;
UPDATE `gameobject_template` SET `faction` = '0', `ScriptName` = 'go_frostwing_sigil' WHERE `gameobject_template`.`entry` IN (202181);
DELETE FROM `spell_proc_event` WHERE entry IN (70871);
INSERT INTO `spell_proc_event` VALUES
(70871, 0x7F,  0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0.000000, 0.000000, 0);

-- Presence of the Darkfallen
DELETE FROM spell_script_target WHERE entry IN (70995, 71952);
INSERT INTO spell_script_target VALUES
(71952, 1, 37955),
(70995, 1, 37955);

-- by default Pact of the Darkfallen is getting spell power coeff, so set it to 0
DELETE FROM `spell_bonus_data` WHERE `entry` = 71341;
INSERT INTO `spell_bonus_data` VALUES
(71341, 0, 0, 0, 0, 'Pact of the Darkfallen (Lanathel)');

DELETE FROM `creature_model_info` WHERE (`modelid`=31165);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (31165, 3, 2, 2, 0, 0);

DELETE FROM `creature_model_info` WHERE (`modelid`=31093);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (31093, 1.24, 2, 1, 0, 0);

-- Ice Wing

UPDATE `creature_template` SET `ScriptName`='mob_svalna', `AIName`='' WHERE `entry`= 37126;
UPDATE `creature_template` SET `ScriptName`='mob_crok', `AIName`='' WHERE `entry`= 37129;
UPDATE `creature_template` SET `ScriptName`='mob_arnath', `AIName`='' WHERE `entry`= 37122;
UPDATE `creature_template` SET `ScriptName`='mob_brandon', `AIName`='' WHERE `entry`= 37123;
UPDATE `creature_template` SET `ScriptName`='mob_grondel', `AIName`='' WHERE `entry`= 37124;
UPDATE `creature_template` SET `ScriptName`='mob_rupert', `AIName`='' WHERE `entry`= 37125;
UPDATE `creature_template` SET `ScriptName`='' WHERE `entry`= 24693;


-- ---------------------
-- Valithria dreamwalker
-- ---------------------
-- delete unused spear
DELETE FROM `creature` WHERE `id` = 38248;
UPDATE `creature_template` SET `faction_A` = 35, `faction_H` = 35, `AIName` = '', `ScriptName` = 'boss_valithria_dreamwalker' WHERE `entry` = 36789;
UPDATE `creature_template` SET `faction_A` = 35, `faction_H` = 35 WHERE `entry` = 38174; -- 25man difficulty
UPDATE `creature_template` SET `faction_A` = 14, `faction_H` = 14, `ScriptName`='mob_valithria_combat_trigger', `AIName`='', `flags_extra` = `flags_extra` &~2 WHERE `entry`= 38752;
UPDATE `creature` SET `phaseMask` = `phaseMask` | 16 WHERE `id` = 38752; -- phaseMask for Combat Trigger
UPDATE `creature_template` SET `unit_flags` = `unit_flags` &~ 33554432, `AIName` = '', `ScriptName` = 'mob_valithria_dream_phase' WHERE `entry` = 37950; -- Valithria in dream phase
REPLACE INTO `creature_template_addon` (`entry`, `emote`) VALUES (`entry` = 37950, `emote` = 453); -- flying state of dream Valithria
UPDATE `creature_template` SET `faction_A` = 35, `faction_H` = 35, `ScriptName` = 'mob_dream_portal_pre', `AIName` = '' WHERE `entry`= 38186;
UPDATE `creature_template` SET `faction_A` = 35, `faction_H` = 35, `IconName` = '', `npcflag` = `npcflag` | 1, `ScriptName` = 'mob_dream_portal', `AIName` = '' WHERE `entry`= 37945;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_dream_cloud', `AIName` = '', `flags_extra` = `flags_extra` &~128 WHERE `entry`= 37985;
UPDATE `creature_template` SET `faction_A` = 35, `faction_H` = 35, `ScriptName` = 'mob_nightmare_portal_pre', `AIName` = '' WHERE `entry` = 38429;
UPDATE `creature_template` SET `faction_A` = 35, `faction_H` = 35, `IconName` = '', `npcflag` = `npcflag` | 1, `ScriptName` = 'mob_nightmare_portal', `AIName` = '' WHERE `entry` = 38430;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_nightmare_cloud', `AIName` = '', `flags_extra` = `flags_extra` &~128 WHERE `entry` = 38421;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_gluttonous_abomination', `AIName` = '' WHERE `entry`= 37886;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_blistering_zombie', `AIName` = '' WHERE `entry`= 37934;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_risen_archmage', `AIName` = '' WHERE `entry`= 37868;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_blazing_skeleton', `AIName` = '' WHERE `entry`= 36791;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16, `ScriptName` = 'mob_suppresser', `AIName` = '' WHERE `entry`= 37863;
UPDATE `creature_template` SET `minlevel` = '83', `maxlevel` = '83',`ScriptName`='mob_mana_void', `AIName`='', `flags_extra` = `flags_extra` &~128 WHERE `entry`= 38068;
UPDATE `creature_template` SET `ScriptName`='mob_column_of_frost', `AIName`='', `flags_extra` = `flags_extra` &~128 WHERE `entry`= 37918;

DELETE FROM `spell_script_target` WHERE `entry` IN (71946, 72031, 72032, 72033);
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES
(71946, 1, 37950),
(72031, 1, 37950),
(72032, 1, 37950),
(72033, 1, 37950);

DELETE FROM `creature` WHERE `id` = 37950;
INSERT INTO `creature` (`id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `curhealth`, `MovementType`) VALUES
(37950, 631, 15, 16, 4203.1416, 2484.8616, 386.4849, 6.276, 604800, 0, 1, 0);

DELETE FROM `creature` WHERE `guid` = 47738 AND `id` = 38589;
DELETE FROM `pool_creature` WHERE `guid`=47738;

UPDATE `gameobject_template` SET `faction` = '0',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201375,201373);
UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201374);
UPDATE `gameobject` SET `state` = '1' WHERE `id` IN (201374);
UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201380,201381,201382,201383);
UPDATE `gameobject_template` SET `faction` = '0' WHERE `entry` IN (201380,201381,201382,201383);
UPDATE `gameobject` SET `state` = '1' WHERE `id` IN (201380,201381,201382,201383);

-- ----------
-- Sindragosa
-- ----------
UPDATE `creature_template` SET `ScriptName`='boss_sindragosa', `AIName`='' WHERE `entry`= 36853;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (36853, 38265, 38266, 38267);
UPDATE `creature_template` SET `ScriptName`='mob_rimefang', `AIName`='' WHERE `entry`= 37533;
UPDATE `creature_template` SET `ScriptName`='mob_spinestalker', `AIName`='' WHERE `entry`= 37534;
UPDATE `creature_template` SET `mechanic_immune_mask` = '667893759' WHERE `entry`  IN (37533, 38220, 37534, 38219);

UPDATE `creature_template` SET `ScriptName`='mob_ice_tomb', `AIName`='' WHERE `entry`= 36980;
UPDATE `creature_template` SET `ScriptName`='mob_frost_bomb', `AIName`='' WHERE `entry`= 37186;
UPDATE `gameobject_template` SET `faction` = '114',`data0` = '0' WHERE `gameobject_template`.`entry` IN (201369,201379);
UPDATE `gameobject` SET `state` = '1' WHERE `id` IN (201369,201379);

DELETE FROM `creature_model_info` WHERE (`modelid`=30362);
INSERT INTO `creature_model_info` (`modelid`, `bounding_radius`, `combat_reach`, `gender`, `modelid_other_gender`, `modelid_alternative`) VALUES (30362, 3, 20, 1, 0, 0);

-- -------------------------------
-- frost bomb target from Lordronn
-- -------------------------------
DELETE FROM `creature_template_addon` WHERE `entry` = 37186;
INSERT INTO `creature_template_addon` (`entry`, `auras`) VALUES (37186, 70022);

-- Unchained Magic - add 1sec cooldown
DELETE FROM `spell_proc_event` WHERE `entry` = 69762;
INSERT INTO `spell_proc_event` VALUES (69762, 0x7E, 0x00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0, 0, 1);

-- ---------
-- Lich King
-- ---------

UPDATE `creature_template` SET `ScriptName`='boss_the_lich_king_icc', `AIName`='' WHERE `entry` = 36597;
UPDATE `creature_template_addon` SET `auras` = '73878 73220 72846' WHERE `entry` IN (36597, 39166, 39167, 39168);
UPDATE `creature_template` SET `speed_walk` = 1.0, `speed_run` = 1.1 WHERE `entry` IN (36597, 39166, 39167, 39168);
UPDATE `creature_template` SET `ScriptName`='boss_tirion_icc', `npcflag`=1, `AIName`='' WHERE `entry`= 38995;
UPDATE `creature_template` SET `ScriptName` = 'boss_terenas_menethil_icc' WHERE entry = 38579;

UPDATE `creature_template` SET `ScriptName`='mob_ice_sphere_icc', `AIName`='' WHERE `entry`= 36633;
UPDATE `creature_template` SET `ScriptName`='mob_defiler_icc', `AIName`='' WHERE `entry`= 38757;
UPDATE `creature_template` SET `ScriptName`='mob_strangulate_vehicle', `AIName`='' WHERE `entry`= 36598;
UPDATE `creature_template` SET `ScriptName`='mob_vile_spirit', `AIName`='' WHERE `entry` IN (37799, 39190);
UPDATE `creature_template` SET `speed_walk` = 1.8, `speed_run` = 1.1 WHERE `entry` IN (37799, 39284, 39285, 39286);
UPDATE `creature_template` SET `ScriptName`='mob_raging_spirit', `AIName`='' WHERE `entry`= 36701;
UPDATE `creature_template` SET `ScriptName`='mob_drudge_ghoul', `AIName`='' WHERE `entry`= 37695;
UPDATE `creature_template` SET `ScriptName`='mob_shambling_horror', `AIName`='' WHERE `entry`= 37698;
UPDATE `creature_template` SET `ScriptName`='mob_shadow_trap', `AIName`='', `faction_A` = 14, `faction_H` = 14, `unit_flags` = `unit_flags` | 2 | 33554432 WHERE `entry`= 39137;
UPDATE `creature_template` SET `ScriptName`='mob_valkyr_shadowguard', `AIName`='' WHERE `entry`= 36609;
UPDATE `creature_template` SET `ScriptName`='npc_terenas_fm', `AIName`='' WHERE `entry`= 36823; -- normal
UPDATE `creature_template` SET `ScriptName`='npc_terenas_fm', `AIName`='' WHERE `entry`= 39217; -- heroic, different entry
UPDATE `creature_template` SET `ScriptName`='mob_spirit_warden', `AIName`='' WHERE `entry`= 36824;
UPDATE `creature_template` SET `ScriptName`='mob_spirit_bomb', `AIName`='', minlevel = 83, maxlevel = 83, `unit_flags` = `unit_flags` | 33554432, `faction_A` = 14, `faction_H` = 14 WHERE `entry`= 39189;

-- speed of Wicked Spirits
UPDATE `creature_template` SET `speed_walk` = 0.9, `speed_run` = 0.9 WHERE `entry` IN (39190, 39287, 39288, 39289);

-- damage of Terenas and Spirit Warden, they should be hitting each other for around 10-11k normal melee damage
UPDATE `creature_template` SET `dmg_multiplier` = 46 WHERE `entry` IN (36823, 36824, 39296);

-- make Ice Spheres untauntable
UPDATE `creature_template` SET `mechanic_immune_mask` = `mechanic_immune_mask` | 256 WHERE `entry` IN (36633, 39305, 39306, 39307);

DELETE FROM `spell_script_target` WHERE `entry` IN (71614, 74074, 73028, 74321, 74322, 74323, 72679, 74318, 74319, 74320);
INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`) VALUES
(71614, 1, 38995),
(74074, 1, 36597),
(73028, 1, 36597), -- Harvested Soul
(74321, 1, 36597),
(74322, 1, 36597),
(74323, 1, 36597),
(72679, 1, 36597),
(74318, 1, 36597),
(74319, 1, 36597),
(74320, 1, 36597);

-- proc for Dark Hunger
DELETE FROM `spell_proc_event` WHERE `entry` = 69383;
INSERT INTO `spell_proc_event` (`entry`, `procFlags`) VALUES
(69383, 0x04 | 0x10 | 0x10000);

-- fix stats for some creatures
-- Raging Spirit
UPDATE `creature_template` SET `minhealth` = 885400, `maxhealth` = 885400 WHERE `entry` = 36701; -- 10normal
UPDATE `creature_template` SET `minhealth` = 2650000, `maxhealth` = 2650000 WHERE `entry` = 39302; -- 25normal
UPDATE `creature_template` SET `minhealth` = 1230000, `maxhealth` = 1230000 WHERE `entry` = 39303; -- 10hero
UPDATE `creature_template` SET `minhealth` = 4150000, `maxhealth` = 4150000 WHERE `entry` = 39304; -- 25hero

-- Ice Sphere
UPDATE `creature_template` SET `minhealth` = 6000, `maxhealth` = 6000 WHERE `entry` = 36633; -- 10normal
UPDATE `creature_template` SET `minhealth` = 15200, `maxhealth` = 15200 WHERE `entry` = 39305; -- 25normal
UPDATE `creature_template` SET `minhealth` = 15200, `maxhealth` = 15200 WHERE `entry` = 39306; -- 10hero
UPDATE `creature_template` SET `minhealth` = 53200, `maxhealth` = 53200 WHERE `entry` = 39307; -- 25hero

-- -----------------
-- EAI YTDB CLEAN UP
-- -----------------
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=37973);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=37972);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=37970);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=38004);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=38112);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=37813);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=36627);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=36723);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=36789);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=36612);
DELETE FROM `creature_ai_scripts` WHERE (`creature_id`=36855);


-- -----------------------------------------------------------------------------------------------
-- Instance Fixes --------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------

-- The Following had the auras  ' permanet Fegien death, be undead and some other retarded aura

DELETE FROM `creature_template_addon` WHERE (`entry`=37122);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37122, 0, 0, 1, 0, 333, 0);

DELETE FROM `creature_template_addon` WHERE (`entry`=37123);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37123, 0, 0, 1, 0, 333, 0);

DELETE FROM `creature_template_addon` WHERE (`entry`=37124);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37124, 0, 0, 1, 0, 333, 0);

DELETE FROM `creature_template_addon` WHERE (`entry`=37125);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37125, 0, 0, 1, 0, 333, 0);

DELETE FROM `creature_template_addon` WHERE (`entry`=37132);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37132, 0, 0, 0, 0, 333, 0);

DELETE FROM `creature_template_addon` WHERE (`entry`=37134);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37134, 0, 0, 0, 0, 333, 0);

DELETE FROM `creature_template_addon` WHERE (`entry`=37133);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`) VALUES (37133, 0, 0, 0, 0, 333, 0);

UPDATE `creature_template` SET `AIName` = '' WHERE `entry` = 36725;
UPDATE `creature_template`SET `AIName` = '' WHERE `entry` = 37007;

-- end of weird addon fix

-- fix double spawn of dream dragon
-- DELETE FROM `creature` WHERE `id`=37950;


-- fix spells of teleports
DELETE FROM `spell_script_target` WHERE `entry` IN (70856, 70857, 70858, 70859, 70860, 70861);
INSERT INTO `spell_script_target` VALUES
(70856, 0, 202243),
(70857, 0, 202244),
(70858, 0, 202245),
(70859, 0, 202246),
(70860, 0, 202247),
(70861, 0, 202248);

DELETE FROM `spell_target_position` WHERE `id` IN (70856, 70857, 70858, 70859, 70860, 70861, 72546, 73655);
INSERT INTO `spell_target_position` VALUES  
(70856, 631, -503.62, 2211.47, 62.8235, 3.14),  	
(70857, 631, -615.145, 2211.47, 199.972, 0),  	
(70858, 631, -549.131, 2211.29, 539.291, 0),  	
(70859, 631, 4198.42, 2769.22, 351.065, 0),  		
(70860, 631, 529.302, -2124.49, 840.857, 3.1765), 
(70861, 631, 4356.580078, 2565.75, 220.401993, 4.90),  	 	
(72546, 631, 514.000, -2523.00, 1050.990, 3.1765),
(73655, 631, 495.708, -2523.76, 1250.990, 3.1765);
-- ------
