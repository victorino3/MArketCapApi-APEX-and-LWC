import { LightningElement, track } from 'lwc';
import getCoinData from '@salesforce/apex/CoinMarketCapController.getCoinData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CoinMarketCapSearch extends LightningElement {
    @track symbol = '';
    @track coinData;
    @track error;
    @track isLoading = false;
    @track showModal = false;

    handleSymbolChange(event) {
        this.symbol = event.target.value;
        this.coinData = undefined; 
        this.error = undefined;   
    }

    handleSearch() {
        if (!this.symbol) {
            this.dispatchEvent(new ShowToastEvent({
                title: "Search Error",
                message: "Please enter a cryptocurrency symbol.",
                variant: "error",
            }));
            this.error = undefined; 
            this.coinData = undefined;
            return;
        }

        this.isLoading = true;
        this.coinData = undefined;
        this.error = undefined;

        getCoinData({ symbol: this.symbol })
            .then(result => {
                if (result.error) {
                    this.error = result.error;
                    this.dispatchEvent(new ShowToastEvent({
                        title: "Search Failed",
                        message: result.error,
                        variant: "error",
                    }));
                    this.coinData = undefined;

                } else {
                    this.coinData = result;
                    const toastEvent = new ShowToastEvent({
                        title: "Search Complete",
                        message: `Data for ${this.symbol.toUpperCase()} fetched successfully.`,
                        variant: "success",
                        mode: "dismissible" 
                    });
                    this.dispatchEvent(toastEvent);
                   
                }
            })
            .catch(error => {
                this.error = 'An unexpected error occurred during the search.';
                console.error('Apex Callout Error:', error);
                 this.dispatchEvent(new ShowToastEvent({
                    title: "Unexpected Error",
                    message: 'An unexpected error occurred during the search. Please try again.',
                    variant: "error",
                }));

            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleSaveCoin() {
        if (this.coinData) {
            this.showModal = true;
            this.symbol = '';
        } else {
            this.dispatchEvent(new ShowToastEvent({
                title: "Error Saving Coin",
                message: "No coin data available to save.",
                variant: "error",
            }));
        }
    }

    handleModalClose() {
        this.showModal = false;
    }
}