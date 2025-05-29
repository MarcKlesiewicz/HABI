import { CommonModule } from '@angular/common';
import { Component, input } from '@angular/core';
import { Booking } from '../../models/bookings';
import { BookingCardComponent } from '../booking-card/booking-card.component';

@Component({
  selector: 'lib-upcoming-bookings',
  imports: [CommonModule, BookingCardComponent],
  templateUrl: './upcoming-bookings.component.html',
  styleUrl: './upcoming-bookings.component.scss',
})
export class UpcomingBookingsComponent {
  bookings = input<Booking[]>([]);
}
