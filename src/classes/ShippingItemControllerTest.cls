@IsTest
private class ShippingItemControllerTest {
    @TestSetup
    static void setupTestData() {
        Order testOrder = new Order(
            AccountId = createTestAccount().Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            ShipmentNumber__c = 'TEST-SHIPMENT-123'
        );

        // Create a test Order without ShipmentNumber__c
        Order testOrderNoShipment = new Order(
            AccountId = createTestAccount().Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        insert new List<Order>{ testOrder, testOrderNoShipment };
    }

    @IsTest
    static void testGetStatusSuccess() {
        // Given
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'Shipped- On Time'));

        // When
        Test.startTest();
        String result = CalloutService.getStatus('anystringwilldo');
        Test.stopTest();

        // Then
        Assert.areEqual('Shipped- On Time', result, 'The status should match the expected value from the HTTP response');
    }

    @IsTest
    static void testGetStatusError() {
        // Given
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(400, 'Bad Request'));

        // When
        Test.startTest();
        String result = CalloutService.getStatus('123');
        Test.stopTest();

        // Then
        Assert.areEqual('Error - HTTP Status: 400', result, 'Should return error message with HTTP status code');
    }

    @IsTest
    static void testGetStatusException() {
        // Given
        Test.setMock(HttpCalloutMock.class, new MockHttpExceptionGenerator());

        // When
        Test.startTest();
        String result = CalloutService.getStatus('');
        Test.stopTest();

        // Then
        Assert.isTrue(result.startsWith('Error - '), 'Should return error message for exception');
        Assert.isTrue(result.contains('Simulated callout exception'), 'Error message should contain the exception message');
    }

    @IsTest
    static void testGetOrderShipmentStatusSuccess() {
        // Given
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'Shipped- On Time'));
        Order testOrder = [SELECT Id FROM Order WHERE ShipmentNumber__c = 'TEST-SHIPMENT-123' LIMIT 1];

        // When
        Test.startTest();
        String result = ShippingItemController.getOrderShipmentStatus(testOrder.Id);
        Test.stopTest();

        // Then
        Assert.areEqual('Shipped- On Time', result, 'The status should match the expected value from the HTTP response');
    }

    @IsTest
    static void testGetOrderShipmentStatusNoShipmentNumber() {
        // Given
        Order testOrderNoShipment = [SELECT Id FROM Order WHERE ShipmentNumber__c = NULL LIMIT 1];

        // When
        Test.startTest();
        String result = ShippingItemController.getOrderShipmentStatus(testOrderNoShipment.Id);
        Test.stopTest();

        // Then
        Assert.areEqual('Error - No shipment number found on this order', result, 'Should return error message for missing shipment number');
    }

    @IsTest
    static void testGetOrderShipmentStatusInvalidOrderId() {
        // Given
        Id invalidOrderId = '801000000000000AAA'; // Invalid Order Id format

        // When
        Test.startTest();
        String result = ShippingItemController.getOrderShipmentStatus(invalidOrderId);
        Test.stopTest();

        // Then
        Assert.isTrue(result.startsWith('Error - '), 'Should return error message for invalid order id');
    }

    private static Account createTestAccount() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        return testAccount;
    }

    // Mock HTTP response class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private final Integer statusCode;
        private final String body;

        public MockHttpResponseGenerator(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setBody(body);
            return response;
        }
    }

    // Mock HTTP response class that throws an exception
    private class MockHttpExceptionGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            throw new CalloutException('Simulated callout exception');
        }
    }
}
