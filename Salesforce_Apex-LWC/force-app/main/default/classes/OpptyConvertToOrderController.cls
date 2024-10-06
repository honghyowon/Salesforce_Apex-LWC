public with sharing class OpptyConvertToOrderController {
    @AuraEnabled
    public static String opptyConvertToOrder(String recordId) {
        String result;

        try {

            Opportunity oppty = [SELECT Id, AccountId, StageName FROM Opportunity WHERE Id =: recordId LIMIT 1];

            if(oppty.StageName.equals('Closed Won')) {
                Order ord = new Order();
                ord.AccountId = oppty.AccountId;
                ord.OpportunityId = oppty.Id;
                ord.Status = 'Draft';
                ord.EffectiveDate = System.today();

                insert ord;
            } else {
                result = 'Not Won';
            }
            result = 'SUCCESS';
        } catch (Exception e) {
            System.debug('Error : '       + e.getMessage());
            System.debug('Line Number : ' + e.getLineNumber());

            result = 'FAIL';
        }

        return result;
    }
}