# Salesforce Crypto Coin Search & Save

This project demonstrates how to build a Salesforce solution using Lightning Web Components (LWC), Apex callouts to an external API (like CoinMarketCap), and a Flow embedded in a modal to search for cryptocurrency data and save it as a custom record in Salesforce.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Components](#components)
- [Error Handling](#error-handling)
- [Testing](#testing)

## Project Overview

The project provides a Lightning Web Component that allows users to search for a cryptocurrency by its symbol. It makes a secure callout to an external API (intended for CoinMarketCap) to fetch current market data. The fetched data is displayed in the component. Users can then click a button to open a modal containing a Salesforce Flow, which guides them through saving the coin's data to a custom object in the Salesforce org.

## Features

* Search for cryptocurrency data by symbol (e.g., BTC, ETH).
* Display key data points: Name, Symbol, Price (USD), Market Cap (USD), CoinMarketCap URL.
* Secure callout to an external API using Named Credentials.
* Save fetched coin data to a custom Salesforce object via an embedded Screen Flow in a modal.
* Basic error handling for API callouts and Flow completion/faults.
* Utilizes Custom Metadata Type for configurable API base URL.

## Prerequisites

Before deploying and using this project, you need:

* A Salesforce Org (Developer Edition, Sandbox, or Enterprise/Unlimited Edition with necessary permissions).
* Admin access to configure Named Credentials, Custom Metadata, and deploy code/Flows.
* Access to an external cryptocurrency data API (like CoinMarketCap Pro API). You will need an API Key for this service.
* Salesforce DX (SFDX) Command Line Interface installed and authenticated to your org.
* A custom object in your Salesforce org to store the coin data (e.g., `Coin__c`). This object must have fields to store the Name, Symbol, Price, Market Cap, and URL.

## Installation

1. **Clone the Repository:**

   ```bash
   git clone [https://github.com/victorino3/MArketCapApi-APEX-and-LWC]
   ```
2. **Connect to Your Org:** Authenticate your SFDX CLI to your target Salesforce org.

   ```bash
   sf org login web -a my-org-alias
   ```

   (Replace `my-org-alias` with a desired alias)
3. **Deploy Source Code:** Deploy the metadata to your org.

   ```bash
   sf project deploy start -d force-app/main/default
   ```

## Configuration

After deployment, perform the following configuration steps in your Salesforce org:

1. **Create Named Credential:**

   * Go to Setup -> Security -> **Named Credentials**.
   * Click **New Legacy** (or New if using External Credentials).
   * **Label:** `CoinMarketEndPoint`
   * **Name:** `CoinMarketEndPoint` (Must match the `callout:` name in Apex).
   * **URL:** Enter the base URL for the CoinMarketCap API (e.g., `https://pro-api.coinmarketcap.com`).
   * Configure the **Authentication** method as required by your CoinMarketCap plan (usually API Key). If using API Key in the header, you might need to use External Credentials or add a Header parameter directly in the Apex code (less secure than Named/External Credentials). **Named Credentials are the recommended secure method.**
   * Save.
2. **Create Custom Metadata Record:**

   * Go to Setup -> Custom Code -> Custom Metadata Types -> `CoinMarketCapUrl` -> **Manage Records**.
   * Click **New**.
   * **Label:** `CoinMarketCap URL` (or similar)
   * **Developer Name:** `CoinMarketCapURL` (Must match the name used in the Apex query).
   * **Coin Market Cap Url (c):** Enter the base URL for the CoinMarketCap *website's currency pages* (e.g., `https://coinmarketcap.com/currencies/`). Ensure it ends with a slash `/`. This is used to construct the link in the LWC display.
   * Save.
3. **Configure Custom Object:**

   * Ensure your custom object (e.g., `Crypto_Coin__c`) exists with appropriate fields (Name, Symbol, Price, Market Cap, CoinMarketCap URL).
   * Verify the API names of these fields match what your Flow expects.
4. **Configure Flow (`Create_Coin_Record`):**

   * Go to Setup -> Flows -> **Create_Coin_Record**.
   * Open the Flow in Flow Builder.
   * Verify the **Input Variables** (`input_CoinName`, `input_CoinSymbol`, `input_PriceUSD`, `input_MarketCapUSD`, `input_CoinMarketCapURL`) exist and are correctly mapped to the data elements (like a Create/Update Records element) that interact with your custom object.
   * **Important:** Configure **Fault Paths** from your Create/Update elements to handle errors. On the fault paths, use an Assignment element to set an **Output Variable** (e.g., `output_ErrorMessage` - Text) to `$Flow.FaultMessage` before connecting to an End element. This allows the LWC to show specific error toasts.
   * (Optional but Recommended): Add an **Output Variable** (e.g., `output_RecordId` - Text) in the Flow, marked as "Available for Output", and set the ID of the created/updated record to this variable on the success path. This allows the LWC to confirm success based on the record ID.
   * Save and **Activate** the Flow.

## Usage

1. Navigate to a Lightning Page (e.g., Home page, a custom App page, or even a record page) where you want to place the component.
2. Click the Gear icon -> **Edit Page**.
3. Drag the `CoinMarketCapSearch` Lightning Web Component from the Custom Components list onto the page layout.
4. Save and Activate the page.
5. View the page, enter a crypto symbol (e.g., BTC, ETH), click Search, review the data, and click "Save Coin" to trigger the Flow modal.

## Components

* `CoinMarketCapSearch` (LWC): The main component providing the user interface for searching and displaying data. It embeds `c-coin-modal-flow`.
* `CoinModalFlow` (LWC): A modal component that wraps the `lightning-flow` tag to display the `Create_Coin_Record` Flow. It handles closing the modal based on Flow status.
* `CoinMarketCapController.cls` (Apex): Handles the logic for making the HTTP callout to the external API and parsing the JSON response. Includes error handling for various API and HTTP statuses.
* `Create_Coin_Record` (Flow): A Screen Flow responsible for taking the data inputs and performing the DML (Create or Update) operation on the custom object.
* `CoinMarketCapUrl__mdt` (Custom Metadata Type): Stores the configurable base URL for CoinMarketCap currency pages.
* `CoinMarketEndPoint` (Named Credential): Defines the secure endpoint for the API callout.

## Error Handling

The project includes error handling at multiple layers:

* **LWC Input Validation:** Checks for a blank symbol before making the callout.
* **Apex Callout:** Handles `System.CalloutException` and parses HTTP status codes (400, 401, 403, 429, 500, etc.) as well as internal API error codes from the response body.
* **Flow Integration:** The LWC listens for `onstatuschange` events from the `lightning-flow` component to detect `FINISHED`, `FINISHED_SCREEN`, and `FAULT` states. It can display toast messages based on the Flow's status and output variables (if configured).

## Testing

The `CoinMarketCapController.cls` Apex class is covered by unit tests in `CoinMarketCapController_Test.cls`. This test class uses `HttpCalloutMock` to simulate various API responses and exception scenarios to ensure code coverage.
