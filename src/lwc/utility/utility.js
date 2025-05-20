import { ShowToastEvent } from "lightning/platformShowToastEvent";
let mainObj;

export default class Utility {

	constructor(superMain) {
		mainObj = superMain;
	}

	showToast(title, variant, message, messageData) {
		const toastEvent = new ShowToastEvent({
			title: title,
			variant: variant,
			message: message,
			messageData: messageData
		});
		mainObj.dispatchEvent(toastEvent);
	}

	handleError(error) {
		let errorMessage = "Unknown error";
		if (error.body && error.body.pageErrors) {
			errorMessage = ' ';
			error.body.pageErrors.forEach((pageError) => {
				errorMessage += ' ' + pageError.message;
			});
		}
		if (error.body && error.body.message) {
			errorMessage = error.body.message;
		}

		this.showToast("Error!", "error", errorMessage);
	}
}
