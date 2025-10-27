import { LightningElement, track, wire } from 'lwc';
import getContact from '@salesforce/apex/WireDemo.getContact';


const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email' },
    { label: 'Phone', fieldName: 'Phone' },
];
export default class WireDemoExample extends LightningElement {

@track columns = columns;
@track data = [];
@track error;

 @wire(getContact)
    wiredData({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            console.log(error);
        }
    }

}