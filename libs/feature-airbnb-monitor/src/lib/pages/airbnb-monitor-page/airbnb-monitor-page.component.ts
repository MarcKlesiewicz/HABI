import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FlashCardComponent } from '@habi/lib-shared';

@Component({
  selector: 'lib-airbnb-monitor-page',
  imports: [CommonModule, FlashCardComponent],
  templateUrl: './airbnb-monitor-page.component.html',
  styleUrl: './airbnb-monitor-page.component.scss',
})
export class AirbnbMonitorPageComponent {}
