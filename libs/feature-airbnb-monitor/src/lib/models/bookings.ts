export interface Booking {
  confirmationCode: string;
  guestName: string;
  initials: string;
  numberOfGuests: number;
  checkInDate: Date;
  checkOutDate: Date;
  numberOfNights: number;
  earnings: number;
}
