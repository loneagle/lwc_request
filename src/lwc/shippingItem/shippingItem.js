import {LightningElement, api} from 'lwc';
import getOrderShipmentStatus from '@salesforce/apex/ShippingItemController.getOrderShipmentStatus';
import Utils from "c/utility";

export default class ShippingItem extends LightningElement {
	@api recordId;
	shipmentStatus;
	spinnerEnabled = true;
	utility;

	connectedCallback() {
		this.utility = new Utils(this);
		this.updateStatus();
	}

	updateStatus() {
		if (!this.recordId) {
			this.spinnerEnabled = false;
			return;
		}

		getOrderShipmentStatus({ orderId: this.recordId })
			.then(result => {
				this.shipmentStatus = result;
			})
			.catch(error => {
				this.utility.handleError(error);
			})
			.finally(() => {
				this.spinnerEnabled = false;
			});
	}
}
