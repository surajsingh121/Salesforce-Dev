import { LightningElement, track,wire } from 'lwc';
import getData from '@salesforce/apex/wireAccount.getData';


const columns =[
    {label: 'Name', fieldName: 'Name'},
    {label: 'Phone', fieldName: 'Phone'},
    {label: 'OwnerId', fieldName: 'OwnerId'},
    {label: 'Account Number', fieldName: 'AccountNumber'},
    {label: 'Rating', fieldName: 'Rating'},
   
]

export default class WireAccount extends LightningElement {

    @track columns = columns;
      @track data = [];
   
      @wire (getData)
      
         wiredData({error,data}) {
           if(data){
               this.data=data;
           }else if(error){
               console.log(error);
           }
       }
}