import { CommonModule } from '@angular/common';
import { Component, inject } from '@angular/core';
import { AirbnbStatsComponent } from '../../components/airbnb-stats/airbnb-stats.component';
import { UpcomingBookingsComponent } from '../../components/upcoming-bookings/upcoming-bookings.component';
import { AirbnbService } from '../../data/airbnb.service';

@Component({
  selector: 'lib-airbnb-monitor-page',
  imports: [CommonModule, AirbnbStatsComponent, UpcomingBookingsComponent],
  templateUrl: './airbnb-monitor-page.component.html',
  styleUrl: './airbnb-monitor-page.component.scss',
})
export class AirbnbMonitorPageComponent {
  private readonly airbnbService = inject(AirbnbService);

  bookings$ = this.airbnbService.getBookings();
}
