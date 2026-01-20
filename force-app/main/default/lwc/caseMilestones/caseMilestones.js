import { LightningElement, api, wire, track } from 'lwc';
import getCaseMilestones from '@salesforce/apex/CaseMilestoneService.getCaseMilestones';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseMilestones extends LightningElement {
    @api recordId; // Case Id from the record page
    @track rows = [];
    @track error;
    @track isLoading = true;
    showErrorModal = false;

    columns = [
        { label: 'Milestone', fieldName: 'milestoneName', type: 'text', sortable: true },
        { label: 'Start', fieldName: 'startDate', type: 'date', typeAttributes: { year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' } },
        { label: 'Target', fieldName: 'targetDate', type: 'date', typeAttributes: { year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' } },
        { label: 'Completed', fieldName: 'completionDate', type: 'date', typeAttributes: { year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' } },
        { label: 'Status', fieldName: 'status', type: 'text' },
        { label: 'Elapsed (min)', fieldName: 'timeElapsedMinutes', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Remaining (min)', fieldName: 'timeRemainingMinutes', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Violated', fieldName: 'isViolated', type: 'boolean' }
    ];

    @wire(getCaseMilestones, { caseId: '$recordId' })
    wiredMilestones({ data, error }) {
        this.isLoading = false;
        if (data) {
            this.rows = (data || []).map(r => ({
                ...r,
                // Ensure dates are passed as ISO for lightning-datatable date type
                startDate: r.startDate ? r.startDate : null,
                targetDate: r.targetDate ? r.targetDate : null,
                completionDate: r.completionDate ? r.completionDate : null
            }));
            this.error = undefined;
        } else if (error) {
            this.rows = [];
            this.error = error;
            this.showErrorModal = true;
            const message = this.normalizeError(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading milestones',
                    message,
                    variant: 'error'
                })
            );
        }
    }

    get errorMessage() {
        return this.normalizeError(this.error);
    }

    handleCloseError() {
        this.showErrorModal = false;
    }

    normalizeError(err) {
        if (!err) return '';
        if (Array.isArray(err.body)) {
            return err.body.map(e => e.message).join(', ');
        }
        if (err.body && typeof err.body.message === 'string') {
            return err.body.message;
        }
        if (typeof err.message === 'string') {
            return err.message;
        }
        try {
            return JSON.stringify(err);
        } catch (e) {
            return 'Unknown error';
        }
    }
}