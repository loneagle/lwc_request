import {LightningElement} from 'lwc';
import getStatus from '@salesforce/apex/ShippingItemController.getStatus';

export default class ShippingItem extends LightningElement {
	shipmentStatus;
	spinnerEnabled = true;

	connectedCallback() {
		this.updateStatus();
	}
	
	updateStatus() {
		getStatus().then(result => {
			this.shipmentStatus = result;
		}).catch(error => {
			console.log(error);
		}).finally(() => {
			this.spinnerEnabled = false;
		})
	}
}