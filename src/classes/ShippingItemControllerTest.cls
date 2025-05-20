@IsTest
private class ShippingItemControllerTest {
    @IsTest
    static void testGetStatusSuccess() {
        // Given
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'Shipped- On Time'));

        // When
        Test.startTest();
        String result = ShippingItemController.getStatus('anystringwilldo');
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
        String result = ShippingItemController.getStatus('123');
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
        String result = ShippingItemController.getStatus('');
        Test.stopTest();

        // Then
        Assert.isTrue(result.startsWith('Error - '), 'Should return error message for exception');
        Assert.isTrue(result.contains('Simulated callout exception'), 'Error message should contain the exception message');
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
