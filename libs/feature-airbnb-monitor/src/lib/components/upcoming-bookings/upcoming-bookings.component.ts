import { CommonModule } from '@angular/common';
import { Component, computed, input } from '@angular/core';
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

  daysUntilNextBooking = computed(() => {
    if (this.bookings().length === 0) {
      return 0;
    }
    const today = new Date();
    const futureBookings = this.bookings().filter(
      (booking) => booking.checkInDate > today
    );
    if (futureBookings.length === 0) {
      return 0;
    }
    const nextBooking = futureBookings.reduce((a, b) =>
      a.checkInDate < b.checkInDate ? a : b
    );
    const diffTime = Math.abs(
      nextBooking.checkInDate.getTime() - today.getTime()
    );
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  });
}
