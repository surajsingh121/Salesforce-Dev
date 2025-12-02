import { LightningElement,wire,track } from 'lwc';
import getData  from '@salesforce/apex/WireDemo.getData';

const columns = [
    {label: 'Name', fieldName: 'Name'},
    {label: 'Email', fieldName: 'Email__c'},
    {label: 'Phone', fieldName: 'Phone__c'},
   
    
]
export default class WireDemo extends LightningElement {
   @track columns = columns;
   @track data = [];

   @wire (getData)
   
      wiredData({error,data}) {
        if(data){
            this.data=data;
            console.log(data);
        }else if(error){
            console.log(error);
        }
    }
}