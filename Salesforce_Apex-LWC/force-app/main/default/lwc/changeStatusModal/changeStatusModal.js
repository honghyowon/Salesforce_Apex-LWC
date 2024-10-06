import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Toast를 띄우기 위한 기능
import { CloseActionScreenEvent } from 'lightning/actions'; // Modal close를 하기위한 기능

import updateAccountStatus from '@salesforce/apex/ChangeStatusModalController.updateAccountStatus'; // class와 JS 연결

export default class ChangeStatusModal_Sample extends LightningElement {
  @api recordId; // 현재 사용자가 사용하는 record의 Id를 가져옴
  isLoading = false;

  handleClickConfirm(event) {
    this.isLoading = true;

    updateAccountStatus({ // import한 class 사용
      recordId : this.recordId // public static String updateAccountStatus(String recordId) 부분에 String recordId에 전달 할 값 설정 
    })
    .then(result => { // class의 Method가 작동을 맞치고 result를 반환
      console.log('result', result); // Method의 return 타입에따라 달라지는 result 값 확인 
      if(result == 'SUCCESS') {
        this.isLoading = false;
        this.dispatchEvent( // updateAccountStatus()의 String return 값이 SUCCESS이면 작동하는 Toast함수 실행
          new ShowToastEvent({
            title : 'Update Success',
            message : '고객 상태가 변경되었습니다.',
            variant : 'success',
          }),
        );
        this.handleClickClose(); // 미리 만들어둔 close 함수를 실행시켜 모달창을 닫음
      } else {
        this.isLoading = false;
        this.dispatchEvent(
          new ShowToastEvent({
            title : 'Update Failed',
            message : '신규고객만 고객 상태를 변경 할 수 있습니다.',
            variant : 'error',
          }),
        );

        this.handleClickClose();
      }
    }).catch(error => {
      console.log('ERROR', error);
      this.isLoading = false;
    });
  }

  handleClickClose(event) {
    const closeAction = new CloseActionScreenEvent();
    this.dispatchEvent(closeAction);
  }
}