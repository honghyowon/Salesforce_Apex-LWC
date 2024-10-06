public with sharing class ChangeStatusModalController_Sample {
    @AuraEnabled // Aura, LWC의 Javascript 와 Class의 Method를 연결시킬 수 있게 해주는 Annotation
    public static String updateAccountStatus(String recordId){ // return 타입이 String이고 Javascript를 통해 받는 인자가 String recordId가 사용되는 Method
        String result;

        try {
            Account acc = [SELECT Id, Account_Status__c, CreatedDate FROM Account WHERE Id =: recordId LIMIT 1];
            // SOQL문 - WHERE Id를 사용하여 현재 record의 필드값들을 조회

            Datetime currentTime = Datetime.now(); // 현재 시간을 불러오는 함수
            Datetime createDate = acc.CreatedDate; // Account의 해당 record가 생성된 시간
            Datetime threeHoursLater = createDate.addHours(3); // 3시간 차이를 확인하기 위한 변수

            if(acc.Account_Status__c == '신규고객' && currentTime >= threeHoursLater) {
                acc.Account_Status__c = '기존고객'; // 해당 필드의 '기존고객'을 넣음 

                update acc; // 해당 record를 update

                result = 'SUCCESS'; // return 타입이 String이므로 update가 성공하면 'SUCCESS' 반환.
            } else {
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