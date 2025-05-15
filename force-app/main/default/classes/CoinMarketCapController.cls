public with sharing class CoinMarketCapController {

    // Wrapper class to hold the data returned to the LWC
    public class CoinDataWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String symbol;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String coinMarketCapUrl;
        @AuraEnabled public Decimal marketCap;
        @AuraEnabled public String error; 
    }

    private static final String URL_COIN = [
        SELECT coinMarketCapUrl__c
        FROM CoinMarketCapUrl__mdt
        LIMIT 1
    ].coinMarketCapUrl__c;

    @TestVisible
    public static String baseCoinMarketCapUrlTEst = URL_COIN;

    @InvocableMethod(label='Get Desired CoinData' description='Returns CoinDataWrapper.')
    public static CoinDataWrapper getCoinToFlow(List<String> symbols) {
        return CoinMarketCapController.getCoinData(symbol[0]);
    }

    @AuraEnabled(cacheable=true)
    public static CoinDataWrapper getCoinData(String symbol) {
        CoinDataWrapper result = new CoinDataWrapper();

        if (String.isBlank(symbol)) {
            result.error = 'Please enter a cryptocurrency symbol.';
            return result;
        }

        String encodedSymbol = EncodingUtil.urlEncode(symbol.toUpperCase(), 'UTF-8');
        String fullEndpoint = 'callout:CoinMarketEndPoint/v2/cryptocurrency/quotes/latest?symbol=' + encodedSymbol + '&convert=USD';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullEndpoint);
        request.setMethod('GET');
        request.setTimeout(10000);

        Http http = new Http();
        HttpResponse response;

        try {
            response = http.send(request);
            Integer statusCode = response.getStatusCode();

            if (statusCode == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> statusMap = (Map<String, Object>) responseMap.get('status');
                Integer errorCode = (Integer) statusMap.get('error_code');

                if (errorCode == 0) {
                    Map<String, Object> dataMap = (Map<String, Object>) responseMap.get('data');
                    String upperSymbol = symbol.toUpperCase();

                    if (dataMap != null && dataMap.containsKey(upperSymbol)) {
                        List<Object> coinData = (List<Object>) dataMap.get(upperSymbol);

                        Map<String, Object> coinList = getCoinList(coinData);
                        fillDataFields(result, coinList, URL_COIN);
                        fillQuoteFields(result, coinList);

                    } else {
                      
                        result.error = 'Symbol \'' + symbol + '\' not found in API data.';
                    }
                } else {
                    result.error = 'CoinMarketCap API Error (' + errorCode + '): ' + (String) statusMap.get('error_message');
                }

            } else {
                switch on statusCode {
                    when 400 {
                        result.error = 'Bad Request: The API request was invalid. Please check the symbol format or API documentation or contact administrator.';
                    }
                    when 401 {
                        result.error = 'Unauthorized: API key is missing or invalid. Ensure your Named Credential is correctly configured or contact administrator.';
                    }
                    when 403 {
                        result.error = 'Forbidden: You do not have access to this API endpoint. Check API key permissions or contact administrator.';
                    }
                    when 429 {
                        result.error = 'Too Many Requests: You have exceeded the API rate limit. Please wait a moment before trying again or contact administrator.';
                    }
                    when 500 {
                        result.error = 'Internal Server Error: The CoinMarketCap API encountered an internal error. Please try again later or contact administrator.';
                    }
                    when else {
                        result.error = 'API Callout Failed: Received unexpected HTTP status ' + statusCode + ' - ' + response.getStatus();
                    }
                }
            }

        } catch (System.CalloutException e) {
            
            result.error = 'Callout Exception: Could not connect to the external service. Please check the endpoint or network status. Message: ' + e.getMessage();
        } catch (Exception e) {
            result.error = 'Unexpected Error: An internal error occurred during data processing. Message: ' + e.getMessage();
        }

        return result;
    }

    public static Map<String, Object> getCoinList(List<Object> coinData) {
        if (coinData != null && !coinData.isEmpty()) {
            return (Map<String, Object>) coinData[0];
        }
        return new Map<String, Object>();
    }
    public static void fillDataFields(CoinDataWrapper result, Map<String, Object> coinList, String urlCoin) {
        
        if (coinList == null || coinList.isEmpty()) {
            result.error = 'Coin data is empty or invalid.';       
        }else{
            result.name = (String) coinList.get('name');
            result.symbol = (String) coinList.get('symbol');
            result.coinMarketCapUrl = urlCoin + (String) coinList.get('slug') + '/';
        }
    }

    public static void fillQuoteFields(CoinDataWrapper result, Map<String, Object> coinList) {
        Object quoteObj = coinList.get('quote');
        if (quoteObj instanceof Map<String, Object>) {
            Map<String, Object> quoteMap = (Map<String, Object>) quoteObj;
            Object usdObj = quoteMap.get('USD');

                if (usdObj instanceof Map<String, Object>) {
                        Map<String, Object> usdQuote = (Map<String, Object>) usdObj;

                        Object priceObj = usdQuote.get('price');
                            if (priceObj instanceof Decimal) {
                                result.price = (Decimal) priceObj;
                            } else if (priceObj instanceof String) {
                                result.price = Decimal.valueOf((String) priceObj);
                            }

                            Object marketCapObj = usdQuote.get('market_cap');
                            if (marketCapObj instanceof Decimal) {
                                result.marketCap = (Decimal) marketCapObj;
                            } else if (marketCapObj instanceof String) {
                                result.marketCap = Decimal.valueOf((String) marketCapObj);
                            }

                            } else {
                                result.error = 'USD quote is missing or invalid in the response.';
                            }
                        } else {
                            result.error = 'Quote section missing in API response.';
                        }
    }

}