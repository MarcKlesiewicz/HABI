import { CommonModule } from '@angular/common';
import { Component, computed, inject, signal } from '@angular/core';
import { AirbnbStatsComponent } from '../../components/airbnb-stats/airbnb-stats.component';
import { UpcomingBookingsComponent } from '../../components/upcoming-bookings/upcoming-bookings.component';
import { AirbnbService } from '../../data/airbnb.service';
import { Booking } from '../../models/bookings';

@Component({
  selector: 'lib-airbnb-monitor-page',
  imports: [CommonModule, AirbnbStatsComponent, UpcomingBookingsComponent],
  templateUrl: './airbnb-monitor-page.component.html',
  styleUrl: './airbnb-monitor-page.component.scss',
})
export class AirbnbMonitorPageComponent {
  private readonly airbnbService = inject(AirbnbService);

  bookings = signal<Booking[]>([]);
  totalBookings = computed(() => this.bookings().length);
  completedBookings = computed(() => 0);
  totalRevenue = computed(() =>
    this.bookings().reduce((total, booking) => total + booking.earnings, 0)
  );

  ngOnInit(): void {
    this.bookings.set(this.airbnbService.getBookings());
  }
}
