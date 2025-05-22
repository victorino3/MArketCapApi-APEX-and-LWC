public class CoinDataCalloutQueueable implements Queueable, Database.AllowsCallouts {
    private String symbol;
    public CoinDataCalloutQueueable(String sym) {
        this.symbol = sym;
        // this.correlationId = corrId; // Uncomment
    }

    public void execute(QueueableContext context) {
        CoinMarketCapController.CoinDataWrapper calloutResult = CoinMarketCapController.getCoinData(this.symbol);

        Coin_Data_Response__e event = new Coin_Data_Response__e(
            Symbol__c = this.symbol 
        );

        if (String.isBlank(calloutResult.error) && calloutResult.symbol != null) { // Success if no error AND symbol data was found
            event.WasSuccessful__c = true;
            event.Name__c = calloutResult.name;
            event.Symbol__c = calloutResult.symbol; 
            event.Price__c = calloutResult.price;
            //event.MarketCap__c = calloutResult.marketCap;
            //event.CoinMarketCapUrl__c = calloutResult.coinMarketCapUrl;
        } else {
            event.WasSuccessful__c = false;
            event.ErrorMessage__c = String.isBlank(calloutResult.error) ? 'Unknown error or symbol not found by API.' : calloutResult.error;
    }

        Database.SaveResult sr = EventBus.publish(event);

        if (!sr.isSuccess()) {
            String errors = '';
            for (Database.Error err : sr.getErrors()) {
                errors += '(' + err.getStatusCode() + ') ' + err.getMessage() + '. Fields: ' + String.join(err.getFields(), ', ') + '\n';
            }
            System.debug('CoinDataCalloutQueueable: Failed to publish Coin_Data_Response__e for ' + this.symbol + '. Errors: ' + errors);
        }
    }
}
