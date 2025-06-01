import { CommonModule } from '@angular/common';
import { Component, signal } from '@angular/core';

@Component({
  selector: 'lib-airbnb-checklist',
  imports: [CommonModule],
  templateUrl: './airbnb-checklist.component.html',
  styleUrl: './airbnb-checklist.component.scss',
})
export class AirbnbChecklistComponent {
  isDepartureChecklist = signal<boolean>(true);

  departureChecklist = signal<string[]>([
    'Collect and wash all linens and towels',
    'Empty all trash bins and take out the garbage',
    'Check for any personal items left behind by guests',
    'Empty dish bucket',
    'Turn down the thermostat (0) and turn off circulationpump (summer)',
    'Check keys are in keybox',
    'Check for any items that need restocking (toiletries, coffee, etc.)',
  ]);

  arrivalChecklist = signal<string[]>([
    'Check that all appliances are functioning properly',
    'Ensure all lights are working',
    'Check for any maintenance issues (leaks, broken fixtures, etc.)',
    'Restock any necessary items (toiletries, coffee, etc.)',
    'Check that all linens and towels are clean and ready for the next guests',
    'Ensure the property is clean and ready for the next guests',
  ]);
}
