@isTest
global class MockCoinMarketCapResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();
        if (endpoint.contains('BTC')) {
            res.setStatusCode(200);
            res.setBody(JSON.serializePretty(new Map<String, Object>{
                'status' => new Map<String, Object>{ 'error_code' => 0 },
                'data' => new Map<String, Object>{
                    'BTC' => new List<Object>{
                        new Map<String, Object>{
                            'name' => 'Bitcoin',
                            'symbol' => 'BTC',
                            'slug' => 'bitcoin',
                            'quote' => new Map<String, Object>{
                                'USD' => new Map<String, Object>{
                                    'price' => '53537.81',
                                    'market_cap' => '53537.81'
                                }
                            }
                        }
                    }
                }
            }));
        } else {
            res.setStatusCode(400);
            res.setBody(JSON.serialize(new Map<String, Object>{
                'status' => new Map<String, Object>{ 'error_code' => 0 },
                'data' => new Map<String, Object>() 
            }));
        }
        

        return res;
    }
}
