

import 'package:flutter/material.dart';

class MarketplaceData {
  // Hotels Database
  static final List<Map<String, dynamic>> hotels = [
    {
      'id': 'hotel_001',
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'reviewCount': 1250,
      'totalReviews': 12,
      'reviewStats': {
        '5': 8,
        '4': 3,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'price': 'LKR 45,000/night',
      'contact': '+94 11 254 4544',
      'email': 'reservations@shangrilahotelcolombo.com',
      'openTime': '24/7',
      'image': 'assets/images/shangri_la.jpg',
      'mainImage': 'assets/images/shangri_la_main.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'isAvailable': true,
      'description': 'Experience luxury and comfort at Shangri-La Hotel Colombo. Located in the heart of Galle Face, our hotel offers world-class amenities, stunning ocean views, and exceptional service that defines luxury hospitality.',
      'amenities': [
        'Infinity Pool',
        'CHI Spa',
        'Free WiFi',
        'Concierge Service',
        '24h Room Service',
        'Valet Parking'
      ],
      'rooms': [
        {
          'id': 'room_001_deluxe',
          'type': 'Deluxe Ocean View',
          'price': 'LKR 45,000/night',
          'size': '45 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_deluxe.jpg',
          'backgroundColor': const Color(0xFF8B4513),
          'amenities': [
            'Ocean View',
            'Free WiFi',
            'Minibar',
            'Air Conditioning',
            'Marble Bathroom',
            'Balcony'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_001_exec',
          'type': 'Executive Suite',
          'price': 'LKR 65,000/night',
          'size': '75 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_suite.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': [
            'Separate Living Room',
            'City View',
            'Free WiFi',
            'Minibar',
            'Premium Bathroom with Bathtub'
          ],
          'available': false,
          'status': 'maintenance',
        },
        {
          'id': 'room_001_pres',
          'type': 'Presidential Suite',
          'price': 'LKR 120,000/night',
          'size': '120 sqm',
          'bedrooms': 2,
          'bathrooms': 2,
          'bedType': 'Master Bedroom + Guest Room',
          'image': 'assets/images/room_presidential.jpg',
          'backgroundColor': const Color(0xFF9370DB),
          'amenities': [
            'Living & Dining Area',
            'Panoramic Ocean View',
            'Premium Amenities',
            'Jacuzzi Bathroom',
            'Free WiFi'
          ],
          'available': false,
          'status': 'booked',
        },
      ],
    },
    {
      'id': 'hotel_002',
      'name': 'Galle Face Hotel',
      'location': 'Galle Face Green, Colombo',
      'rating': 4.5,
      'reviewCount': 980,
      'totalReviews': 10,
      'reviewStats': {
        '5': 6,
        '4': 3,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'price': 'LKR 38,000/night',
      'contact': '+94 11 254 1010',
      'email': 'reservations@gallefacehotel.com',
      'openTime': '24/7',
      'image': 'assets/images/galle_face.jpg',
      'mainImage': 'assets/images/galle_face_main.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'isAvailable': true,
      'description': 'Step into history at Galle Face Hotel, Sri Lanka\'s grand dame. With over 150 years of heritage, we offer timeless elegance, colonial charm, and modern luxury in the heart of Colombo.',
      'amenities': [
        'Heritage Pool',
        'Spa Ceylon',
        'Free WiFi',
        'Concierge Service',
        'Room Service',
        'Valet Parking',
        'Ballroom'
      ],
      'rooms': [
        {
          'id': 'room_002_heritage',
          'type': 'Heritage Room',
          'price': 'LKR 38,000/night',
          'size': '35 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'Queen Bed',
          'image': 'assets/images/room_deluxe.jpg',
          'backgroundColor': const Color(0xFF228B22),
          'amenities': [
            'Garden View',
            'Free WiFi',
            'Classic Furnishing',
            'Air Conditioning',
            'Period Bathroom',
            'Colonial Decor'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_002_ocean',
          'type': 'Ocean Suite',
          'price': 'LKR 55,000/night',
          'size': '65 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_suite.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': [
            'Ocean Facing',
            'Sitting Area',
            'Free WiFi',
            'Period Furniture',
            'Premium Bathroom',
            'Balcony'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_002_regent',
          'type': 'Regent Suite',
          'price': 'LKR 85,000/night',
          'size': '95 sqm',
          'bedrooms': 1,
          'bathrooms': 2,
          'bedType': 'King Bed',
          'image': 'assets/images/room_presidential.jpg',
          'backgroundColor': const Color(0xFF9370DB),
          'amenities': [
            'Sitting Area',
            'Separate Living Room',
            'Ocean View',
            'Antique Furnishing',
            'Free WiFi'
          ],
          'available': false,
          'status': 'maintenance',
        },
      ],
    },
    {
      'id': 'hotel_003',
      'name': 'Cinnamon Grand Colombo',
      'location': 'Fort, Colombo',
      'rating': 4.7,
      'reviewCount': 1100,
      'totalReviews': 15,
      'reviewStats': {
        '5': 10,
        '4': 4,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'price': 'LKR 42,000/night',
      'contact': '+94 11 249 1437',
      'email': 'reservations@cinnamongrandcolombo.com',
      'openTime': '24/7',
      'image': 'assets/images/cinnamon_grand.jpg',
      'mainImage': 'assets/images/cinnamon_grand_main.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'isAvailable': true,
      'description': 'Discover urban sophistication at Cinnamon Grand Colombo. Located in Fort, our hotel combines contemporary design with warm Sri Lankan hospitality, offering premium accommodations and facilities.',
      'amenities': [
        'Rooftop Pool',
        'Red Spa',
        'Free WiFi',
        'Room Service',
        'Shopping Arcade',
        'Event Facilities'
      ],
      'rooms': [
        {
          'id': 'room_003_superior',
          'type': 'Superior Room',
          'price': 'LKR 42,000/night',
          'size': '38 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_presidential.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': [
            'City View',
            'Free WiFi',
            'Minibar',
            'Air Conditioning',
            'Modern Bathroom'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_003_club',
          'type': 'Club Room',
          'price': 'LKR 58,000/night',
          'size': '42 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_suite.jpg',
          'backgroundColor': const Color(0xFF8FBC8F),
          'amenities': [
            'Club Lounge Access',
            'Free WiFi',
            'Minibar',
            'Premium Amenities',
            'Spa ceylon'
          ],
          'available': false,
          'status': 'booked',
        },
      ],
    },
    {
      'id': 'hotel_004',
      'name': 'Hilton Colombo',
      'location': 'Echelon Square, Colombo',
      'rating': 4.6,
      'reviewCount': 890,
      'totalReviews': 8,
      'reviewStats': {
        '5': 5,
        '4': 2,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'price': 'LKR 40,000/night',
      'contact': '+94 11 254 9200',
      'email': 'reservations@hiltoncolombo.com',
      'openTime': '24/7',
      'image': 'assets/images/hilton.jpg',
      'mainImage': 'assets/images/hilton_main.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'isAvailable': true,
      'description': 'Experience world-class hospitality at Hilton Colombo. Our modern hotel in Echelon Square offers luxury accommodations, excellent dining, and comprehensive business facilities.',
      'amenities': [
        'Outdoor Pool',
        'eforea Spa',
        'Free WiFi',
        'Graze Kitchen',
        'Room Service',
        'Event Spaces'
      ],
      'rooms': [
        {
          'id': 'room_004_guest',
          'type': 'Guest Room',
          'price': 'LKR 40,000/night',
          'size': '36 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_suite.jpg',
          'backgroundColor': const Color(0xFF8FBC8F),
          'amenities': [
            'City View',
            'Free WiFi',
            'Minibar',
            'Air Conditioning',
            'Walk-in Shower Bathroom'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_004_exec',
          'type': 'Executive Room',
          'price': 'LKR 55,000/night',
          'size': '40 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_presidential.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': [
            'Free WiFi',
            'Premium Amenities',
            'Evening Cocktails',
            'Spa Bathroom'
          ],
          'available': false,
          'status': 'maintenance',
        },
      ],
    },
    {
      'id': 'hotel_005',
      'name': 'Taj Samudra',
      'location': 'Galle Face, Colombo',
      'rating': 4.4,
      'reviewCount': 750,
      'totalReviews': 6,
      'reviewStats': {
        '5': 3,
        '4': 2,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'price': 'LKR 35,000/night',
      'contact': '+94 11 244 6622',
      'email': 'reservations@tajsamudra.com',
      'openTime': '24/7',
      'image': 'assets/images/taj_samudra.jpg',
      'mainImage': 'assets/images/taj_samudra_main.jpg',
      'backgroundColor': const Color(0xFF9370DB),
      'isAvailable': true,
      'description': 'Indulge in refined luxury at Taj Samudra. Overlooking the Indian Ocean, our hotel offers impeccable service, elegant accommodations, and authentic experiences in the heart of Colombo.',
      'amenities': [
        'Ocean Pool',
        'Jiva Spa',
        'Free WiFi',
        'Concierge Service',
        'Room Service',
        'Cultural Experiences',
        'Banquet Halls'
      ],
      'rooms': [
        {
          'id': 'room_005_deluxe',
          'type': 'Deluxe Room',
          'price': 'LKR 35,000/night',
          'size': '32 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_deluxe.jpg',
          'backgroundColor': const Color(0xFF9370DB),
          'amenities': [
            'Ocean/City View',
            'Free WiFi',
            'Minibar',
            'Traditional Decor',
            'Air Conditioning'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_005_luxury',
          'type': 'Luxury Room',
          'price': 'LKR 48,000/night',
          'size': '38 sqm',
          'bedrooms': 1,
          'bathrooms': 1,
          'bedType': 'King Bed',
          'image': 'assets/images/room_presidential.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': [
            'Premium Ocean View',
            'Free WiFi',
            'Premium Amenities',
            'Elegant Furnishing',
            'Marble Bathroom'
          ],
          'available': true,
          'status': 'available',
        },
        {
          'id': 'room_005_suite',
          'type': 'Taj Club Suite',
          'price': 'LKR 75,000/night',
          'size': '68 sqm',
          'bedrooms': 1,
          'bathrooms': 2,
          'bedType': 'King Bed',
          'image': 'assets/images/room_suite.jpg',
          'backgroundColor': const Color(0xFF8B4513),
          'amenities': [
            'Separate Living Area',
            'Ocean View',
            'Club Benefits',
            'Butler Service',
            'Premium Location'
          ],
          'available': false,
          'status': 'booked',
        },
      ],
    },
  ];

  // Travel Agencies Database
  static final List<Map<String, dynamic>> travelAgencies = [
    {
      'id': 'agency_001',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'experience': '15+ Years',
      'location': 'Colombo 03, Sri Lanka',
      'contact': '+94 11 234 5678',
      'email': 'info@ceylonroots.lk',
      'image': 'assets/images/ceylon_roots.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'description': 'Welcome to Ceylon Roots! We have been serving customers with 15+ years of experience in the travel industry. Our professional team is dedicated to providing you with authentic Sri Lankan travel experiences.',
      'totalReviews': 4,
      'reviewStats': {
        '5': 3,
        '4': 1,
        '3': 0,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Car',
          'seats': 4,
          'acPricePerKm': 55,
          'nonAcPricePerKm': 45,
          'features': ['Premium AC', 'Leather seats', 'GPS navigation', 'Bluetooth system', 'Phone charging', 'Complimentary water'],
        },
        {
          'type': 'Van',
          'seats': 8,
          'acPricePerKm': 75,
          'nonAcPricePerKm': 60,
          'features': ['Climate control AC', 'Spacious 8-seater', 'Large luggage space', 'Panoramic windows', 'Individual lights', 'USB charging ports'],
        },
        {
          'type': 'Mini Bus',
          'seats': 15,
          'acPricePerKm': 95,
          'nonAcPricePerKm': 80,
          'features': ['Central AC', 'Comfortable seating', 'Entertainment system', 'WiFi connectivity', 'Luggage compartment', 'First aid kit'],
        },
      ],
      'drivers': [
        {
          'name': 'Kumara Perera',
          'experience': '12 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'German'],
          'contact': '+94 77 123 4567',
          'specialization': 'Cultural & Heritage Tours',
        },
        {
          'name': 'Nimal Silva',
          'experience': '10 years',
          'languages': ['English', 'Sinhala', 'French'],
          'contact': '+94 76 234 5678',
          'specialization': 'Adventure & Wildlife Tours',
        },
        {
          'name': 'Rohan Fernando',
          'experience': '8 years',
          'languages': ['English', 'Sinhala', 'Japanese'],
          'contact': '+94 75 345 6789',
          'specialization': 'Beach & Coastal Tours',
        },
      ],
      'services': ['Cultural Tours', 'Heritage Sites', 'Temple Visits', 'Historical Tours'],
      'isAvailable': true,
      'category': 'Cultural',
    },
    {
      'id': 'agency_002',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'experience': '20+ Years',
      'location': 'Colombo 01, Sri Lanka',
      'contact': '+94 11 345 6789',
      'email': 'reservations@jetwing.lk',
      'image': 'assets/images/jetwing.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'description': 'Jetwing Travels has been a pioneer in Sri Lankan tourism for over 20 years. We offer comprehensive travel solutions with a focus on sustainable tourism and authentic experiences.',
      'totalReviews': 6,
      'reviewStats': {
        '5': 4,
        '4': 2,
        '3': 0,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Luxury Car',
          'seats': 4,
          'acPricePerKm': 65,
          'nonAcPricePerKm': 50,
          'features': ['Premium leather', 'Advanced AC', 'GPS & maps', 'Premium audio', 'Wireless charging', 'Refreshments'],
        },
        {
          'type': 'Premium Van',
          'seats': 8,
          'acPricePerKm': 85,
          'nonAcPricePerKm': 70,
          'features': ['Luxury interior', 'Captain seats', 'Individual AC', 'Entertainment screens', 'Refrigerator', 'WiFi hotspot'],
        },
        {
          'type': 'Coach Bus',
          'seats': 25,
          'acPricePerKm': 110,
          'nonAcPricePerKm': 90,
          'features': ['Central AC', 'Reclining seats', 'Entertainment system', 'WiFi', 'Onboard washroom', 'Safety equipment'],
        },
      ],
      'drivers': [
        {
          'name': 'Prasad Wickramasinghe',
          'experience': '15 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'Italian'],
          'contact': '+94 77 456 7890',
          'specialization': 'Luxury & Premium Tours',
        },
        {
          'name': 'Chaminda Rathnayake',
          'experience': '12 years',
          'languages': ['English', 'Sinhala', 'Spanish'],
          'contact': '+94 76 567 8901',
          'specialization': 'Group & Corporate Tours',
        },
      ],
      'services': ['Luxury Tours', 'Premium Transport', 'VIP Services', 'Corporate Travel'],
      'isAvailable': true,
      'category': 'Luxury',
    },
    {
      'id': 'agency_003',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'experience': '25+ Years',
      'location': 'Colombo 02, Sri Lanka',
      'contact': '+94 11 456 7890',
      'email': 'travel@aitkenspence.lk',
      'image': 'assets/images/aitken_spence.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'description': 'Aitken Spence Travels is one of Sri Lanka\'s most established travel companies with 25+ years of excellence. We provide comprehensive travel services including transportation, accommodation, and guided tours.',
      'totalReviews': 8,
      'reviewStats': {
        '5': 5,
        '4': 2,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Standard Car',
          'seats': 4,
          'acPricePerKm': 50,
          'nonAcPricePerKm': 40,
          'features': ['AC system', 'Comfortable seats', 'GPS navigation', 'Music system', 'Phone charging', 'Water bottles'],
        },
        {
          'type': 'Family Van',
          'seats': 8,
          'acPricePerKm': 70,
          'nonAcPricePerKm': 55,
          'features': ['Family friendly', 'Spacious interior', 'Large windows', 'Safety features', 'Storage space', 'Reading lights'],
        },
        {
          'type': 'Tour Bus',
          'seats': 20,
          'acPricePerKm': 90,
          'nonAcPricePerKm': 75,
          'features': ['Tour guide system', 'Comfortable seating', 'Large windows', 'AC system', 'Storage areas', 'Emergency equipment'],
        },
      ],
      'drivers': [
        {
          'name': 'Sunil Mendis',
          'experience': '18 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'Dutch'],
          'contact': '+94 77 678 9012',
          'specialization': 'Historical & Cultural Tours',
        },
        {
          'name': 'Ranjith Perera',
          'experience': '14 years',
          'languages': ['English', 'Sinhala', 'Hindi'],
          'contact': '+94 76 789 0123',
          'specialization': 'Family & Leisure Tours',
        },
      ],
      'services': ['General Tours', 'Family Travel', 'Group Tours', 'Corporate Services'],
      'isAvailable': true,
      'category': 'General',
    },
    {
      'id': 'agency_004',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'experience': '30+ Years',
      'location': 'Colombo 05, Sri Lanka',
      'contact': '+94 11 567 8901',
      'email': 'info@walkerstours.com',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'description': 'Walkers Tours is the oldest travel company in Sri Lanka with 30+ years of unmatched experience. We have been crafting memorable travel experiences for generations of travelers.',
      'totalReviews': 12,
      'reviewStats': {
        '5': 6,
        '4': 4,
        '3': 2,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Classic Car',
          'seats': 4,
          'acPricePerKm': 48,
          'nonAcPricePerKm': 38,
          'features': ['Reliable AC', 'Comfortable ride', 'Local music', 'Basic amenities', 'Safe driving', 'Courteous service'],
        },
        {
          'type': 'Tourist Van',
          'seats': 10,
          'acPricePerKm': 68,
          'nonAcPricePerKm': 54,
          'features': ['Tourist friendly', 'Multiple windows', 'Spacious design', 'Cultural music', 'Local guides', 'Photo stops'],
        },
      ],
      'drivers': [
        {
          'name': 'Bandula Jayasinghe',
          'experience': '20 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'Russian'],
          'contact': '+94 77 890 1234',
          'specialization': 'Scenic & Nature Tours',
        },
        {
          'name': 'Sarath Gunasekara',
          'experience': '16 years',
          'languages': ['English', 'Sinhala', 'Chinese'],
          'contact': '+94 76 901 2345',
          'specialization': 'Religious & Pilgrimage Tours',
        },
      ],
      'services': ['Scenic Tours', 'Nature Tours', 'Religious Tours', 'Heritage Tours'],
      'isAvailable': true,
      'category': 'Scenic',
    },
    {
      'id': 'agency_005',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'experience': '12+ Years',
      'location': 'Colombo 06, Sri Lanka',
      'contact': '+94 11 678 9012',
      'email': 'bookings@reddottours.lk',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
      'description': 'Red Dot Tours is a modern travel agency with 12+ years of innovative service. We specialize in adventure tourism and off-the-beaten-path experiences.',
      'totalReviews': 15,
      'reviewStats': {
        '5': 7,
        '4': 5,
        '3': 2,
        '2': 1,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Adventure Car',
          'seats': 4,
          'acPricePerKm': 52,
          'nonAcPricePerKm': 42,
          'features': ['Rugged design', 'Adventure ready', 'GPS tracking', 'Emergency kit', 'Action camera mounts', 'Outdoor gear storage'],
        },
        {
          'type': 'Adventure Van',
          'seats': 6,
          'acPricePerKm': 72,
          'nonAcPricePerKm': 58,
          'features': ['Off-road capable', 'Equipment storage', 'Safety gear', 'Communication system', 'First aid', 'Adventure guides'],
        },
        {
          'type': 'Group Bus',
          'seats': 18,
          'acPricePerKm': 88,
          'nonAcPricePerKm': 72,
          'features': ['Group friendly', 'Activity planning', 'Safety briefing area', 'Equipment space', 'Team building setup', 'Adventure maps'],
        },
      ],
      'drivers': [
        {
          'name': 'Dilshan Wijeratne',
          'experience': '8 years',
          'languages': ['English', 'Sinhala', 'Korean'],
          'contact': '+94 77 012 3456',
          'specialization': 'Adventure & Extreme Sports',
        },
        {
          'name': 'Kasun Liyanage',
          'experience': '6 years',
          'languages': ['English', 'Sinhala', 'Arabic'],
          'contact': '+94 76 123 4567',
          'specialization': 'Youth & Backpacker Tours',
        },
      ],
      'services': ['Adventure Tours', 'Extreme Sports', 'Backpacker Tours', 'Youth Travel'],
      'isAvailable': true,
      'category': 'Adventure',
    },
  ];

  // File: lib/data/data.dart (continued)

  // Tour Packages Database
  static final List<Map<String, dynamic>> tourPackages = [
    {
      'id': 'package_001',
      'title': 'Cultural Triangle Tour',
      'subtitle': '5 Days • Anuradhapura, Polonnaruwa, Sigiriya',
      'price': 'LKR 25,000',
      'originalPrice': 'LKR 30,000',
      'rating': 4.8,
      'reviews': 156,
      'totalReviews': 18,
      'reviewStats': {
        '5': 12,
        '4': 4,
        '3': 2,
        '2': 0,
        '1': 0,
      },
      'image': 'assets/images/cultural_triangle.jpg',
      'duration': '5 Days',
      'icon': Icons.account_balance,
      'backgroundColor': const Color(0xFF8B4513),
      'difficulty': 'Moderate',
      'groupSize': '2-15 people',
      'languages': ['English', 'Sinhala'],
      'agency': 'Heritage Tours Lanka',
      'agencyRating': 4.9,
      'agencyLogo': 'assets/images/heritage_tours_logo.png',
      'agencyEstablished': '2010',
      'agencyTours': '800+ tours completed',
      'description': 'Embark on a fascinating journey through Sri Lanka\'s Cultural Triangle, home to ancient kingdoms and UNESCO World Heritage sites. This 5-day tour takes you through the historical cities of Anuradhapura, Polonnaruwa, and the iconic Sigiriya Rock Fortress.',
      'includes': [
        'Accommodation',
        'All Meals',
        'Transportation',
        'Professional Guide',
        'Entrance Fees',
        'Cultural Performances',
      ],
      'highlights': [
        'Sigiriya Rock Fortress',
        'Ancient Temples',
        'Royal Palace Ruins',
        'Buddha Statues',
        'Archaeological Sites',
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Arrival & Anuradhapura',
          'description': 'Explore ancient stupas and monasteries',
        },
        {
          'day': 'Day 2',
          'title': 'Polonnaruwa Discovery',
          'description': 'Visit royal palace ruins and Gal Vihara',
        },
        {
          'day': 'Day 3',
          'title': 'Sigiriya Rock Fortress',
          'description': 'Climb the famous lion rock and see frescoes',
        },
        {
          'day': 'Day 4',
          'title': 'Dambulla Cave Temple',
          'description': 'Marvel at ancient Buddhist cave paintings',
        },
        {
          'day': 'Day 5',
          'title': 'Cultural Performances',
          'description': 'Enjoy traditional dances and departure',
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/cultural_past_1.jpeg',
          'caption': 'Sigiriya Lion Rock',
          'date': '2 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/cultural_past_2.jpg',
          'caption': 'Dambulla Cave Temple',
          'date': '1 month ago',
        },
        {
          'image': 'assets/images/past_tour_photos/cultural_past_3.jpg',
          'caption': 'Polonnaruwa Ruins',
          'date': '3 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/cultural_past_4.jpeg',
          'caption': 'Anuradhapura Stupa',
          'date': '2 months ago',
        },
      ],
      'category': 'Cultural',
      'isAvailable': true,
    },
    {
      'id': 'package_002',
      'title': 'Hill Country Adventure',
      'subtitle': '4 Days • Kandy, Nuwara Eliya, Ella',
      'price': 'LKR 22,000',
      'originalPrice': 'LKR 27,000',
      'rating': 4.9,
      'reviews': 203,
      'totalReviews': 22,
      'reviewStats': {
        '5': 18,
        '4': 3,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'image': 'assets/images/hill_country.jpg',
      'duration': '4 Days',
      'icon': Icons.landscape,
      'backgroundColor': const Color(0xFF228B22),
      'difficulty': 'Easy',
      'groupSize': '2-12 people',
      'languages': ['English', 'Sinhala', 'Tamil'],
      'agency': 'Mountain Escape Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/mountain_escape_logo.png',
      'agencyEstablished': '2012',
      'agencyTours': '600+ tours completed',
      'description': 'Escape to the cool, misty hills of Sri Lanka\'s central highlands. This 4-day adventure showcases the stunning landscapes of Kandy, Nuwara Eliya, and Ella.',
      'includes': [
        'Mountain Lodge Stay',
        'Meals',
        'Train Tickets',
        'Guide',
        'Tea Factory Visit',
        'Nature Walks',
      ],
      'highlights': [
        'Tea Plantations',
        'Nine Arch Bridge',
        'Little Adam\'s Peak',
        'Scenic Train Ride',
        'Mountain Views',
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Kandy Exploration',
          'description': 'Temple of Tooth and cultural show',
        },
        {
          'day': 'Day 2',
          'title': 'Scenic Train to Nuwara Eliya',
          'description': 'Tea country and colonial charm',
        },
        {
          'day': 'Day 3',
          'title': 'Ella Adventures',
          'description': 'Nine Arch Bridge and Little Adam\'s Peak',
        },
        {
          'day': 'Day 4',
          'title': 'Tea Plantation Tour',
          'description': 'Factory visit and tasting experience',
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/hill_past_1.jpg',
          'caption': 'Nine Arch Bridge',
          'date': '1 week ago',
        },
        {
          'image': 'assets/images/past_tour_photos/hill_past_2.jpeg',
          'caption': 'Tea Plantation',
          'date': '3 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/hill_past_3.jpeg',
          'caption': 'Nuwara Eliya Views',
          'date': '2 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/hill_past_4.jpeg',
          'caption': 'Train Journey',
          'date': '1 month ago',
        },
      ],
      'category': 'Adventure',
      'isAvailable': true,
    },
    {
      'id': 'package_003',
      'title': 'Southern Coast Explorer',
      'subtitle': '3 Days • Galle, Hikkaduwa, Mirissa',
      'price': 'LKR 18,000',
      'rating': 4.7,
      'reviews': 89,
      'totalReviews': 12,
      'reviewStats': {
        '5': 8,
        '4': 3,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'image': 'assets/images/southern_coast.jpg',
      'duration': '3 Days',
      'icon': Icons.waves,
      'backgroundColor': const Color(0xFF20B2AA),
      'difficulty': 'Easy',
      'groupSize': '2-20 people',
      'languages': ['English', 'Sinhala'],
      'agency': 'Coastal Adventures Sri Lanka',
      'agencyRating': 4.6,
      'agencyLogo': 'assets/images/coastal_adventures_logo.png',
      'agencyEstablished': '2015',
      'agencyTours': '400+ tours completed',
      'description': 'Discover the pristine beaches and rich maritime heritage of Sri Lanka\'s southern coast. This 3-day tour combines relaxation with exploration.',
      'includes': [
        'Beach Resort',
        'Meals',
        'Transportation',
        'Boat Trips',
        'Snorkeling Equipment',
        'Guide',
      ],
      'highlights': [
        'Galle Fort',
        'Whale Watching',
        'Beach Activities',
        'Coral Reefs',
        'Sunset Views',
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Galle Fort',
          'description': 'Historic fort and lighthouse exploration',
        },
        {
          'day': 'Day 2',
          'title': 'Whale Watching',
          'description': 'Mirissa whale watching and beach time',
        },
        {
          'day': 'Day 3',
          'title': 'Hikkaduwa',
          'description': 'Snorkeling and coral garden visit',
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/coast_past_1.jpeg',
          'caption': 'Galle Fort Sunset',
          'date': '5 days ago',
        },
        {
          'image': 'assets/images/past_tour_photos/coast_past_2.jpeg',
          'caption': 'Whale Watching',
          'date': '2 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/coast_past_3.jpeg',
          'caption': 'Hikkaduwa Beach',
          'date': '1 week ago',
        },
        {
          'image': 'assets/images/past_tour_photos/coast_past_4.jpg',
          'caption': 'Stilt Fishermen',
          'date': '3 weeks ago',
        },
      ],
      'category': 'Beach',
      'isAvailable': true,
    },
    {
      'id': 'package_004',
      'title': 'Wildlife Safari Package',
      'subtitle': '6 Days • Yala, Udawalawe, Minneriya',
      'price': 'LKR 35,000',
      'originalPrice': 'LKR 42,000',
      'rating': 4.6,
      'reviews': 127,
      'totalReviews': 16,
      'reviewStats': {
        '5': 10,
        '4': 4,
        '3': 2,
        '2': 0,
        '1': 0,
      },
      'image': 'assets/images/wildlife_safari.jpg',
      'duration': '6 Days',
      'icon': Icons.pets,
      'backgroundColor': const Color(0xFF8FBC8F),
      'difficulty': 'Moderate',
      'groupSize': '2-8 people',
      'languages': ['English', 'Sinhala', 'German'],
      'agency': 'Wild Sri Lanka Safaris',
      'agencyRating': 4.7,
      'agencyLogo': 'assets/images/wild_sri_lanka_logo.png',
      'agencyEstablished': '2008',
      'agencyTours': '1000+ tours completed',
      'description': 'Experience Sri Lanka\'s incredible biodiversity across multiple national parks. This 6-day safari adventure takes you through Yala, Udawalawe, and Minneriya.',
      'includes': [
        'Safari Lodge',
        'All Meals',
        'Safari Jeep',
        'Naturalist Guide',
        'Park Fees',
        'Binoculars',
      ],
      'highlights': [
        'Leopard Spotting',
        'Elephant Gathering',
        'Bird Watching',
        'Night Safari',
        'Nature Photography',
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Arrival at Yala',
          'description': 'Check-in and evening safari',
        },
        {
          'day': 'Day 2',
          'title': 'Full Day Yala Safari',
          'description': 'Morning and evening game drives',
        },
        {
          'day': 'Day 3',
          'title': 'Udawalawe Journey',
          'description': 'Travel to Udawalawe and elephant orphanage',
        },
        {
          'day': 'Day 4',
          'title': 'Udawalawe Safari',
          'description': 'Full day safari and bird watching',
        },
        {
          'day': 'Day 5',
          'title': 'Minneriya Safari',
          'description': 'Elephant gathering experience',
        },
        {
          'day': 'Day 6',
          'title': 'Departure',
          'description': 'Morning safari and departure',
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_1.jpg',
          'caption': 'Leopard Sighting',
          'date': '4 days ago',
        },
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_2.jpeg',
          'caption': 'Elephant Herd',
          'date': '1 week ago',
        },
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_3.jpeg',
          'caption': 'Bird Watching',
          'date': '2 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_4.jpeg',
          'caption': 'Safari Jeep',
          'date': '3 weeks ago',
        },
      ],
      'category': 'Wildlife',
      'isAvailable': true,
    },
    {
      'id': 'package_005',
      'title': 'Temple & Heritage Tour',
      'subtitle': '7 Days • Kandy, Dambulla, Galle',
      'price': 'LKR 28,000',
      'rating': 4.7,
      'reviews': 94,
      'totalReviews': 14,
      'reviewStats': {
        '5': 9,
        '4': 4,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'image': 'assets/images/temple_heritage.jpg',
      'duration': '7 Days',
      'icon': Icons.temple_buddhist,
      'backgroundColor': const Color(0xFF9370DB),
      'difficulty': 'Easy',
      'groupSize': '2-16 people',
      'languages': ['English', 'Sinhala', 'Tamil'],
      'agency': 'Spiritual Journey Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/spiritual_journey_logo.png',
      'agencyEstablished': '2011',
      'agencyTours': '700+ tours completed',
      'description': 'A spiritual and cultural journey through Sri Lanka\'s most sacred temples and heritage sites. This 7-day tour offers deep insights into Buddhist culture.',
      'includes': [
        'Accommodation',
        'Vegetarian Meals',
        'Transportation',
        'Spiritual Guide',
        'Temple Fees',
        'Meditation Sessions',
      ],
      'highlights': [
        'Temple of Tooth',
        'Cave Temples',
        'Meditation Sessions',
        'Buddhist Culture',
        'Ancient Art',
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Arrival in Kandy',
          'description': 'Temple of the Tooth visit',
        },
        {
          'day': 'Day 2',
          'title': 'Sacred Sites',
          'description': 'Ancient temples and monasteries',
        },
        {
          'day': 'Day 3',
          'title': 'Dambulla Caves',
          'description': 'Cave temple complex exploration',
        },
        {
          'day': 'Day 4',
          'title': 'Meditation Retreat',
          'description': 'Mindfulness and meditation practices',
        },
        {
          'day': 'Day 5',
          'title': 'Cultural Immersion',
          'description': 'Traditional ceremonies and rituals',
        },
        {
          'day': 'Day 6',
          'title': 'Heritage Sites',
          'description': 'Historical monuments and art',
        },
        {
          'day': 'Day 7',
          'title': 'Spiritual Conclusion',
          'description': 'Final blessings and departure',
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/temple_past_1.jpg',
          'caption': 'Temple of the Tooth',
          'date': '1 week ago',
        },
        {
          'image': 'assets/images/past_tour_photos/temple_past_2.jpeg',
          'caption': 'Cave Temple Art',
          'date': '2 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/temple_past_3.jpeg',
          'caption': 'Meditation Session',
          'date': '3 weeks ago',
        },
        {
          'image': 'assets/images/past_tour_photos/temple_past_4.jpeg',
          'caption': 'Buddhist Ceremony',
          'date': '1 month ago',
        },
      ],
      'category': 'Spiritual',
      'isAvailable': true,
    },
    {
      'id': 'package_006',
      'title': 'Adventure & Thrills',
      'subtitle': '5 Days • Kitulgala, Ella, Nuwara Eliya',
      'price': 'LKR 32,000',
      'originalPrice': 'LKR 38,000',
      'rating': 4.5,
      'reviews': 112,
      'image': 'assets/images/adventure.jpeg',
      'duration': '5 Days',
      'icon': Icons.sports,
      'backgroundColor': const Color(0xFF4682B4),
      'difficulty': 'Challenging',
      'groupSize': '2-10 people',
      'agency': 'Adrenaline Rush Adventures',
      'agencyRating': 4.5,
      'agencyLogo': 'assets/images/adrenaline_rush_logo.png',
      'agencyEstablished': '2014',
      'agencyTours': '300+ tours completed',
      'description': 'Action-packed adventure tour with white water rafting, hiking, and zip-lining.',
      'includes': ['Adventure Lodge', 'All Meals', 'Equipment', 'Instructor', 'Safety Gear', 'Insurance'],
      'highlights': ['White Water Rafting', 'Zip Lining', 'Rock Climbing', 'Abseiling', 'Jungle Trekking'],
      'category': 'Adventure',
      'isAvailable': true,
    },
    {
      'id': 'package_007',
      'title': 'Romantic Getaway',
      'subtitle': '4 Days • Bentota, Galle, Mirissa',
      'price': 'LKR 45,000',
      'originalPrice': 'LKR 55,000',
      'rating': 4.8,
      'reviews': 78,
      'image': 'assets/images/romantic.jpg',
      'duration': '4 Days',
      'icon': Icons.favorite,
      'backgroundColor': const Color(0xFFFF69B4),
      'difficulty': 'Easy',
      'groupSize': '2 people',
      'agency': 'Romance Lanka Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/romance_lanka_logo.png',
      'agencyEstablished': '2016',
      'agencyTours': '200+ tours completed',
      'description': 'Perfect romantic escape with luxury resorts, sunset dinners, and couple activities.',
      'includes': ['Luxury Resort', 'Candlelight Dinners', 'Spa', 'Private Tours', 'Champagne', 'Flowers'],
      'highlights': ['Sunset Cruise', 'Couple Spa', 'Beach Dining', 'Private Beach', 'Photography Session'],
      'category': 'Romance',
      'isAvailable': true,
    },
    {
      'id': 'package_008',
      'title': 'Family Fun Package',
      'subtitle': '6 Days • Colombo, Kandy, Bentota',
      'price': 'LKR 38,000',
      'originalPrice': 'LKR 45,000',
      'rating': 4.6,
      'reviews': 134,
      'image': 'assets/images/family.jpg',
      'duration': '6 Days',
      'icon': Icons.family_restroom,
      'backgroundColor': const Color(0xFF32CD32),
      'difficulty': 'Easy',
      'groupSize': '2-20 people',
      'agency': 'Family Adventures Lanka',
      'agencyRating': 4.7,
      'agencyLogo': 'assets/images/family_adventures_logo.png',
      'agencyEstablished': '2013',
      'agencyTours': '500+ tours completed',
      'description': 'Family-friendly tour with activities suitable for all ages and comfortable accommodations.',
      'includes': ['Family Rooms', 'Kid-friendly Meals', 'Transportation', 'Activities', 'Child Care', 'Entertainment'],
      'highlights': ['Zoo Visit', 'Beach Games', 'Cultural Shows', 'Water Parks', 'Educational Tours'],
      'category': 'Family',
      'isAvailable': true,
    },
    {
      'id': 'package_009',
      'title': 'Photography Expedition',
      'subtitle': '8 Days • Sigiriya, Ella, Yala, Galle',
      'price': 'LKR 42,000',
      'originalPrice': 'LKR 50,000',
      'rating': 4.7,
      'reviews': 65,
      'image': 'assets/images/photography.jpg',
      'duration': '8 Days',
      'icon': Icons.camera_alt,
      'backgroundColor': const Color(0xFF8A2BE2),
      'difficulty': 'Moderate',
      'groupSize': '2-8 people',
      'agency': 'Lens Lanka Photography Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/lens_lanka_logo.png',
      'agencyEstablished': '2017',
      'agencyTours': '150+ tours completed',
      'description': 'Capture the essence of Sri Lanka through your lens with expert photography guidance.',
      'includes': ['Photography Guide', 'Equipment Rental', 'Accommodation', 'Meals', 'Transport', 'Editing Workshop'],
      'highlights': ['Golden Hour Shoots', 'Wildlife Photography', 'Landscape Shots', 'Cultural Portraits', 'Post-processing'],
      'category': 'Photography',
      'isAvailable': false,
    },
    {
      'id': 'package_010',
      'title': 'Ayurveda Wellness Retreat',
      'subtitle': '10 Days • Bentota, Hikkaduwa',
      'price': 'LKR 55,000',
      'rating': 4.9,
      'reviews': 43,
      'image': 'assets/images/ayurveda.jpg',
      'duration': '10 Days',
      'icon': Icons.healing,
      'backgroundColor': const Color(0xFF228B22),
      'difficulty': 'Easy',
      'groupSize': '1-6 people',
      'agency': 'Wellness Sri Lanka',
      'agencyRating': 4.9,
      'agencyLogo': 'assets/images/wellness_lanka_logo.png',
      'agencyEstablished': '2009',
      'agencyTours': '800+ treatments completed',
      'description': 'Rejuvenate your mind, body, and soul with authentic Ayurvedic treatments and wellness practices.',
      'includes': ['Ayurveda Resort', 'Consultation', 'Treatments', 'Herbal Meals', 'Yoga Sessions', 'Meditation'],
      'highlights': ['Panchakarma', 'Herbal Baths', 'Yoga Classes', 'Meditation', 'Organic Meals'],
      'category': 'Wellness',
      'isAvailable': true,
    },
  ];

  // Helper Methods

  // Get hotel by ID
  static Map<String, dynamic>? getHotelById(String id) {
    try {
      return hotels.firstWhere((hotel) => hotel['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get travel agency by ID
  static Map<String, dynamic>? getTravelAgencyById(String id) {
    try {
      return travelAgencies.firstWhere((agency) => agency['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get tour package by ID
  static Map<String, dynamic>? getTourPackageById(String id) {
    try {
      return tourPackages.firstWhere((package) => package['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get popular hotels (first 5)
  static List<Map<String, dynamic>> getPopularHotels() {
    return hotels.take(5).toList();
  }

  // Get popular travel agencies (first 5)
  static List<Map<String, dynamic>> getPopularTravelAgencies() {
    return travelAgencies.take(5).toList();
  }

  // Get popular tour packages (first 5)
  static List<Map<String, dynamic>> getPopularTourPackages() {
    return tourPackages.take(5).toList();
  }

  // Get available hotels
  static List<Map<String, dynamic>> getAvailableHotels() {
    return hotels.where((hotel) => hotel['isAvailable'] == true).toList();
  }

  // Get available travel agencies
  static List<Map<String, dynamic>> getAvailableTravelAgencies() {
    return travelAgencies.where((agency) => agency['isAvailable'] == true).toList();
  }

  // Get available tour packages
  static List<Map<String, dynamic>> getAvailableTourPackages() {
    return tourPackages.where((package) => package['isAvailable'] == true).toList();
  }

  // Search methods
  static List<Map<String, dynamic>> searchHotels(String query) {
    if (query.isEmpty) return hotels;

    return hotels.where((hotel) {
      final name = hotel['name']?.toString().toLowerCase() ?? '';
      final location = hotel['location']?.toString().toLowerCase() ?? '';
      final description = hotel['description']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          location.contains(searchQuery) ||
          description.contains(searchQuery);
    }).toList();
  }

  static List<Map<String, dynamic>> searchTravelAgencies(String query) {
    if (query.isEmpty) return travelAgencies;

    return travelAgencies.where((agency) {
      final name = agency['name']?.toString().toLowerCase() ?? '';
      final location = agency['location']?.toString().toLowerCase() ?? '';
      final description = agency['description']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          location.contains(searchQuery) ||
          description.contains(searchQuery);
    }).toList();
  }

  static List<Map<String, dynamic>> searchTourPackages(String query) {
    if (query.isEmpty) return tourPackages;

    return tourPackages.where((package) {
      final title = package['title']?.toString().toLowerCase() ?? '';
      final subtitle = package['subtitle']?.toString().toLowerCase() ?? '';
      final description = package['description']?.toString().toLowerCase() ?? '';
      final category = package['category']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) ||
          subtitle.contains(searchQuery) ||
          description.contains(searchQuery) ||
          category.contains(searchQuery);
    }).toList();
  }

  // Filter methods
  static List<Map<String, dynamic>> filterHotelsByRating(double minRating) {
    return hotels.where((hotel) => (hotel['rating'] ?? 0.0) >= minRating).toList();
  }

  static List<Map<String, dynamic>> filterTourPackagesByCategory(String category) {
    if (category.isEmpty) return tourPackages;
    return tourPackages.where((package) =>
    package['category']?.toString().toLowerCase() == category.toLowerCase()).toList();
  }

  static List<Map<String, dynamic>> filterTourPackagesByDifficulty(String difficulty) {
    if (difficulty.isEmpty) return tourPackages;
    return tourPackages.where((package) =>
    package['difficulty']?.toString().toLowerCase() == difficulty.toLowerCase()).toList();
  }

  // Utility methods
  static String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  // File: lib/data/data.dart (final part)

  static IconData getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'car':
      case 'luxury car':
      case 'standard car':
      case 'classic car':
      case 'adventure car':
        return Icons.directions_car;
      case 'van':
      case 'premium van':
      case 'family van':
      case 'tourist van':
      case 'adventure van':
        return Icons.airport_shuttle;
      case 'bus':
      case 'mini bus':
      case 'coach bus':
      case 'tour bus':
      case 'group bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cultural':
        return Colors.brown;
      case 'adventure':
        return Colors.green;
      case 'beach':
        return Colors.teal;
      case 'wildlife':
        return Colors.orange;
      case 'spiritual':
        return Colors.purple;
      case 'romance':
        return Colors.pink;
      case 'family':
        return Colors.blue;
      case 'photography':
        return Colors.indigo;
      case 'wellness':
        return Colors.lightGreen;
      case 'luxury':
        return Colors.amber;
      case 'general':
        return Colors.blueGrey;
      case 'scenic':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'challenging':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get room status color
  static Color getRoomStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'maintenance':
        return Colors.orange;
      case 'booked':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  // Get room status text
  static String getRoomStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'maintenance':
        return 'Maintenance';
      case 'booked':
        return 'Booked';
      default:
        return 'Available';
    }
  }

  // Calculate total price for distance
  static String calculateTotalPrice(int pricePerKm, int distance) {
    int totalPrice = pricePerKm * distance;
    return formatPrice(totalPrice);
  }

  // Get tour package savings percentage
  static int getSavingsPercentage(String originalPrice, String currentPrice) {
    try {
      double original = double.parse(originalPrice.replaceAll('LKR ', '').replaceAll(',', ''));
      double current = double.parse(currentPrice.replaceAll('LKR ', '').replaceAll(',', ''));
      return ((original - current) / original * 100).round();
    } catch (e) {
      return 0;
    }
  }

  // Sort methods
  static List<Map<String, dynamic>> sortHotelsByRating({bool ascending = false}) {
    List<Map<String, dynamic>> sortedHotels = List.from(hotels);
    sortedHotels.sort((a, b) {
      double ratingA = a['rating'] ?? 0.0;
      double ratingB = b['rating'] ?? 0.0;
      return ascending ? ratingA.compareTo(ratingB) : ratingB.compareTo(ratingA);
    });
    return sortedHotels;
  }

  static List<Map<String, dynamic>> sortHotelsByPrice({bool ascending = true}) {
    List<Map<String, dynamic>> sortedHotels = List.from(hotels);
    sortedHotels.sort((a, b) {
      String priceA = a['price'] ?? 'LKR 0';
      String priceB = b['price'] ?? 'LKR 0';

      int valueA = int.tryParse(priceA.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      int valueB = int.tryParse(priceB.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
    return sortedHotels;
  }

  static List<Map<String, dynamic>> sortTourPackagesByRating({bool ascending = false}) {
    List<Map<String, dynamic>> sortedPackages = List.from(tourPackages);
    sortedPackages.sort((a, b) {
      double ratingA = a['rating'] ?? 0.0;
      double ratingB = b['rating'] ?? 0.0;
      return ascending ? ratingA.compareTo(ratingB) : ratingB.compareTo(ratingA);
    });
    return sortedPackages;
  }

  static List<Map<String, dynamic>> sortTourPackagesByPrice({bool ascending = true}) {
    List<Map<String, dynamic>> sortedPackages = List.from(tourPackages);
    sortedPackages.sort((a, b) {
      String priceA = a['price'] ?? 'LKR 0';
      String priceB = b['price'] ?? 'LKR 0';

      int valueA = int.tryParse(priceA.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      int valueB = int.tryParse(priceB.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
    return sortedPackages;
  }

  static List<Map<String, dynamic>> sortTourPackagesByDuration({bool ascending = true}) {
    List<Map<String, dynamic>> sortedPackages = List.from(tourPackages);
    sortedPackages.sort((a, b) {
      String durationA = a['duration'] ?? '0 Days';
      String durationB = b['duration'] ?? '0 Days';

      int valueA = int.tryParse(durationA.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      int valueB = int.tryParse(durationB.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
    return sortedPackages;
  }

  static List<Map<String, dynamic>> sortTravelAgenciesByRating({bool ascending = false}) {
    List<Map<String, dynamic>> sortedAgencies = List.from(travelAgencies);
    sortedAgencies.sort((a, b) {
      double ratingA = a['rating'] ?? 0.0;
      double ratingB = b['rating'] ?? 0.0;
      return ascending ? ratingA.compareTo(ratingB) : ratingB.compareTo(ratingA);
    });
    return sortedAgencies;
  }

  // Statistics methods
  static Map<String, dynamic> getHotelStatistics() {
    if (hotels.isEmpty) return {};

    double totalRating = hotels.fold(0.0, (sum, hotel) => sum + (hotel['rating'] ?? 0.0));
    double averageRating = totalRating / hotels.length;

    // Fix: Explicitly cast to List<double>
    List<double> ratings = hotels
        .map((h) => (h['rating'] as num?)?.toDouble() ?? 0.0)
        .cast<double>()
        .toList();

    ratings.sort();
    double highestRating = ratings.last;
    double lowestRating = ratings.first;

    int availableCount = hotels.where((h) => h['isAvailable'] == true).length;

    return {
      'totalHotels': hotels.length,
      'availableHotels': availableCount,
      'averageRating': double.parse(averageRating.toStringAsFixed(1)),
      'highestRating': highestRating,
      'lowestRating': lowestRating,
    };
  }

  static Map<String, dynamic> getTourPackageStatistics() {
    if (tourPackages.isEmpty) return {};

    double totalRating = tourPackages.fold(0.0, (sum, package) => sum + (package['rating'] ?? 0.0));
    double averageRating = totalRating / tourPackages.length;

    int availableCount = tourPackages.where((p) => p['isAvailable'] == true).length;

    Map<String, int> categoryCounts = {};
    for (var package in tourPackages) {
      String category = package['category'] ?? 'Unknown';
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    return {
      'totalPackages': tourPackages.length,
      'availablePackages': availableCount,
      'averageRating': double.parse(averageRating.toStringAsFixed(1)),
      'categoryCounts': categoryCounts,
    };
  }

  static Map<String, dynamic> getTravelAgencyStatistics() {
    if (travelAgencies.isEmpty) return {};

    double totalRating = travelAgencies.fold(0.0, (sum, agency) => sum + (agency['rating'] ?? 0.0));
    double averageRating = totalRating / travelAgencies.length;

    int availableCount = travelAgencies.where((a) => a['isAvailable'] == true).length;

    int totalVehicles = 0;
    int totalDrivers = 0;

    for (var agency in travelAgencies) {
      totalVehicles += (agency['vehicles'] as List?)?.length ?? 0;
      totalDrivers += (agency['drivers'] as List?)?.length ?? 0;
    }

    return {
      'totalAgencies': travelAgencies.length,
      'availableAgencies': availableCount,
      'averageRating': double.parse(averageRating.toStringAsFixed(1)),
      'totalVehicles': totalVehicles,
      'totalDrivers': totalDrivers,
    };
  }

  // Get categories
  static List<String> getTourPackageCategories() {
    Set<String> categories = {};
    for (var package in tourPackages) {
      if (package['category'] != null) {
        categories.add(package['category']);
      }
    }
    return categories.toList()..sort();
  }

  static List<String> getTourPackageDifficulties() {
    Set<String> difficulties = {};
    for (var package in tourPackages) {
      if (package['difficulty'] != null) {
        difficulties.add(package['difficulty']);
      }
    }
    return difficulties.toList();
  }

  static List<String> getTravelAgencyCategories() {
    Set<String> categories = {};
    for (var agency in travelAgencies) {
      if (agency['category'] != null) {
        categories.add(agency['category']);
      }
    }
    return categories.toList()..sort();
  }

  // Recommendation methods
  static List<Map<String, dynamic>> getRecommendedHotels(String hotelId) {
    var currentHotel = getHotelById(hotelId);
    if (currentHotel == null) return [];

    double currentRating = currentHotel['rating'] ?? 0.0;
    String currentLocation = currentHotel['location'] ?? '';

    return hotels.where((hotel) {
      return hotel['id'] != hotelId &&
          hotel['isAvailable'] == true &&
          (hotel['rating'] ?? 0.0) >= currentRating - 0.5 &&
          hotel['location'].toString().contains(currentLocation.split(',').first);
    }).take(3).toList();
  }

  static List<Map<String, dynamic>> getRecommendedTourPackages(String packageId) {
    var currentPackage = getTourPackageById(packageId);
    if (currentPackage == null) return [];

    String currentCategory = currentPackage['category'] ?? '';
    double currentRating = currentPackage['rating'] ?? 0.0;

    return tourPackages.where((package) {
      return package['id'] != packageId &&
          package['isAvailable'] == true &&
          (package['category'] == currentCategory ||
              (package['rating'] ?? 0.0) >= currentRating - 0.3);
    }).take(3).toList();
  }

  static List<Map<String, dynamic>> getRecommendedTravelAgencies(String agencyId) {
    var currentAgency = getTravelAgencyById(agencyId);
    if (currentAgency == null) return [];

    String currentCategory = currentAgency['category'] ?? '';
    double currentRating = currentAgency['rating'] ?? 0.0;

    return travelAgencies.where((agency) {
      return agency['id'] != agencyId &&
          agency['isAvailable'] == true &&
          (agency['category'] == currentCategory ||
              (agency['rating'] ?? 0.0) >= currentRating - 0.3);
    }).take(3).toList();
  }

  // Validation methods
  static bool isValidHotelId(String id) {
    return hotels.any((hotel) => hotel['id'] == id);
  }

  static bool isValidTravelAgencyId(String id) {
    return travelAgencies.any((agency) => agency['id'] == id);
  }

  static bool isValidTourPackageId(String id) {
    return tourPackages.any((package) => package['id'] == id);
  }

  // Get all unique locations
  static List<String> getAllLocations() {
    Set<String> locations = {};

    for (var hotel in hotels) {
      if (hotel['location'] != null) {
        locations.add(hotel['location']);
      }
    }

    for (var agency in travelAgencies) {
      if (agency['location'] != null) {
        locations.add(agency['location']);
      }
    }

    return locations.toList()..sort();
  }

  // Get price range for hotels
  static Map<String, int> getHotelPriceRange() {
    if (hotels.isEmpty) return {'min': 0, 'max': 0};

    List<int> prices = hotels.map((hotel) {
      String priceStr = hotel['price'] ?? 'LKR 0';
      return int.tryParse(priceStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    }).where((price) => price > 0).toList();

    if (prices.isEmpty) return {'min': 0, 'max': 0};

    prices.sort();
    return {'min': prices.first, 'max': prices.last};
  }

  // Get price range for tour packages
  static Map<String, int> getTourPackagePriceRange() {
    if (tourPackages.isEmpty) return {'min': 0, 'max': 0};

    List<int> prices = tourPackages.map((package) {
      String priceStr = package['price'] ?? 'LKR 0';
      return int.tryParse(priceStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    }).where((price) => price > 0).toList();

    if (prices.isEmpty) return {'min': 0, 'max': 0};

    prices.sort();
    return {'min': prices.first, 'max': prices.last};
  }
}