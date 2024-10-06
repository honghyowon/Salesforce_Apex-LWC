trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete) {
  if (Trigger.isDelete && Trigger.isBefore) {
    System.debug('Account Before Delete Trigger.');
    
    for(Account acc : Trigger.old) {
      if(acc.Account_Status__c != '잠재고객') {
        acc.addError('잠재고객인 고객사만 삭제 가능합니다. 관리자에게 문의해주세요.');
      }
    }
  }
}