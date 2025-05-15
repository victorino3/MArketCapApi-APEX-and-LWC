public with sharing class CoinDataWrapperFlow {
    @InvocableVariable(label='Symbol')
    public String symbol;

    @InvocableVariable(label='Price')
    public Decimal price;

    @InvocableVariable(label='Change')
    public Decimal change24h;
}