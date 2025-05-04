import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CoinModalFlow extends LightningElement {
    @api coinData;

    get flowInputVariables() {
        const coin = this.coinData || {};
        return [
            {
                name: 'input_CoinName',
                type: 'String',
                value: coin.name ?? 'Unknown'
            },
            {
                name: 'input_CoinSymbol',
                type: 'String',
                value: coin.symbol ?? 'N/A'
            },
            {
                name: 'input_PriceUSD',
                type: 'Number',
                value: coin.price ? parseFloat(coin.price) : 0.0
            },
            {
                name: 'input_MarketCapUSD',
                type: 'Number',
                value: coin.marketCap ? parseFloat(coin.marketCap) : 0.0
            },
            {
                name: 'input_CoinMarketCapURL',
                type: 'String',
                value: coin.coinMarketCapUrl ?? ''
            }
        ];
    }

    handleFlowStatusChange(event) {
        console.log('Flow Status Changed:', event.detail.status);
        console.log('Flow Output Variables:', event.detail.outputVariables);
        console.log('Flow State:', event.detail.state); 

        if (event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN') {
            let toastTitle = 'Operation Complete';
            let toastMessage = 'The flow finished successfully.';
            let toastVariant = 'success'; 
            if (event.detail.outputVariables) {
                for (const outputVar of event.detail.outputVariables) {
                    if (outputVar.name === 'output_RecordId' && outputVar.value) {
                        toastMessage = 'Coin record saved successfully!';
                    }
                   
                    if (outputVar.name === 'output_CompletionMessage' && outputVar.value) {

                         toastMessage = outputVar.value;
                    }
                    if (outputVar.name === 'output_Error' && outputVar.value) {
                         toastTitle = 'Flow Finished with Error';
                         toastMessage = outputVar.value;
                         toastVariant = 'error'; 
                    }
                }
            }
            const toastEvent = new ShowToastEvent({
                title: toastTitle,
                message: toastMessage,
                variant: toastVariant,
                mode: 'dismissible' 
            });
            this.dispatchEvent(toastEvent);
            this.dispatchEvent(new CustomEvent('closemodal'));

        } else if (event.detail.status === 'FAULT') {
             let errorMessage = 'An unexpected error occurred in the flow.';
             if (event.detail.state && event.detail.state.errorMessage) {
                errorMessage = event.detail.state.errorMessage;
             } else if (event.detail.state && Array.isArray(event.detail.state.errors) && event.detail.state.errors.length > 0 && event.detail.state.errors[0].message) {
                 errorMessage = event.detail.state.errors[0].message;
             }
            const toastEvent = new ShowToastEvent({
                title: "Flow Fault",
                message: errorMessage,
                variant: "error",
                mode: 'sticky' 
            });
            this.dispatchEvent(toastEvent);

        }
    }

    closeModal() {
        const toastEvent = new ShowToastEvent({
            title: "Operation Cancelled",
            message: "The flow operation was cancelled.",
            variant: "info", 
            mode: "dismissible"
        });
        this.dispatchEvent(toastEvent);
        this.dispatchEvent(new CustomEvent('closemodal'));
    }
}