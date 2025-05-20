import {LightningElement, api} from 'lwc';
import getOrderShipmentStatus from '@salesforce/apex/ShippingItemController.getOrderShipmentStatus';

export default class ShippingItem extends LightningElement {
	@api recordId;
	shipmentStatus;
	spinnerEnabled = true;

	connectedCallback() {
		this.updateStatus();
	}

	updateStatus() {
		if (!this.recordId) {
			this.shipmentStatus = 'Error - No Order Id provided';
			this.spinnerEnabled = false;
			return;
		}

		getOrderShipmentStatus({ orderId: this.recordId })
			.then(result => {
				this.shipmentStatus = result;
			})
			.catch(error => {
				console.error('Error retrieving shipment status:', error);
				this.shipmentStatus = 'Error retrieving shipment status';
			})
			.finally(() => {
				this.spinnerEnabled = false;
			});
	}
}
