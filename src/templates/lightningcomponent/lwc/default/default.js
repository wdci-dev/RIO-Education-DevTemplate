/**
 * @Author 		WDCi ()
 * @Date 		Aug 2023
 * @group 		
 * @Description 
 * @changehistory
 */
import { LightningElement, api } from 'lwc';
import { promptInfo, promptError, promptWarning, promptSuccess } from 'c/toasterUtil';
import { getErrorMessage, logInfo, logError } from 'c/loggingUtil';
import { initCacheIdx } from 'c/lwcUtil';

import LOADING_LABEL from '@salesforce/label/c.Loading';
import ERROR_LABEL from '@salesforce/label/c.Error';
import REFRESH_LABEL from '@salesforce/label/c.Refresh';

//refresh module
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent, registerRefreshHandler, unregisterRefreshHandler } from 'lightning/refresh';

//Apex methods
import ctrlSample from '@salesforce/apex/REDU_<%= pascalCaseComponentName %>_LCTRL.sample';

export default class <%= pascalCaseComponentName %> extends LightningElement {
	
	//configurable attributes
    @api modalTitle;
    @api modalIconName;
	@api enableDebugMode = false;
	
	//internal attributes
	isScriptLoaded = false;
	isInitSuccess = false
	loadedLists = 0;
	
    //refresh handler
    refreshHandlerID;

    //local cache idx to force rerendering
    _cacheIdx;

    //wire attribute
    sampleWireResult;
    sampleResponse;

	//labels
	label = {
		LOADING_LABEL,
        ERROR_LABEL,
        REFRESH_LABEL
	}
	
	//js library module 'lodash', 'stringutil', 'moment', 'fullcalendar', 'fcmoment', 'jquery'
    modules = [];
	
	//library loader
    handleLibLoadSuccess(event) {
        this.isScriptLoaded = true;
        this.isInitSuccess = true;
        
    }

    //library loader
    handleLibLoadFail(event) {
        this.isScriptLoaded = true;
        this.isInitSuccess = false;
    }
	
	renderedCallback(){

    }

    connectedCallback(){
		this.refreshHandlerID = registerRefreshHandler(this, this.refreshData);
        this._cacheIdx = initCacheIdx();
	}
	
	disconnectedCallback() {
		unregisterRefreshHandler(this.refreshHandlerID);
	}
	
    /**
     * @description Refresh data
     */
    refreshData() {
        this.consoleLog('refreshData');
        
        //update the cacheIdx if you need to force the wire method to get new data from apex
        this._cacheIdx = initCacheIdx();

        refreshApex(this.sampleWireResult);

        return new Promise((resolve) => {
            resolve(true);
        });

    }

    /**
     * @description Sample wire method that invoke apex controller to retrieve data
     * @param cacheIdx This is to force the wire method to get new data from apex, you don't need to have the variable declare in the apex. Please remove if you don't need it.
     */
    @wire(ctrlSample, {
        param1: "$param1",
        cacheIdx: "$_cacheIdx"
    })
    wireSampleRecord(result) {
        
        this.sampleWireResult = result;
        this.sampleResponse = null;

        if (result.data) {
            this.sampleResponse = JSON.parse(result.data.responseData);
            this.consoleLog(this.sampleResponse, true);
        } else if (result.error) {
            promptError(this.label.ERROR_LABEL, getErrorMessage(result.error));
        }

    }

    /**
     * @descripton Sample method that invoke apex controller
     */
    samplePostMethod() {
        this.toggleSpinner(1);

        try {
            
            ctrlSample({
                
            })
            .then(saveResult => {
                this.toggleSpinner(-1);
                promptSuccess(this.label.SUCCESS_LABEL, 'any message');

                //we need to notify the lightning data service about the updated records
                if (saveResult.responseData) {
                    let recordIds = [];
                    for (let recId of JSON.parse(saveResult.responseData)) {
                        recordIds.push({recordId: recId});
                    }

                    notifyRecordUpdateAvailable(recordIds);
                }

            })
            .catch(error => {
                promptError(this.label.ERROR_LABEL, getErrorMessage(error));
                this.toggleSpinner(-1);
                
            })            

        } catch (error) {
            this.toggleSpinner(-1);
            promptError(this.label.ERROR_LABEL, getErrorMessage(error));
        }
    }

    /**
     * @description Sample handle refresh button
     */
    handleRefreshOnclick(event) {
        
    }

	get isLoading(){
        return this.loadedLists === 0 ? false : true;
    }
	
	toggleSpinner(loadCount){
        this.loadedLists += loadCount;

        if(this.loadedLists <= 0){
            this.loadedLists = 0;
        }
    }
	
	consoleLog(anything, isJson){
        if(this.enableDebugMode){
            logInfo('<%= pascalCaseComponentName %>', anything, this.enableDebugMode, isJson);
        }
    }
	
}