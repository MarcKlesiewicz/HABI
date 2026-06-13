class AirbnbReservation {
  final String confirmationCode;
  final DateTime bookingDate;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final int guestCount;
  final String guest;
  final String listing;
  final String currency;
  final double amount;

  const AirbnbReservation({
    required this.confirmationCode,
    required this.bookingDate,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.guestCount,
    required this.guest,
    required this.listing,
    required this.currency,
    required this.amount,
  });
}

class AirbnbReservationStore {
  AirbnbReservationStore._();

  static final reservations = <AirbnbReservation>[
    AirbnbReservation(
      confirmationCode: 'HMFZ3AT54E',
      bookingDate: DateTime(2026, 4, 26),
      checkIn: DateTime(2026, 6, 5),
      checkOut: DateTime(2026, 6, 7),
      nights: 2,
      guestCount: 1,
      guest: 'Pernille Sutrow',
      listing: 'Landidyl tæt på skov og by',
      currency: 'DKK',
      amount: 837.38,
    ),
    AirbnbReservation(
      confirmationCode: 'HMKPA3JY5X',
      bookingDate: DateTime(2026, 3, 24),
      checkIn: DateTime(2026, 6, 18),
      checkOut: DateTime(2026, 6, 19),
      nights: 1,
      guestCount: 1,
      guest: 'Anne Mette Stevn',
      listing: 'Landidyl tæt på skov og by',
      currency: 'DKK',
      amount: 1111.69,
    ),
    AirbnbReservation(
      confirmationCode: 'HM9TRMBTZN',
      bookingDate: DateTime(2026, 1, 5),
      checkIn: DateTime(2026, 6, 19),
      checkOut: DateTime(2026, 6, 21),
      nights: 2,
      guestCount: 1,
      guest: 'Martin Bo Sjøberg',
      listing: 'Landidyl tæt på skov og by',
      currency: 'DKK',
      amount: 2223.38,
    ),
    AirbnbReservation(
      confirmationCode: 'HMJPZH34BZ',
      bookingDate: DateTime(2026, 3, 19),
      checkIn: DateTime(2026, 7, 28),
      checkOut: DateTime(2026, 7, 30),
      nights: 2,
      guestCount: 1,
      guest: 'Mike Vos',
      listing: 'Landidyl tæt på skov og by',
      currency: 'DKK',
      amount: 758.46,
    ),
    AirbnbReservation(
      confirmationCode: 'HM83EEY5C8',
      bookingDate: DateTime(2026, 5, 26),
      checkIn: DateTime(2026, 8, 9),
      checkOut: DateTime(2026, 8, 10),
      nights: 1,
      guestCount: 1,
      guest: 'Jana Brandejsova',
      listing: 'Landidyl tæt på skov og by',
      currency: 'DKK',
      amount: 379.23,
    ),
    AirbnbReservation(
      confirmationCode: 'HMMTWBTBEN',
      bookingDate: DateTime(2026, 3, 24),
      checkIn: DateTime(2026, 8, 26),
      checkOut: DateTime(2026, 8, 27),
      nights: 1,
      guestCount: 1,
      guest: 'Marie Hoff',
      listing: 'Landidyl tæt på skov og by',
      currency: 'DKK',
      amount: 379.19,
    ),
  ];

  static List<AirbnbReservation> get upcoming {
    return List<AirbnbReservation>.from(reservations)
      ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
  }

  static int get totalNights {
    return reservations.fold(0, (total, reservation) {
      return total + reservation.nights;
    });
  }

  static double get totalAmount {
    return reservations.fold(0, (total, reservation) {
      return total + reservation.amount;
    });
  }

  static double get averageAmount {
    if (reservations.isEmpty) return 0;
    return totalAmount / reservations.length;
  }

  static double get averageStay {
    if (reservations.isEmpty) return 0;
    return totalNights / reservations.length;
  }

  static AirbnbReservation? get nextReservation {
    if (upcoming.isEmpty) return null;
    return upcoming.first;
  }
}
