/**
 * @author      WDCi ()
 * @date        Jan 2024
 * @group       
 * @description 
 * @changehistory
 * ISS-XXXXXX dd-mm-yyyy name - description
 */

/** Please note that the template contains 2 parts. Please remove the irrelevant parts. **/
/** Part 1: Template for lightning web component controller **/
/** Part 2: Template for trigger TDTM **/

/*---------------------- Part 1 -----------------------*/
public with sharing class <%= apiName %> {

    /**
     * @description The description
     * @param param The description
     * @return REDU_LightningResponse
     */
    @AuraEnabled(cacheable=true)
    public static REDU_LightningResponse getMethodName(String param){

        try {
            //your logic here

            return new REDU_LightningResponse(true, REDU_LightningResponse.SUCCESS, JSON.serialize(responseData));

        } catch (QueryException qex) {
            REDU_Logging_UTIL.debug(qex);

            String errorMsg = REDU_SObjectSecurityEnforcer.handleQueryException(qex, false);
            throw REDU_Exception_UTIL.auraException(errorMsg);

        } catch (Exception exp) {
            REDU_Logging_UTIL.debug(exp);

            throw REDU_Exception_UTIL.auraException(exp.getMessage());
        }
    }

    /**
     * @description The description
     * @param param The description
     * @return REDU_LightningResponse
     */
    @AuraEnabled
    public static REDU_LightningResponse saveMethodName(String param){

        Savepoint sp = Database.setSavePoint();

        try {
            //your logic here

            return new REDU_LightningResponse(true, REDU_LightningResponse.SUCCESS, JSON.serialize(responseData));

        } catch (QueryException qex) {
            Database.rollback(sp);

            REDU_Logging_UTIL.debug(qex);

            String errorMsg = REDU_SObjectSecurityEnforcer.handleQueryException(qex, false);
            throw REDU_Exception_UTIL.auraException(errorMsg);

        } catch (Exception exp) {
            Database.rollback(sp);
            
            REDU_Logging_UTIL.debug(exp);
            
            throw REDU_Exception_UTIL.auraException(exp.getMessage());
        }
    }
}

/*---------------------- Part 2 -----------------------*/
global inherited sharing class <%= apiName %> extends hed.TDTM_Runnable {
    
	public override DmlWrapper run(List<SObject> newList, List<SObject> oldList, hed.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        hed.TDTM_Runnable.dmlWrapper dmlWrapper = new hed.TDTM_Runnable.DmlWrapper();

        //TODO change the SObject
        List<SObject> workingList = new List<SObject>();
        if(triggerAction == hed.TDTM_Runnable.Action.BeforeInsert){
            //TODO custom development logic here
        }else if(triggerAction == hed.TDTM_Runnable.Action.BeforeUpdate){
            //TODO custom development logic here
        }else if (triggerAction == hed.TDTM_Runnable.Action.AfterInsert) {
            //TODO custom development logic here
        }else if(triggerAction == hed.TDTM_Runnable.Action.AfterUpdate){
            //TODO custom development logic here
        }

        if(!workingList.isEmpty()){
            doSomething(workingList);
        }

        return dmlWrapper;
    }

    /**
     * @description
     * @param
     * @return void
     */
    private void doSomething(List<SObject> objList) {
        //TODO write your logic here
    }
}