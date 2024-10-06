import { LightningElement, track } from 'lwc';

import translateInfo from '@salesforce/apex/PapagoController.translateInfo';

export default class PapagoComponent extends LightningElement {
  @track engText;
  isLoading = false;

  handleTranslateBtnClick() {
    try {
      this.isLoading = true;
      let text = this.template.querySelector('[data-id="translateKor"]').value;

      translateInfo({
        question : text
      })
      .then(result => {
        this.engText = result;
        this.isLoading = false;
      })
      .catch(error => {
        console.log('ERROR', error);
        this.isLoading = false;
      });
    } catch(e) {
      console.log('ERROR', e);
      this.isLoading = false;
    }
  }
}