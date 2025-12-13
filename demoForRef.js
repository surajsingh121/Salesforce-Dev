import { LightningElement } from 'lwc';

export default class DemoForRef extends LightningElement {
    handleClick(){
        this.refs.myDiv.className="mtText";
    }
}