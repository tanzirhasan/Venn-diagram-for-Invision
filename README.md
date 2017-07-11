# Venn-diagram-for-Invision


Select FYActivity
,Case when EncounterType = 'Admit' and PtType in ('G','M','S') then 'Admit-SNF'
       when EncounterType = 'Admit' and PtType not in ('G','M','S') then'Admit-Acute'
       when EncounterType='Outpatient' and HospSvc in ('Rad', 'Lab') then 'Outpt-Diagnostic'
       when EncounterType='Outpatient' and Clinic in ('URGCARE') then 'Outpt-ZSFG Urgent Care'
       when EncounterType='Outpatient' and PtType in ('Y') then 'Outpt-COPC'
       when EncounterType='ED' then 'ED'
       Else 'Outpt-ZSFG' end
       ,count (distinct activemrn)
FROM [Invision].[sfhn].[tblEncounter]
                    WHERE FYActivity = 'FY1516'
GROUP BY
FYActivity
,Case when EncounterType = 'Admit' and PtType in ('G','M','S') then 'Admit-SNF'
       when EncounterType = 'Admit' and PtType not in ('G','M','S') then'Admit-Acute'
       when EncounterType='Outpatient' and HospSvc in ('Rad', 'Lab') then 'Outpt-Diagnostic'
       when EncounterType='Outpatient' and Clinic in ('URGCARE') then 'Outpt-ZSFG Urgent Care'
       when EncounterType='Outpatient' and PtType in ('Y') then 'Outpt-COPC'
       when EncounterType='ED' then 'ED'
       Else 'Outpt-ZSFG' end
