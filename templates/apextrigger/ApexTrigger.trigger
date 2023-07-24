/**
 * @author      WDCi ()
 * @date        Aug 2023
 * @group       Trigger
 * @description Trigger for <%= sobject %>
 * @changehistory
 * 
 */
trigger <%= triggername %> on <%= sobject %> (before insert, before update, before delete, 
    after insert, after update, after delete, after undelete 
){
    hed.TDTM_Global_API.run(Trigger.isBefore, Trigger.isAfter, 
        Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUnDelete, 
        Trigger.new, Trigger.old, 
        Schema.Sobjecttype.<%= sobject %>
    );
}