import {Component} from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent {
    str: string;
    palindroms: string[];

    constructor(private httpClient: HttpClient) {

    }

    findPalindroms(): void {
        this.palindroms = [];
        if (this.str.length > 1) {
            this.httpClient.get(`/api/palindrom.php?str=${this.str}`).subscribe((data: string[]) => {
                this.palindroms = data;
            });
        }
    }
}
