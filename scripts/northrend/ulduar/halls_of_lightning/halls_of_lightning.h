/* Copyright (C) 2006 - 2011 ScriptDev2 <http://www.scriptdev2.com/>
 * This program is free software licensed under GPL version 2
 * Please see the included DOCS/LICENSE.TXT for more information */

#ifndef DEF_HALLS_OF_LIGHTNING_H
#define DEF_HALLS_OF_LIGHTNING_H

enum
{
    MAX_ENCOUNTER           = 4,

    TYPE_BJARNGRIM          = 0,
    TYPE_VOLKHAN            = 1,
    TYPE_IONAR              = 2,
    TYPE_LOKEN              = 3,
    TYPE_STRUCK             = 4,
    TYPE_TIMELY             = 5,

    NPC_BJARNGRIM           = 28586,
    NPC_VOLKHAN             = 28587,
    NPC_GOLEM               = 28681,
    NPC_IONAR               = 28546,
    NPC_LOKEN               = 28923,

    GO_VOLKHAN_DOOR         = 191325,                       //_doors07
    GO_IONAR_DOOR           = 191326,                       //_doors05
    GO_LOKEN_DOOR           = 191324,                       //_doors02
    GO_LOKEN_THRONE         = 192654,

    ACHIEV_START_LOKEN_ID   = 20384,
    ACHIEV_STRUCK           = 6835,
    ACHIEV_SHATTER          = 7321,
    ACHIEV_TIMELY           = 7144,
};

class MANGOS_DLL_DECL instance_halls_of_lightning : public ScriptedInstance
{
    public:
        instance_halls_of_lightning(Map* pMap);

        void Initialize();

        void OnCreatureCreate(Creature* pCreature);
        void OnCreatureDeath(Creature* pCreature);
        void OnCreatureEnterCombat(Creature* pCreature);
        void OnObjectCreate(GameObject* pGo);

        void SetData(uint32 uiType, uint32 uiData);
        uint32 GetData(uint32 uiType);
        bool CheckAchievementCriteriaMeet(uint32 uiCriteriaId, Player const* pSource, Unit const* pTarget, uint32 uiMiscValue1 /* = 0*/);

        const char* Save() { return m_strInstData.c_str(); }
        void Load(const char* chrIn);

    private:
        uint32 m_auiEncounter[MAX_ENCOUNTER];
        std::string m_strInstData;
        bool m_bEmpowered;
        uint32 m_uiGolemsKilled;
        bool m_bTimely;
};

#endif
