public class CoinDataCalloutQueueable implements Queueable, Database.AllowsCallouts {
    private String symbol;
    // private String correlationId; // Uncomment if using CorrelationId

    public CoinDataCalloutQueueable(String sym) {
        this.symbol = sym;
        // this.correlationId = corrId; // Uncomment
    }

    public void execute(QueueableContext context) {
        CoinDataWrapper calloutResult = CoinMarketCapController.getCoinData(this.symbol);

        Coin_Data_Response__e event = new Coin_Data_Response__e(
            Symbol__c = this.symbol 
        );

        if (String.isBlank(calloutResult.error) && calloutResult.symbol != null) { // Success if no error AND symbol data was found
            event.WasSuccessful__c = true;
            event.Name__c = calloutResult.name;
            event.Symbol__c = calloutResult.symbol; // This will be the symbol returned by API
            event.Price__c = calloutResult.price;
            //event.MarketCap__c = calloutResult.marketCap;
            //event.CoinMarketCapUrl__c = calloutResult.coinMarketCapUrl;
        } else {
            event.WasSuccessful__c = false;
            event.ErrorMessage__c = String.isBlank(calloutResult.error) ? 'Unknown error or symbol not found by API.' : calloutResult.error;
            // If calloutResult.symbol is null (e.g. API didn't find it), Symbol__c on event remains the requested symbol.
        }

        Database.SaveResult sr = EventBus.publish(event);

        if (!sr.isSuccess()) {
            String errors = '';
            for (Database.Error err : sr.getErrors()) {
                errors += '(' + err.getStatusCode() + ') ' + err.getMessage() + '. Fields: ' + String.join(err.getFields(), ', ') + '\n';
            }
            System.debug('CoinDataCalloutQueueable: Failed to publish Coin_Data_Response__e for ' + this.symbol + '. Errors: ' + errors);
            // Consider logging this failure to a custom object for monitoring
        }
    }
}
