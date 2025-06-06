public with sharing class CalloutService {
	public static String getStatus(String trackingNumber) {
		// Make HTTP GET request to the mock shipment status endpoint
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:testnamed?trackingNumber=' + EncodingUtil.urlEncode(trackingNumber, 'UTF-8'));
		request.setMethod('GET');

		try {
			HttpResponse response = http.send(request);
			if (response.getStatusCode() == 200) {
				return response.getBody();
			} else {
				return 'Error - HTTP Status: ' + response.getStatusCode();
			}
		} catch (Exception e) {
			return 'Error - ' + e.getMessage();
		}
	}
}