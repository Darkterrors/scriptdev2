/* Copyright (C) 2006 - 2012 ScriptDev2 <http://www.scriptdev2.com/>
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* ScriptData
SDName: boss_anubarak_trial
SD%Complete: 70%
SDComment: by /dev/rsa
SDCategory:
EndScriptData */

#include "precompiled.h"
#include "trial_of_the_crusader.h"

enum Yells
{
    SAY_INTRO                       = -1713554,
    SAY_AGGRO                       = -1713555,
    SAY_SUBMERGE                    = -1713556,
    SAY_LOW_HEALTH                  = -1713560,
    SAY_SLAY_1                      = -1713562,
    SAY_SLAY_2                      = -1713563,
    SAY_DEATH                       = -1713564,

    EMOTE_SUBMERGE                  = -1713557,
    EMOTE_PURSUING                  = -1713558,
    EMOTE_OUT_OF_THE_GROUND         = -1713559,
    EMOTE_LEECHING_SWARM            = -1713561,
};

enum Summons
{
    NPC_FROST_SPHERE                = 34606,
    NPC_PERMAFROST                  = 33184,
    NPC_NERUBIAN_BURROW_1           = 34862,
    NPC_NERUBIAN_BURROW_2           = 34863,
    NPC_NERUBIAN_BURROW_3           = 34864,
    NPC_NERUBIAN_BURROW_4           = 34865,
    NPC_BURROWER                    = 34607,
    NPC_SCARAB                      = 34605,
    NPC_SPIKE                       = 34660,
    NPC_SPIKE_TRIGGER               = 5672,
};

enum BossSpells
{
    SPELL_FROST_VISUAL              = 67539,
    SPELL_PERMAFROST                = 66193,
    SPELL_PERMAFROST_SPAWN          = 65882,
    SPELL_COLD                      = 66013,
    SPELL_MARK                      = 67574,
    SPELL_LEECHING_SWARM            = 66118,
    SPELL_IMPALE                    = 65919,
    SPELL_IMPALE_GROUND             = 65921,
    SPELL_PURSUING_SPIKE_LOW        = 65920,
    SPELL_PURSUING_SPIKE_MED        = 65922,
    SPELL_PURSUING_SPIKE_HIGH       = 65923,
    SPELL_PURSUING_SPIKE_COLD       = 66181,
    SPELL_POUND                     = 66012,
    SPELL_SHOUT                     = 67730,
    SPELL_SUBMERGE_ANUB             = 53421,
    SPELL_EMERGE_ANUB               = 65982,
    SPELL_SUBMERGE_BURROWER         = 67322,
    SPELL_EMERGE_BURROWER           = 65982,
    SPELL_SUMMON_BEATLES            = 66339,
    SPELL_DETERMINATION             = 66092,
    SPELL_ACID_MANDIBLES            = 65774,
    SPELL_SPIDER_FRENZY             = 66129,
    SPELL_EXPOSE_WEAKNESS           = 67847,
    SPELL_SUMMON_SCARAB             = 66340,
    SPELL_SHADOW_STRIKE             = 66134,
    SPELL_ACHIEV_TRAITOR_KING_10    = 68186,
    SPELL_ACHIEV_TRAITOR_KING_25    = 68515,
    SPELL_BERSERK                   = 26662,
};

enum Phases
{
    PHASE_NORMAL            = 0,
    PHASE_SUBMERGED         = 1,
    PHASE_LEECHING          = 2,
};

struct MANGOS_DLL_DECL boss_anubarak_trialAI : public BSWScriptedAI
{   
    boss_anubarak_trialAI(Creature* pCreature) : BSWScriptedAI(pCreature)
    {
        m_pInstance = (ScriptedInstance*)pCreature->GetInstanceData();
        m_uiMapDifficulty = pCreature->GetMap()->GetDifficulty();
        m_bIsHeroic = m_uiMapDifficulty > RAID_DIFFICULTY_25MAN_NORMAL;
        m_bIs25Man = (m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_NORMAL || m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_HEROIC);

        Reset();
    }

    ScriptedInstance* m_pInstance;
    Difficulty m_uiMapDifficulty;
    bool m_bIntroSaid;
    bool m_bIsHeroic;
    bool m_bIs25Man;

    uint32 m_uiPhase;

    uint32 m_uiPoundTimer;
    uint32 m_uiColdTimer;
    uint32 m_uiSummonBurrowerTimer;
    uint32 m_uiSubmergeAnubTimer;
    uint32 m_uiNerubianBurrowTimer;
    uint32 m_uiSubmergePhaseTimer;
    uint32 m_uiFrostSphereOneTimer;
    uint32 m_uiFrostSphereTwoTimer;
    uint32 m_uiSummonScarabTimer;
    uint32 m_uiPursuingTimer;
    uint32 m_uiBerserkTimer;

    Unit* pTarget;

    void Reset() 
    {
        if (!m_pInstance) 
           return;

        m_bIntroSaid                 = false;
        pTarget                      = NULL;

        m_uiPhase                    = PHASE_NORMAL;

        m_uiPoundTimer               = 20000;
        m_uiColdTimer                = 30000;
        m_uiSummonBurrowerTimer      = 10000;
        m_uiSubmergeAnubTimer        = 80000;
        m_uiNerubianBurrowTimer      = 0;
        m_uiSubmergePhaseTimer       = 88000;
        m_uiFrostSphereOneTimer      = urand(5000, 10000);
        m_uiFrostSphereTwoTimer      = 2000;
        m_uiSummonScarabTimer        = 2000;
        m_uiPursuingTimer            = 1000;
        m_uiBerserkTimer             = 600000;

        m_creature->SetRespawnDelay(7*DAY);

        m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
        m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
        ShowBurrows(false);
    }

    void KilledUnit(Unit* pVictim)
    {
        if (pVictim->GetTypeId() != TYPEID_PLAYER)
            return;

        DoScriptText(SAY_SLAY_1 - urand(0, 1),m_creature,pVictim);
    }
    void MoveInLineOfSight(Unit* pWho) 
    {
        if (m_bIntroSaid)
            return;

        DoScriptText(SAY_INTRO, m_creature);
        m_bIntroSaid = true;
    }

    void JustReachedHome()
    {
        if (m_pInstance)
            m_pInstance->SetData(TYPE_ANUBARAK, FAIL);
    }

    void JustDied(Unit* pKiller)
    {
        if (!m_pInstance) 
            return;

        m_pInstance->SetData(TYPE_COUNTER, m_pInstance->GetData(TYPE_COUNTER));
        DoScriptText(SAY_DEATH, m_creature);
        m_pInstance->SetData(TYPE_ANUBARAK, DONE);
        m_pInstance->SetData(TYPE_EVENT, 6000);
    }

    void Aggro(Unit* pWho)
    {
        if (m_bIntroSaid)
            DoScriptText(SAY_AGGRO, m_creature);

        m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
        m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
        m_creature->SetInCombatWithZone();
        m_pInstance->SetData(TYPE_ANUBARAK, IN_PROGRESS);
    }

    void SummonBurrowers()
    {
        float x, y, z;
        m_creature->GetPosition(x, y, z);
        m_creature->SummonCreature(NPC_BURROWER, x + 3.0f, y + 3.0f, z, 0, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT_OR_DEAD_DESPAWN, 60000);

        if (m_bIs25Man || m_bIsHeroic)
            m_creature->SummonCreature(NPC_BURROWER, x + 3.0f, y + 3.0f, z, 0, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT_OR_DEAD_DESPAWN, 60000);

        if (m_bIs25Man && m_bIsHeroic)
        {
            m_creature->SummonCreature(NPC_BURROWER, x + 3.0f, y + 3.0f, z, 0, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT_OR_DEAD_DESPAWN, 60000);
            m_creature->SummonCreature(NPC_BURROWER, x + 3.0f, y + 3.0f, z, 0, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT_OR_DEAD_DESPAWN, 60000);
        }
    }

    void ShowBurrows(bool m_bShow)
    {
        if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_1))
            pNerubianBurrow->SetVisibility(m_bShow ? VISIBILITY_ON : VISIBILITY_OFF);

        if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_2))
            pNerubianBurrow->SetVisibility(m_bShow ? VISIBILITY_ON : VISIBILITY_OFF);

        if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_3))
            pNerubianBurrow->SetVisibility(m_bShow ? VISIBILITY_ON : VISIBILITY_OFF);

        if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_4))
            pNerubianBurrow->SetVisibility(m_bShow ? VISIBILITY_ON : VISIBILITY_OFF);
    }

    void UpdateAI(const uint32 uiDiff)
    {
        if (!m_creature->SelectHostileTarget() || !m_creature->getVictim())
            return;

        if (m_uiBerserkTimer <= uiDiff)
        {
            if (DoCastSpellIfCan(m_creature, SPELL_BERSERK) == CAST_OK)
                m_uiBerserkTimer = 600000;
        }
        else
            m_uiBerserkTimer -= uiDiff;

        switch (m_uiPhase)
        {
        case PHASE_NORMAL:
            if (m_uiFrostSphereOneTimer <= uiDiff)
            {
                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[29].x + urand(5, 15), SpawnLoc[29].y - urand(10, 20), SpawnLoc[29].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[30].x + urand(5, 15), SpawnLoc[30].y - urand(10, 20), SpawnLoc[30].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[31].x + urand(5, 15), SpawnLoc[31].y - urand(10, 20), SpawnLoc[31].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[32].x + urand(5, 15), SpawnLoc[32].y - urand(10, 20), SpawnLoc[32].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[49].x + urand(5, 15), SpawnLoc[49].y - urand(10, 20), SpawnLoc[49].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[50].x + urand(5, 15), SpawnLoc[50].y - urand(10, 20), SpawnLoc[50].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[51].x + urand(5, 15), SpawnLoc[51].y - urand(10, 20), SpawnLoc[51].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[52].x + urand(5, 15), SpawnLoc[52].y - urand(10, 20), SpawnLoc[52].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                m_uiFrostSphereOneTimer = 40000;
            }
            else
                m_uiFrostSphereOneTimer -= uiDiff;

            if (m_uiPoundTimer <= uiDiff)
            {
                if (DoCastSpellIfCan(m_creature->getVictim(), SPELL_POUND) == CAST_OK)
                    m_uiPoundTimer = 20000;
            }
            else
                m_uiPoundTimer -= uiDiff;

            if (m_uiColdTimer <= uiDiff)
            {
                if (DoCastSpellIfCan(m_creature->getVictim(), SPELL_COLD) == CAST_OK)
                    m_uiColdTimer = 25000;
            }
            else
                m_uiColdTimer -= uiDiff;

            if (m_uiSummonBurrowerTimer <= uiDiff)
            {
                SummonBurrowers();
                m_uiSummonBurrowerTimer = 45000;
            }
            else
                m_uiSummonBurrowerTimer -= uiDiff;

            if (m_uiSubmergeAnubTimer <= uiDiff)
            {
                if(DoCastSpellIfCan(m_creature, SPELL_SUBMERGE_ANUB) == CAST_OK)
                {
                    ShowBurrows(true);
                    m_uiPhase = PHASE_SUBMERGED;
                    m_creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                    m_creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                    DoScriptText(SAY_SUBMERGE, m_creature);
                    DoScriptText(EMOTE_SUBMERGE, m_creature);
                    m_uiSubmergeAnubTimer = 80000;
                }
            }
            else
                m_uiSubmergeAnubTimer -= uiDiff;

            if (m_creature->GetHealthPercent() < 30.0f)
            {
                if (DoCastSpellIfCan(m_creature, SPELL_LEECHING_SWARM) == CAST_OK)
                {
                    DoScriptText(SAY_LOW_HEALTH, m_creature);
                    DoScriptText(EMOTE_LEECHING_SWARM, m_creature);
                    m_uiPhase = PHASE_LEECHING;
                }
            }

            DoMeleeAttackIfReady();
            break;
        case PHASE_SUBMERGED:
            if (m_uiPursuingTimer <= uiDiff)
            {
                float x, y, z;
                m_creature->GetPosition(x, y, z);

                m_creature->SummonCreature(NPC_SPIKE, x, y, z, 0, TEMPSUMMON_MANUAL_DESPAWN, 60000);
                m_uiPursuingTimer = 90000;
            }
            else
               m_uiPursuingTimer -= uiDiff;

            if (m_uiFrostSphereTwoTimer <= uiDiff)
            {
                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[29].x + urand(5, 15), SpawnLoc[29].y - urand(10, 20), SpawnLoc[29].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 20000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[30].x + urand(5, 15), SpawnLoc[30].y - urand(10, 20), SpawnLoc[30].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 40000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[31].x + urand(5, 15), SpawnLoc[31].y - urand(10, 20), SpawnLoc[31].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 20000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[32].x + urand(5, 15), SpawnLoc[32].y - urand(10, 20), SpawnLoc[32].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 40000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[49].x + urand(5, 15), SpawnLoc[49].y - urand(10, 20), SpawnLoc[49].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[50].x + urand(5, 15), SpawnLoc[50].y - urand(10, 20), SpawnLoc[50].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[51].x + urand(5, 15), SpawnLoc[51].y - urand(10, 20), SpawnLoc[51].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                if (Creature *pFrostSphere = m_creature->SummonCreature(NPC_FROST_SPHERE, SpawnLoc[52].x + urand(5, 15), SpawnLoc[52].y - urand(10, 20), SpawnLoc[52].z + 10.0f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
                    pFrostSphere->CastSpell(m_creature, SPELL_FROST_VISUAL, false);

                m_uiFrostSphereTwoTimer = 30000;
            }
            else
                m_uiFrostSphereTwoTimer -= uiDiff;

            if (m_uiSummonScarabTimer <= uiDiff)
            {
                if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_1))
                    pNerubianBurrow->CastSpell(pNerubianBurrow, SPELL_SUMMON_SCARAB, false);

                if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_2))
                    pNerubianBurrow->CastSpell(pNerubianBurrow, SPELL_SUMMON_SCARAB, false);

                if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_3))
                    pNerubianBurrow->CastSpell(pNerubianBurrow, SPELL_SUMMON_SCARAB, false);

                if (Creature *pNerubianBurrow = m_pInstance->GetSingleCreatureFromStorage(NPC_NERUBIAN_BURROW_4))
                    pNerubianBurrow->CastSpell(pNerubianBurrow, SPELL_SUMMON_SCARAB, false);

                m_uiSummonScarabTimer = 8000;
            }
            else
                m_uiSummonScarabTimer -= uiDiff;

            if (m_uiSubmergePhaseTimer <= uiDiff)
            {
                m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                DoScriptText(EMOTE_OUT_OF_THE_GROUND,m_creature);
                if (Creature *pSpike = m_pInstance->GetSingleCreatureFromStorage(NPC_SPIKE))
                    pSpike->ForcedDespawn();

                ShowBurrows(false);
                m_creature->RemoveAurasDueToSpell(SPELL_SUBMERGE_ANUB);
                DoCastSpellIfCan(m_creature, SPELL_EMERGE_ANUB, CAST_TRIGGERED);
                m_uiPhase = PHASE_NORMAL;
                m_uiSubmergePhaseTimer = 90000;
            }
            else
                m_uiSubmergePhaseTimer -= uiDiff;

            break;
        case PHASE_LEECHING:
            if (m_uiPoundTimer <= uiDiff)
            {
                if (DoCastSpellIfCan(m_creature->getVictim(), SPELL_POUND) == CAST_OK)
                    m_uiPoundTimer = 20000;
            }
            else
                m_uiPoundTimer -= uiDiff;

            if (m_uiColdTimer <= uiDiff)
            {
                if (DoCastSpellIfCan(m_creature->getVictim(), SPELL_COLD) == CAST_OK)
                    m_uiColdTimer = 25000;
            }
            else
                m_uiColdTimer -= uiDiff;

            if (m_bIsHeroic)
            {
                if (m_uiSummonBurrowerTimer <= uiDiff)
                {
                    SummonBurrowers();
                    m_uiSummonBurrowerTimer = 45000;
                }
                else
                    m_uiSummonBurrowerTimer -= uiDiff;
            }

            DoMeleeAttackIfReady();
            break;
        }
    }
};

CreatureAI* GetAI_boss_anubarak_trial(Creature* pCreature)
{
    return new boss_anubarak_trialAI(pCreature);
}

struct MANGOS_DLL_DECL mob_swarm_scarabAI : public BSWScriptedAI
{
    mob_swarm_scarabAI(Creature* pCreature) : BSWScriptedAI(pCreature)
    {
        m_pInstance = (ScriptedInstance*)pCreature->GetInstanceData();
        m_uiMapDifficulty = pCreature->GetMap()->GetDifficulty();
        m_bIsHeroic = m_uiMapDifficulty > RAID_DIFFICULTY_25MAN_NORMAL;
        m_bIs25Man = (m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_NORMAL || m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_HEROIC);

        Reset();
    }

    ScriptedInstance* m_pInstance;
    Difficulty m_uiMapDifficulty;
    bool m_bIsHeroic;
    bool m_bIs25Man;

    uint32 m_uiAcidMandibleTimer;
    uint32 m_uiDeterminationTimer;

    void Reset()
    {
        m_creature->SetInCombatWithZone();
        m_creature->SetRespawnDelay(DAY);

        m_uiDeterminationTimer   = urand(10000, 20000);
    }

    void KilledUnit(Unit* pVictim)
    {
        if (pVictim->GetTypeId() != TYPEID_PLAYER) 
            return;
    }

    void JustDied(Unit* Killer)
    {
        m_pInstance->DoStartTimedAchievement(ACHIEVEMENT_CRITERIA_TYPE_BE_SPELL_TARGET, m_bIs25Man ? SPELL_ACHIEV_TRAITOR_KING_25 : SPELL_ACHIEV_TRAITOR_KING_10);
        m_pInstance->DoUpdateAchievementCriteria(ACHIEVEMENT_CRITERIA_TYPE_BE_SPELL_TARGET, m_bIs25Man ? SPELL_ACHIEV_TRAITOR_KING_25 : SPELL_ACHIEV_TRAITOR_KING_10);
        m_creature->ForcedDespawn(5000);
    }

    void Aggro(Unit *who)
    {
        if (!m_pInstance) 
            return;

        DoCastSpellIfCan(m_creature, SPELL_ACID_MANDIBLES, CAST_TRIGGERED);
    }

    void UpdateAI(const uint32 uiDiff)
    {
        if (m_pInstance && m_pInstance->GetData(TYPE_ANUBARAK) != IN_PROGRESS) 
            m_creature->ForcedDespawn();

        if (!m_creature->SelectHostileTarget() || !m_creature->getVictim())
            return;

        if (m_uiDeterminationTimer <= uiDiff)
        {
            if (DoCastSpellIfCan(m_creature, SPELL_DETERMINATION) == CAST_OK)
                m_uiDeterminationTimer = 30000;
        }
        else
            m_uiDeterminationTimer -= uiDiff;

        DoMeleeAttackIfReady();
    }
};

CreatureAI* GetAI_mob_swarm_scarab(Creature* pCreature)
{
    return new mob_swarm_scarabAI(pCreature);
};

struct MANGOS_DLL_DECL mob_nerubian_borrowerAI : public BSWScriptedAI
{
    mob_nerubian_borrowerAI(Creature* pCreature) : BSWScriptedAI(pCreature)
    {
        m_pInstance = (ScriptedInstance*)pCreature->GetInstanceData();
        m_uiMapDifficulty = pCreature->GetMap()->GetDifficulty();
        m_bIsHeroic = m_uiMapDifficulty > RAID_DIFFICULTY_25MAN_NORMAL;
        m_bIs25Man = (m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_NORMAL || m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_HEROIC);
        Reset();
    }

    ScriptedInstance* m_pInstance;
    Difficulty m_uiMapDifficulty;
    bool m_bIsSubmerged;
    bool m_bIsHeroic;
    bool m_bIs25Man;

    uint32 m_uiExposeWeaknessTimer;
    uint32 m_uiSpiderFrenzyTimer;
    uint32 m_uiShadowStrikeTimer;
    uint32 m_uiSubmergeBurrowerTimer;

    void Reset()
    {
        m_creature->SetInCombatWithZone();
        m_creature->SetRespawnDelay(DAY);
        m_bIsSubmerged = false;
  
        m_uiExposeWeaknessTimer    = 8000;
        m_uiSpiderFrenzyTimer      = 0;
        m_uiShadowStrikeTimer      = 5000;
        m_uiSubmergeBurrowerTimer  = 5000;
    }

    void KilledUnit(Unit* pVictim)
    {
        if (pVictim->GetTypeId() != TYPEID_PLAYER) 
            return;
    }

    void JustDied(Unit* Killer)
    {
        m_creature->ForcedDespawn(5000);

        if (Creature* pNerubianBurrower = GetClosestCreatureWithEntry(m_creature, NPC_BURROWER, 50.0f))
            pNerubianBurrower->RemoveAurasDueToSpell(SPELL_SPIDER_FRENZY);
    }

    void Aggro(Unit *who)
    {
        if (!m_pInstance) 
            return;
    }

    void UpdateAI(const uint32 uiDiff)
    {
        if (m_pInstance && m_pInstance->GetData(TYPE_ANUBARAK) != IN_PROGRESS) 
            m_creature->ForcedDespawn();

        if (!m_creature->SelectHostileTarget() || !m_creature->getVictim())
            return;

        if (m_uiExposeWeaknessTimer <= uiDiff)
        {
            if (DoCastSpellIfCan(m_creature->getVictim(), SPELL_EXPOSE_WEAKNESS) == CAST_OK)
                m_uiExposeWeaknessTimer = 8000;
        }
        else
            m_uiExposeWeaknessTimer -= uiDiff;

        if (m_uiSpiderFrenzyTimer <= uiDiff)
        {
            if (Creature* pNerubianBurrower = GetClosestCreatureWithEntry(m_creature, NPC_BURROWER, 50.0f))
            {
                m_creature->_AddAura(SPELL_SPIDER_FRENZY);
                pNerubianBurrower->_AddAura(SPELL_SPIDER_FRENZY);
            }

            m_uiSpiderFrenzyTimer = 1000;
        }
        else
            m_uiSpiderFrenzyTimer -= uiDiff;

        if (m_bIsHeroic)
        {   
            if (m_uiShadowStrikeTimer <= uiDiff)
            {
                if (DoCastSpellIfCan(m_creature->getVictim(), SPELL_SHADOW_STRIKE) == CAST_OK)
                    m_uiShadowStrikeTimer = 30000;
            }
            else
                m_uiShadowStrikeTimer -= uiDiff;
        }

        if (m_creature->GetHealthPercent() < 20.0f && !m_bIsSubmerged && !m_creature->HasAura(SPELL_PERMAFROST))
        {
            if (DoCastSpellIfCan(m_creature, SPELL_SUBMERGE_BURROWER) == CAST_OK)
            {
                m_creature->RemoveAllAuras();
                m_creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                m_creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                DoScriptText(EMOTE_SUBMERGE, m_creature);
                m_bIsSubmerged = true;
            }
        }

        if (m_bIsSubmerged)
        {
            if (m_uiSubmergeBurrowerTimer <= uiDiff)
            {
                if (DoCastSpellIfCan(m_creature, SPELL_EMERGE_BURROWER) == CAST_OK)
                {
                    m_creature->RemoveAurasDueToSpell(SPELL_SUBMERGE_BURROWER);
                    m_creature->SetHealth(m_creature->GetMaxHealth());
                    m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                    m_creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                    DoScriptText(EMOTE_OUT_OF_THE_GROUND, m_creature);
                    m_bIsSubmerged = false;
                    m_uiSubmergeBurrowerTimer = 5000;
                }

            }
            else
                m_uiSubmergeBurrowerTimer -= uiDiff;
        }

        DoMeleeAttackIfReady();
    }
};

CreatureAI* GetAI_mob_nerubian_borrower(Creature* pCreature)
{
    return new mob_nerubian_borrowerAI(pCreature);
};

struct MANGOS_DLL_DECL mob_frost_sphereAI : public BSWScriptedAI
{
    mob_frost_sphereAI(Creature* pCreature) : BSWScriptedAI(pCreature)
    {
        m_pInstance = (ScriptedInstance*)pCreature->GetInstanceData();
        Reset();
    }

    ScriptedInstance* m_pInstance;

    void Reset()
    {
        m_creature->SetRespawnDelay(DAY);
        m_creature->SetLevitate(true);
        SetCombatMovement(false);
        m_creature->GetMotionMaster()->MoveRandom();
    }

    void Aggro(Unit *who)
    {
        if (!m_pInstance) 
            return;

        if (!m_creature->SelectHostileTarget() || !m_creature->getVictim())
            return;

        m_creature->SetVisibility(VISIBILITY_OFF);
        m_creature->CastSpell(m_creature, SPELL_PERMAFROST_SPAWN, false);

        float x, y, z;
        m_creature->GetPosition(x, y, z);
        if (Creature *pPermafrost = m_creature->SummonCreature(NPC_PERMAFROST, x, y, z - 9.8f, 0, TEMPSUMMON_TIMED_DESPAWN, 30000))
        {
            pPermafrost->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
            pPermafrost->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
            pPermafrost->CastSpell(pPermafrost, SPELL_PERMAFROST, false);
        }
    }

    void UpdateAI(const uint32 uiDiff)
    {
        if (!m_pInstance || m_pInstance->GetData(TYPE_ANUBARAK) != IN_PROGRESS) 
            m_creature->ForcedDespawn();
    }
};

CreatureAI* GetAI_mob_frost_sphere(Creature* pCreature)
{
    return new mob_frost_sphereAI(pCreature);
};

struct MANGOS_DLL_DECL mob_anubarak_spikeAI : public BSWScriptedAI
{
    mob_anubarak_spikeAI(Creature* pCreature) : BSWScriptedAI(pCreature)
    {
        m_pInstance = (ScriptedInstance*)pCreature->GetInstanceData();
        m_uiMapDifficulty = pCreature->GetMap()->GetDifficulty();
        m_bIsHeroic = m_uiMapDifficulty > RAID_DIFFICULTY_25MAN_NORMAL;
        m_bIs25Man = (m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_NORMAL || m_uiMapDifficulty == RAID_DIFFICULTY_25MAN_HEROIC);
        Reset();
    }

    ScriptedInstance* m_pInstance;
    Difficulty m_uiMapDifficulty;

    bool m_bIncreaseSpeed;
    bool m_bIsHeroic;
    bool m_bIs25Man;

    uint32 m_uiEventStep;
    uint32 m_uiNextEventTimer;

    uint32 m_uiImpaleTimer;
    uint32 m_uiIncreaseSpeedTimer;
    uint32 m_uiSpikeCallTimer;
    uint32 m_uiPermafrostTimer;

    void Reset()
    {
        m_creature->SetRespawnDelay(DAY);
        m_creature->SetVisibility(VISIBILITY_OFF);
        m_creature->SetInCombatWithZone();
        m_creature->setFaction(14);
        m_creature->SetSpeedRate(MOVE_RUN, 0.0f);
        m_creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
        m_creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);

        m_uiEventStep             = 0;
        m_uiNextEventTimer        = 8000;

        m_uiImpaleTimer           = 5000;
        m_uiIncreaseSpeedTimer    = 5000;
        m_uiSpikeCallTimer        = 4500;
        m_uiPermafrostTimer       = 5000;
    }

    void NextStep(uint32 uiTime = 1000)
    {
        ++m_uiEventStep;
        m_uiIncreaseSpeedTimer = uiTime;
    }

    void Aggro(Unit *who)
    {
        if (!m_pInstance) 
            return;
    }

    void UpdateAI(const uint32 uiDiff)
    {
        if (m_pInstance && m_pInstance->GetData(TYPE_ANUBARAK) != IN_PROGRESS) 
            m_creature->ForcedDespawn();

        if (!m_creature->SelectHostileTarget() || !m_creature->getVictim())
            return;

        if (m_creature->HasAura(SPELL_PERMAFROST))
        {
            m_creature->ForcedDespawn();

            float x, y, z;
            m_creature->GetPosition(x, y, z);
            m_creature->SummonCreature(NPC_SPIKE, x + urand(5.0f, 10.0f), y + urand(5.0f, 10.0f), z, 0, TEMPSUMMON_TIMED_DESPAWN, 30000);
        }

        if (m_uiIncreaseSpeedTimer <= uiDiff)
        {   
            switch (m_uiEventStep)
            {   
                 case 0:
                      m_creature->SetSpeedRate(MOVE_RUN, 0.75f);
                      m_creature->CastSpell(m_creature, SPELL_PURSUING_SPIKE_LOW, false);
                      NextStep(7000);
                      break;
                 case 1:
                      m_creature->SetSpeedRate(MOVE_RUN, 1.0f);
                      m_creature->CastSpell(m_creature, SPELL_PURSUING_SPIKE_MED, false);
                      NextStep(7000);
                      break;
                 case 2:
                      m_creature->SetSpeedRate(MOVE_RUN, 1.5f);
                      m_creature->CastSpell(m_creature, SPELL_PURSUING_SPIKE_HIGH, false);
                      NextStep(7000);
                      break;
            }
        }
        else
            m_uiIncreaseSpeedTimer -= uiDiff;

        if (m_uiSpikeCallTimer < uiDiff)
        {
            m_creature->SetVisibility(VISIBILITY_ON);

            if (Unit* pTarget = m_creature->SelectAttackingTarget(ATTACKING_TARGET_RANDOM, 0))
            {
                DoScriptText(EMOTE_PURSUING, m_creature, pTarget);
                m_creature->AddThreat(pTarget, 100000.0f);
                DoCastSpellIfCan(pTarget, SPELL_MARK, CAST_TRIGGERED);
                DoCastSpellIfCan(m_creature, SPELL_IMPALE_GROUND, CAST_TRIGGERED);
            }
            m_uiSpikeCallTimer = 90000;
        }
        else
            m_uiSpikeCallTimer -= uiDiff;

        if (m_creature->IsWithinDist(m_creature->getVictim(), 4.0f))
        {
            if(DoCastSpellIfCan(m_creature->getVictim(), SPELL_IMPALE) == CAST_OK)
            {
                float x, y, z;
                m_creature->GetPosition(x, y, z);
                m_creature->SummonCreature(NPC_SPIKE, x, y, z, 0, TEMPSUMMON_TIMED_DESPAWN, 30000);

                m_creature->ForcedDespawn(500);
            }
        }
    }
};

CreatureAI* GetAI_mob_anubarak_spike(Creature* pCreature)
{
    return new mob_anubarak_spikeAI(pCreature);
};

void AddSC_boss_anubarak_trial()
{
    Script* pNewScript;

    pNewScript = new Script;
    pNewScript->Name = "boss_anubarak_trial";
    pNewScript->GetAI = &GetAI_boss_anubarak_trial;
    pNewScript->RegisterSelf();

    pNewScript = new Script;
    pNewScript->Name = "mob_swarm_scarab";
    pNewScript->GetAI = &GetAI_mob_swarm_scarab;
    pNewScript->RegisterSelf();

    pNewScript = new Script;
    pNewScript->Name = "mob_nerubian_borrower";
    pNewScript->GetAI = &GetAI_mob_nerubian_borrower;
    pNewScript->RegisterSelf();

    pNewScript = new Script;
    pNewScript->Name = "mob_anubarak_spike";
    pNewScript->GetAI = &GetAI_mob_anubarak_spike;
    pNewScript->RegisterSelf();

    pNewScript = new Script;
    pNewScript->Name = "mob_frost_sphere";
    pNewScript->GetAI = &GetAI_mob_frost_sphere;
    pNewScript->RegisterSelf();
}
