import { CommonModule } from '@angular/common';
import { Component, computed, input } from '@angular/core';
import { stringToHex } from '@habi/lib-shared';
import { Booking } from '../../models/bookings';

@Component({
  selector: 'lib-booking-card',
  imports: [CommonModule],
  templateUrl: './booking-card.component.html',
  styleUrl: './booking-card.component.scss',
})
export class BookingCardComponent {
  booking = input.required<Booking>();

  avatarColor = computed(() => {
    return stringToHex(this.booking().initials);
  });

  status = computed(() => {
    const today = new Date();
    if (this.booking().checkInDate > today) {
      return 'Upcoming' as BookingStatus;
    } else if (this.booking().checkOutDate < today) {
      return 'Completed' as BookingStatus;
    } else {
      return 'Active' as BookingStatus;
    }
  });
}

type BookingStatus = 'Upcoming' | 'Active' | 'Completed';
