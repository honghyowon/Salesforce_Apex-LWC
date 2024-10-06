import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

import opptyConvertToOrder from '@salesforce/apex/OpptyConvertToOrderController.opptyConvertToOrder';

export default class OpptyConvertToOrder extends LightningElement {
  @api recordId;
  isLoading = false;

  handleClickConfirm() {
    this.isLoading = true;

    opptyConvertToOrder({
      recordId : this.recordId
    })
    .then(result => {
      console.log('RESULT', result);

      if(result == 'SUCCESS') {
        this.isLoading = false;
        this.dispatchEvent(
          new ShowToastEvent({
            title : 'Convert Success',
            message : 'Order가 생성되었습니다.',
            variant : 'success',
          }),
        );
        this.handleClickClose();
      } else if(result == 'FAIL') {
        this.isLoading = false;
        this.dispatchEvent(
          new ShowToastEvent({
            title : 'Convert Failed',
            message : 'Order 생성이 실패하였습니다.',
            variant : 'error',
          }),
        );
        this.handleClickClose();
      } else {
        this.isLoading = false;
        this.dispatchEvent(
          new ShowToastEvent({
            title : 'Convert Failed',
            message : 'Closed Won인 경우에만 Order 생성이 가능합니다.',
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

  handleClickClose() {
    const closeAction = new CloseActionScreenEvent();
    this.dispatchEvent(closeAction);
  }
}