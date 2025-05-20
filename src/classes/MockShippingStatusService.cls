/* This houses a mock endpoint for Merz Salesforce Developer Interview Project
	* https://merzcommunities--tina.sandbox.my.salesforce-
sites.com/services/apexrest/mockShipmentStatus?trackingNumber=anystringwilldo
* */
@RestResource(UrlMapping='/mockShipmentStatus')
global class MockShippingStatusService {
	@HttpGet
	global static String doGet() {
		String trackingNumber = RestContext.request.params.get('trackingNumber');
		if (trackingNumber == null) {
			return 'Error - Must provide tracking number';
		}
		return 'Shipped- On Time';
	}
}