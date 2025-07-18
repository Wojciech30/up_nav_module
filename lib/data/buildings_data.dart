import '../models/building.dart';
import '../models/office.dart';

class BuildingsData {
  static final List<Building> buildings = [
    Building(
      name: "Instytut Nauk Ścisłych i Technicznych",
      address: "ul. Boh. Westerplatte 64, 76-200 Słupsk",
      description: 'Wydział matematyki, fizyki i nauk technicznych',
      accessibility: ['Winda', 'Wejście na parterze', 'Toaleta dla osób z niepełnosprawnościami'],
      offices: [
        Office(
          name: "Sekretariat",
          roomNumber: "1",
          contactPerson: "mgr Ewa Marciniak",
          phones: ['577 750 630'],
          emails: ['instytut.nst@upsl.edu.pl'],
          openingHours: 'pon.–pt. 7:30–15:30',
        ),
        Office(
          name: "Dyrekcja",
          contactPerson: "dr Zofia Lewandowska",
          emails: ['zofia.lewandowska@upsl.edu.pl'],
          openingHours: 'pon.–pt. 8:00–14:00',
        ),
      ],
      latitude: 54.464858,
      longitude: 17.028407,
    ),
    // TODO:Kolejne budynki Uniwersytetu Pomorskiego
  ];
}
