import { LightningElement, track } from 'lwc';

export default class CreateCaseLauncher extends LightningElement {

    @track isModalOpen = false;
    @track isDetailModalOpen = false;
    @track showTable = false;
    @track selectedOrder = {};

    //@track showTable = t; // show initial list on first load
    @track selectedRecord = {};


    columns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Subject', fieldName: 'Subject' },
        { label: 'Status', fieldName: 'Status' }
    ];

    data = [
        { Id: '1', CaseNumber: '00001026', Subject: 'marketing', Status: 'Working' },
        { Id: '2', CaseNumber: '00001027', Subject: 'login issue', Status: 'New' }
    ];

    orderList = [
        {
            id: 1,
            orderNo: '10494405247',
            sku: '1234567890',
            description: 'Lavadora Mabe',
            client: 'Alejandra Fernández'
        },
        {
            id: 2,
            orderNo: '20494405248',
            sku: '9876543210',
            description: 'Refrigerador LG',
            client: 'Carlos Ruiz'
        }
    ];

    get filteredData() {
        // when page loads we want to show initial records,
        // later user can click Buscar to refresh/filter as needed
        return this.showTable ? this.data : this.data;
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    // Show table only when Buscar button is clicked
    handleBuscar() {
        this.showTable = true;
    }

    // Open modal when a record/order row is clicked
    openDetailModal(event) {
        const recordId = event.currentTarget.dataset.id;
        this.selectedOrder = this.orderList.find(item => item.id == recordId);
        this.isDetailModalOpen = true;
    }

    closeDetailModal() {
        this.isDetailModalOpen = false;
    }

    //----------------------------second modal ------------

    orderList = [
        {
            id: 1,
            orderNo: '10494405247',
            sku: '1117862131',
            description: 'Lavadora Mabe',
            client: 'Alejandra Fernández González'
        },
        {
            id: 2,
            orderNo: '20494405248',
            sku: '9988776655',
            description: 'Refrigerador LG',
            client: 'Carlos Ramírez'
        }
    ];

    motivoOptions = [
        { label: 'Producto dañado', value: 'damaged' },
        { label: 'Falla técnica', value: 'technical' }
    ];

    subcategoriaOptions = [
        { label: 'Reemplazo', value: 'replace' },
        { label: 'Reparación', value: 'repair' }
    ];

    handleRowClick(event) {
        const recordId = event.currentTarget.dataset.id;
        this.selectedRecord = this.orderList.find(
            rec => rec.id == recordId
        );
        this.isDetailModalOpen = true;
    }

   
}
