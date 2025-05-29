import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FlashCardComponent } from '@habi/lib-shared';

@Component({
  selector: 'lib-airbnb-stats',
  imports: [CommonModule, FlashCardComponent],
  templateUrl: './airbnb-stats.component.html',
  styleUrl: './airbnb-stats.component.scss',
})
export class AirbnbStatsComponent {}
