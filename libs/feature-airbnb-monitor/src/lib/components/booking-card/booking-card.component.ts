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

  isActive = computed(() => {
    const today = new Date();
    return (
      this.booking().checkInDate <= today &&
      this.booking().checkOutDate >= today
    );
  });
}
