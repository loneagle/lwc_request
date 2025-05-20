public with sharing class ShippingItemController {
	@AuraEnabled
	public static String getOrderShipmentStatus(Id orderId) {
		try {
			Order orderRecord = [SELECT ShipmentNumber__c FROM Order WHERE Id = :orderId LIMIT 1];
			if (String.isBlank(orderRecord.ShipmentNumber__c)) {
				return 'Error - No shipment number found on this order';
			}
			return CalloutService.getStatus(orderRecord.ShipmentNumber__c);
		} catch (Exception e) {
			return 'Error - ' + e.getMessage();
		}
	}
}
