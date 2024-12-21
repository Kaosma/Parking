# parking_admin + parking_user

A Flutter project that administrates users, parking spaces and parkings created by users. Another Flutter project that allows a single user to navigate it's own vehicles, parkings and personal settings.

## Table of Contents
- [Features Admin](#featuresadmin)
- [Features User](#featuresadmin)
- [Limitations](#limitations)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features Admin
- Users (Create, Read, Update, Delete)
- Parking spaces (Create, Read, Update, Delete)
- Parkings (Read, Delete)
- Statistics (Total earned from earlier parkings, Most used parking spaces, Total active/inactive parkings)

## Features User
- Users (Create)
- Vehicles (owned by user) (Create, Read, Update, Delete)
- Parkings (owned by user) (Read, Delete)

## Limitations
- Hot reload between user and admin is not implemented
- Login a bit too complicated for users since id is currently used for that
- Statistics not updated dynamically

## Installation
Clone the repository:
```bash
git clone https://github.com/Kaosma/Parking.git
Admin: cd project/Uppgift_3/parking_admin
User: cd project/Uppgift_3/parking_user
```

Install dependencies:
```bash
flutter pub get
```

## Usage

Run the application:
```bash
Enter main file in each project and press "play" button
Choose what device you want to run on
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
