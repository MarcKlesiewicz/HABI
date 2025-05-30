import { CommonModule } from '@angular/common';
import { Component, signal } from '@angular/core';

@Component({
  selector: 'lib-airbnb-checklist',
  imports: [CommonModule],
  templateUrl: './airbnb-checklist.component.html',
  styleUrl: './airbnb-checklist.component.scss',
})
export class AirbnbChecklistComponent {
  departureChecklist = signal<string[]>([
    'Collect and wash all linens and towels',
    'Empty all trash bins and take out the garbage',
    'Check for any personal items left behind by guests',
    'Empty dish bucket',
    'Turn down the thermostat (0) and turn off circulationpump (summer)',
    'Check keys are in keybox',
    'Check for any items that need restocking (toiletries, coffee, etc.)',
  ]);
}
