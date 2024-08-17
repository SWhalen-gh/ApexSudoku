
import { LightningElement, wire } from 'lwc';
import fetchGameCells from '@salesforce/apex/SudokuController.fetchGameCells';

 
export default class SudokuGrid extends LightningElement {
    rows = [];

    // Use @wire to call the Apex method and fetch game cells
    @wire(fetchGameCells)
    wiredGameCells({error, data}) {
        if(data) {
            this.rows = data; // Assign the list of lists directly
        } else if(error) {
            console.error('Error fetching game cells:', error);
        }
    }
}


