# Shipment Tracking for Salesforce

This project provides a Lightning Web Component (LWC) that displays shipment tracking information on Order record pages. It retrieves shipment status from an external API using the Order's ShipmentNumber__c field.

## Prerequisites

Before installing this package, ensure you have:

1. Salesforce org with API access enabled
2. Order object enabled in your org
3. Permission to create custom fields on the Order object
4. Permission to deploy Apex classes and Lightning Web Components
5. Remote Site Setting for the external API endpoint (if using your own endpoint)

## Installation Options

### Option 1: Deploy using Salesforce CLI

1. Clone this repository to your local machine
2. Authenticate to your Salesforce org:
   ```
   sfdx auth:web:login -a YourOrgAlias
   ```
3. Deploy the components to your org:
   ```
   sfdx force:source:deploy -p src -u YourOrgAlias
   ```

### Option 2: Deploy using Workbench

1. Download this repository as a ZIP file
2. Extract the ZIP file
3. Create a new ZIP file containing only the `src` directory
4. Log in to Workbench (https://workbench.developerforce.com)
5. Navigate to Migration > Deploy
6. Select the ZIP file you created
7. Choose "Single Package" and click "Next"
8. Review the components to be deployed and click "Deploy"

### Option 3: Manual Installation

If you prefer to install components manually:

1. Create a custom text field named `ShipmentNumber__c` on the Order object with a length of 255 characters and marked as unique
2. Create the Apex classes:
   - CalloutService.cls
   - ShippingItemController.cls
   - ShippingItemControllerTest.cls
3. Create the Lightning Web Components:
   - shippingItem
   - utility
4. Create the Shipment_User permission set

## Post-Installation Configuration

1. Assign the Shipment_User permission set to users who need access to the shipment tracking functionality:
   ```
   sfdx force:user:permset:assign -n Shipment_User -u YourOrgAlias
   ```

2. Add the Shipment Tracking component to Order record pages:
   - Navigate to an Order record
   - Click the gear icon and select "Edit Page"
   - Drag the "Order Shipment Tracking" component to the desired location on the page
   - Save the page

3. Configure Remote Site Setting (if needed):
   - If you're using your own endpoint instead of the default one, navigate to Setup > Security > Remote Site Settings
   - Create a new Remote Site Setting with the URL of your endpoint

## Testing the Installation

1. Run the Apex tests to verify the installation:
   ```
   sfdx force:apex:test:run -n ShippingItemControllerTest -u YourOrgAlias -r human
   ```

2. Create a test Order with a ShipmentNumber__c value
3. View the Order record page to see the Shipment Tracking component
4. Click the "Refresh Status" button to retrieve the shipment status

## Customization

If you need to use a different endpoint for shipment status:

1. Modify the `test` named credential for changing your endpoint
2. Ensure your endpoint returns a string representing the shipment status
3. Update any authentication requirements in the CalloutService class

## Troubleshooting

- If the component doesn't appear on the Order page, ensure the component is added to the page layout and the user has the Shipment_User permission set
- If the status doesn't update, check that the ShipmentNumber__c field has a valid value and the external endpoint is accessible
- For callout issues, verify that the Remote Site Setting is configured correctly
