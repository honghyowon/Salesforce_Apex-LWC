public with sharing class UpdateStatusModalController {

    @AuraEnabled
    public static string updateAccountStatus(String recordId){
        String result;

        try {
            Account acc = [SELECT Id, Account_Status__c, CreatedDate FROM Account WHERE Id =: recordId LIMIT 1];
            
            Datetime currentTime = Datetime.now();
            Datetime createDate = acc.CreatedDate;
            Datetime threeHoursLater = createDate.addHours(3);

            if(acc.Account_Status__c == '신규고객' && currentTime >= threeHoursLater){
                acc.Account_Status__c = '기존고객';
                
                update acc;

                result = 'SUCCESS';
            }else {
                result = 'FAIL';
            }

        } catch (Exception e) {
            System.debug('Error : '       + e.getMessage());
            System.debug('Line Number : ' + e.getLineNumber());

            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
}