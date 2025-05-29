import { Injectable } from '@angular/core';
import { getInitials } from '@habi/lib-shared';
import { Booking } from '../models/bookings';
import { getBookingsMock } from '../models/bookings.mock';

@Injectable({
  providedIn: 'root',
})
export class AirbnbService {
  getBookings(): Booking[] {
    return getBookingsMock().map((booking) => {
      return { ...booking, initials: getInitials(booking.guestName) };
    });
  }
}
