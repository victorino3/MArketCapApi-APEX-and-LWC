@isTest
private class CoinMarketCapControllerTest {
    @isTest
    static void testGetCoinData() {
        Test.setMock(HttpCalloutMock.class, new MockCoinMarketCapResponse());

        // Valid symbol
        CoinMarketCapController.baseCoinMarketCapUrlTEst = 'https://coinmarketcap.com/currencies/';
        CoinMarketCapController.CoinDataWrapper result = CoinMarketCapController.getCoinData('btc');
        System.assertEquals('Bitcoin', result.name);
        System.assertEquals('BTC', result.symbol);
        System.assertEquals(53537.81, result.price);
        System.assertEquals(53537.81, result.marketCap);
        System.assertEquals('https://coinmarketcap.com/currencies/bitcoin/', result.coinMarketCapUrl);
        System.assertEquals(null, result.error);

        // No symbol
        result = CoinMarketCapController.getCoinData('');
        System.assertEquals('Please enter a cryptocurrency symbol.', result.error);
        result = CoinMarketCapController.getCoinData('HBB');
    }

    @isTest
    static void testFillDataFields() {
        CoinMarketCapController.CoinDataWrapper result = new CoinMarketCapController.CoinDataWrapper();

        Map<String, Object> coinList = new Map<String, Object>{
            'name' => 'Bitcoin',
            'symbol' => 'BTC',
            'slug' => 'bitcoin'
        };
        CoinMarketCapController.fillDataFields(result, coinList, 'https://coinmarketcap.com/currencies/');
        System.assertEquals('Bitcoin', result.name);
        System.assertEquals('BTC', result.symbol);
        System.assertEquals('https://coinmarketcap.com/currencies/bitcoin/', result.coinMarketCapUrl);

        result = new CoinMarketCapController.CoinDataWrapper();
        CoinMarketCapController.fillDataFields(null, new Map<String, Object>(), 'https://coinmarketcap.com/currencies/');
        System.assertEquals('Coin data is empty or invalid.', result.error);
    }

    @isTest
    static void testFillQuoteFields() {
        CoinMarketCapController.CoinDataWrapper result = new CoinMarketCapController.CoinDataWrapper();

        Map<String, Object> coinList = new Map<String, Object>{
            'quote' => new Map<String, Object>{
                'USD' => new Map<String, Object>{
                    'price' => 53537.81,
                    'market_cap' => 53537.81
                }
            }
        };
        CoinMarketCapController.fillQuoteFields(result, coinList);
        System.assertEquals(53537.81, result.price);
        System.assertEquals(53537.81, result.marketCap);

        // Test with missing quote
        result = new CoinMarketCapController.CoinDataWrapper();
        CoinMarketCapController.fillQuoteFields(null, new Map<String, Object>());
        System.assertEquals('Quote section missing in API response.', result.error);
    }

}
