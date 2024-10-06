public with sharing class LeadStatusBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Lead Status Batch Start');
        String query;

        try {
            query = 'SELECT Id, Status, LastModifiedDate FROM Lead WHERE Status = \'Closed - Not Converted\' AND LastModifiedDate < YESTERDAY';

            return Database.getQueryLocator(query);
        } catch (Exception e) {
            System.debug('Error : '       + e.getMessage());
            System.debug('Line Number : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        System.debug('Lead Status Batch Excute');
        List<Lead> deleteLeadList = new List<Lead>();
        System.debug('scope : ' + scope);

        try {
            for(Lead lead : scope) {
                deleteLeadList.add(lead);
            }

            if(!deleteLeadList.isEmpty()) {
                delete deleteLeadList;
            }
        } catch (Exception e) {
            System.debug('Error : '       + e.getMessage());
            System.debug('Line Number : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());            
        }
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Lead Status Batch Finish');
    }
}