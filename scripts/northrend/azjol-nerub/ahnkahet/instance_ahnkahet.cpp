/* Copyright (C) 2006 - 2011 ScriptDev2 <https://scriptdev2.svn.sourceforge.net/>
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
SDName: instance_ahnkahet
SD%Complete: 80%
SDComment:
SDCategory: Ahn'kahet
EndScriptData */

#include "precompiled.h"
#include "ahnkahet.h"

instance_ahnkahet::instance_ahnkahet(Map* pMap) : ScriptedInstance(pMap),
    m_uiDevicesActivated(0)
{
    Initialize();
}
void instance_ahnkahet::Initialize()
{
    memset(&m_auiEncounter, 0, sizeof(m_auiEncounter));

    for (uint8 i = 0; i < MAX_SPECIAL_ACHIEV_CRITS; ++i)
        m_abAchievCriteria[i] = false;
}

void instance_ahnkahet::OnCreatureCreate(Creature* pCreature)
{
    switch(pCreature->GetEntry())
    {
        case NPC_ELDER_NADOX:
        case NPC_JEDOGA_SHADOWSEEKER:
        case NPC_TALDARAM:
            break;
        case NPC_TWILIGHT_INITIATE:
            m_lTwilightInitiate.push_back(pCreature->GetObjectGuid());
            break;
        default:
            return;
    }
    m_mNpcEntryGuidStore[pCreature->GetEntry()] = pCreature->GetObjectGuid();
}
	
void instance_ahnkahet::OnCreatureDeath(Creature *pCreature)	
{
    switch(pCreature->GetEntry())
    {
    case NPC_AHNKAHAR_GUARDIAN:
        if (GetData(TYPE_NADOX) == IN_PROGRESS)
            SetSpecialAchievementCriteria(TYPE_RESPECT_YOUR_ELDERS, false);
        break;
    case NPC_TWILIGHT_VOLUNTEER:
        if (GetData(TYPE_JEDOGA) == IN_PROGRESS)
            SetSpecialAchievementCriteria(TYPE_VOLUNTEER_WORK, false);
        break;
    default:
        break;
    }
}	

void instance_ahnkahet::OnObjectCreate(GameObject* pGo)
{
     switch(pGo->GetEntry())
    {
        case GO_DOOR_TALDARAM:
            if (m_auiEncounter[TYPE_TALDARAM] == DONE)
                DoUseDoorOrButton(GO_DOOR_TALDARAM);
            break;
        case GO_ANCIENT_DEVICE_L:
            if (m_auiEncounter[TYPE_TALDARAM] == NOT_STARTED)
                pGo->RemoveFlag(GAMEOBJECT_FLAGS, GO_FLAG_NO_INTERACT);
            break;
        case GO_ANCIENT_DEVICE_R:
            if (m_auiEncounter[TYPE_TALDARAM] == NOT_STARTED)
                pGo->RemoveFlag(GAMEOBJECT_FLAGS, GO_FLAG_NO_INTERACT);
            break;
        case GO_VORTEX:
            if (m_auiEncounter[TYPE_TALDARAM] != NOT_STARTED)
                DoUseDoorOrButton(GO_VORTEX);
            break;
        default:
            return;
    }
    m_mGoEntryGuidStore[pGo->GetEntry()] = pGo->GetObjectGuid();
}
void instance_ahnkahet::SetData(uint32 uiType, uint32 uiData)
{
    switch(uiType)
    {
        case TYPE_NADOX:
            m_auiEncounter[uiType] = uiData;
            break;
        case TYPE_TALDARAM:
            if (uiData == SPECIAL)
            {
                if (m_uiDevicesActivated < 2)
                    ++m_uiDevicesActivated;

                if (m_uiDevicesActivated == 2)
                {
                    if (Unit* pTaldaram = GetSingleCreatureFromStorage(NPC_TALDARAM))
                    {
                        pTaldaram->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                        pTaldaram->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PASSIVE);
                    }
                    m_auiEncounter[uiType] = uiData;
                    DoUseDoorOrButton(GO_VORTEX);
                }
            }
            if (uiData == DONE)
            {
                m_auiEncounter[uiType] = uiData;
                DoUseDoorOrButton(GO_DOOR_TALDARAM);
            }
            break;
        case TYPE_JEDOGA:
            m_auiEncounter[uiType] = uiData;
            break;
        case TYPE_VOLAZJ:
            m_auiEncounter[uiType] = uiData;
            break;
        case TYPE_AMANITAR:
            m_auiEncounter[uiType] = uiData;
            break;
        default:
            error_log("SD2: Instance Ahn'Kahet: ERROR SetData = %u for type %u does not exist/not implemented.",uiType,uiData);
            break;
    }

    if (uiData == DONE)
    {
        OUT_SAVE_INST_DATA;

        std::ostringstream saveStream;
        saveStream << m_auiEncounter[0] << " " << m_auiEncounter[1] << " " << m_auiEncounter[2] << " " << m_auiEncounter[3]
            << " " << m_auiEncounter[4];

        strInstData = saveStream.str();

        SaveToDB();
        OUT_SAVE_INST_DATA_COMPLETE;
    }
}

void instance_ahnkahet::Load(const char* chrIn)
{
    if (!chrIn)
    {
        OUT_LOAD_INST_DATA_FAIL;
        return;
    }

    OUT_LOAD_INST_DATA(chrIn);

    std::istringstream loadStream(chrIn);
    loadStream >> m_auiEncounter[0] >> m_auiEncounter[1] >> m_auiEncounter[2] >> m_auiEncounter[3] >> m_auiEncounter[4];

    for(uint8 i = 0; i < MAX_ENCOUNTER; ++i)
    {
        if (m_auiEncounter[i] == IN_PROGRESS)
            m_auiEncounter[i] = NOT_STARTED;
    }

    OUT_LOAD_INST_DATA_COMPLETE;
}
uint32 instance_ahnkahet::GetData(uint32 uiType)
{
    switch(uiType)
    {
        case TYPE_NADOX:
            return m_auiEncounter[0];
        case TYPE_TALDARAM:
            return m_auiEncounter[1];
        case TYPE_JEDOGA:
            return m_auiEncounter[2];
        case TYPE_VOLAZJ:
            return m_auiEncounter[3];
        case TYPE_AMANITAR:
            return m_auiEncounter[4];
    }
    return 0;
}
 
bool instance_ahnkahet::CheckAchievementCriteriaMeet(uint32 uiCriteriaId, Player const* pSource, Unit const* pTarget, uint32 uiMiscValue1 /* = 0*/)
{
    switch (uiCriteriaId)
    {
        case ACHIEV_CRITERIA_VOLUNTEER_WORK:
            return m_abAchievCriteria[TYPE_VOLUNTEER_WORK];
        case ACHIEV_CRITERIA_RESPECT_YOUR_ELDERS:
            return m_abAchievCriteria[TYPE_RESPECT_YOUR_ELDERS];
        default:
            return 0;
    }
}

void instance_ahnkahet::SetSpecialAchievementCriteria(uint32 uiType, bool bIsMet)
{
    if (uiType < MAX_SPECIAL_ACHIEV_CRITS)
        m_abAchievCriteria[uiType] = bIsMet;
}

InstanceData* GetInstanceData_instance_ahnkahet(Map* pMap)
{
    return new instance_ahnkahet(pMap);
}

void AddSC_instance_ahnkahet()
{
    Script* pNewScript;

    pNewScript = new Script;
    pNewScript->Name = "instance_ahnkahet";
    pNewScript->GetInstanceData = &GetInstanceData_instance_ahnkahet;
    pNewScript->RegisterSelf();
}
