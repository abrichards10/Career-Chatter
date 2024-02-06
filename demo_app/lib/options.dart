import 'package:dropdown_textfield/dropdown_textfield.dart';

const List<String> professions = [
  "Accountant",
  "Actor",
  "Architect",
  "Artist",
  "Astronomer",
  "Athlete",
  "Author",
  "Baker",
  "Barber",
  "Bartender",
  "Biologist",
  "Botanist",
  "Butcher",
  "Carpenter",
  "Chef",
  "Chemist",
  "Coach",
  "Composer",
  "Computer programmer",
  "Dentist",
  "Designer",
  "Detective",
  "Doctor",
  "Economist",
  "Electrician",
  "Engineer",
  "Entrepreneur",
  "Farmer",
  "Firefighter",
  "Fisherman",
  "Flight attendant",
  "Gardener",
  "Geologist",
  "Graphic designer",
  "Hairdresser",
  "Historian",
  "Interior designer",
  "Interpreter",
  "Journalist",
  "Judge",
  "Lawyer",
  "Librarian",
  "Linguist",
  "Mathematician",
  "Mechanic",
  "Meteorologist",
  "Model",
  "Musician",
  "Nurse",
  "Optometrist",
  "Painter",
  "Pharmacist",
  "Photographer",
  "Physicist",
  "Pilot",
  "Plumber",
  "Police officer",
  "Politician",
  "Professor",
  "Psychologist",
  "Public relations",
  "Radiologist",
  "Real estate agent",
  "Receptionist",
  "Scientist",
  "Sculptor",
  "Secretary",
  "Social worker",
  "Software developer",
  "Soldier",
  "Statistician",
  "Surgeon",
  "Teacher",
  "Translator",
  "Travel agent",
  "Veterinarian",
  "Waiter",
  "Web developer",
  "Writer",
  "Zoologist",
  "Account manager",
  "Acupuncturist",
  "Air traffic controller",
  "Animator",
  "Appraiser",
  "Aquarist",
  "Arborist",
  "Archaeologist",
  "Audiologist",
  "Auto mechanic",
  "Bank teller",
  "Beekeeper",
  "Biochemist",
  "Biomedical engineer",
  "Blacksmith",
  "Boilermaker",
  "Bookkeeper",
  "Bricklayer",
  "Broker",
  "Bus driver",
  "Calligrapher",
  "Cameraman",
  "Cartographer",
  "Chaplain",
  "Chiropractor",
  "Cinematographer",
  "Coachbuilder",
  "Cobbler",
  "Concierge",
  "Copywriter",
  "Criminal investigator",
  "Cryptographer",
  "Curator",
  "Dental hygienist",
  "Dietitian",
  "Dispatcher",
  "Diver",
  "Dog trainer",
  "Ecologist",
  "Editor",
  "Electrician",
  "Embryologist",
  "Epidemiologist",
  "Ethologist",
  "Exterminator",
  "Fashion designer",
  "Film director",
  "Film editor",
  "Financial advisor",
  "Firefighter",
  "Fisherman",
  "Flight attendant",
  "Florist",
  "Forensic scientist",
  "Furniture maker",
  "Game designer",
  "Game warden",
  "Gemologist",
  "Geneticist",
  "Geographer",
  "Geoscientist",
  "Glassblower",
  "Glazier",
  "Gravedigger",
  "Hairdresser",
  "Harpist",
  "Horticulturist",
  "Hydrologist",
  "Illustrator",
  "Industrial designer",
  "Insurance agent",
  "Interpreter",
  "Ironworker",
  "Janitor",
  "Jeweler",
  "Joiner",
  "Laboratory technician",
  "Landscaper",
  "Landscape architect",
  "Leatherworker",
  "Legal assistant",
  "Lobbyist",
  "Locksmith",
  "Makeup artist",
  "Marine biologist",
  "Marine engineer",
  "Marine surveyor",
  "Market researcher",
  "Massage therapist",
  "Materials scientist",
  "Mathematician",
  "Mechanical engineer",
  "Medical examiner",
  "Medical illustrator",
  "Metalworker",
  "Meteorologist",
  "Microbiologist",
  "Mortician",
  "Museum curator",
  "Music producer",
  "Music therapist",
  "Nanny",
  "Naval architect",
  "Network administrator",
  "Notary public",
  "Numismatist",
  "Nutritionist",
  "Occupational therapist",
  "Oceanographer",
  "Operations manager",
  "Ornithologist",
  "Orthodontist",
  "Orthopedic surgeon",
  "Orthoptist",
  "Osteopath",
  "Painter",
  "Paleontologist",
  "Paramedic",
  "Parole officer",
  "Patent attorney",
  "Pathologist",
  "Pedicurist",
  "Perfumer",
  "Personal trainer",
  "Phlebotomist",
  "Physical therapist",
  "Physician assistant",
  "Pianist",
  "Plastic surgeon",
  "Podiatrist",
  "Police detective",
  "Postal worker",
  "Potter",
  "Preschool teacher",
  "Private investigator",
  "Probation officer",
  "Process engineer",
  "Producer",
  "Professional athlete",
  "Project manager",
  "Proofreader",
  "Property manager",
  "Public defender",
  "Public relations specialist",
  "Quality control inspector",
  "Radiation therapist",
  "Radio host",
  "Railroad conductor",
  "Receptionist",
  "Recreational therapist",
  "Referee",
  "Reflexologist",
  "Registered nurse",
  "Rehabilitation counselor",
  "Research scientist",
  "Respiratory therapist",
  "Restaurateur",
  "Retail manager",
  "Robotics engineer",
  "Sailor",
  "Sales manager",
  "Satellite engineer",
  "Sculptor",
  "Security guard",
  "Set designer",
  "Sewing machine operator",
  "Shoemaker",
  "Singer",
  "Social media manager",
  "Social worker",
  "Soil scientist",
  "Songwriter",
  "Speech therapist",
  "Sports agent",
  "Sports announcer",
  "Sports coach",
  "Sports commentator",
  "Sports psychologist",
  "Statistician",
  "Steelworker",
  "Stenographer",
  "Stockbroker",
  "Stonecutter",
  "Stonemason",
  "Surveyor",
  "Tattoo artist",
  "Taxidermist",
  "Taxonomist",
  "Teacher",
  "Technical writer",
  "Telecommunications engineer",
  "Telemarketer",
  "Television producer",
  "Textile designer",
  "Theater director",
  "Theater producer",
  "Tool and dye maker",
];

const List<String> locations = [
  "Albuquerque, New Mexico",
  "Anaheim, California",
  "Anchorage, Alaska",
  "Arlington, Texas",
  "Atlanta, Georgia",
  "Aurora, Colorado",
  "Austin, Texas",
  "Bakersfield, California",
  "Baltimore, Maryland",
  "Baton Rouge, Louisiana",
  "Birmingham, Alabama",
  "Boston, Massachusetts",
  "Buffalo, New York",
  "Chandler, Arizona",
  "Charlotte, North Carolina",
  "Chattanooga, Tennessee",
  "Chesapeake, Virginia",
  "Chicago, Illinois",
  "Chula Vista, California",
  "Cincinnati, Ohio",
  "Cleveland, Ohio",
  "Colorado Springs, Colorado",
  "Columbus, Ohio",
  "Corpus Christi, Texas",
  "Dallas, Texas",
  "Denver, Colorado",
  "Des Moines, Iowa",
  "Detroit, Michigan",
  "Durham, North Carolina",
  "El Paso, Texas",
  "Fort Wayne, Indiana",
  "Fort Worth, Texas",
  "Fremont, California",
  "Fresno, California",
  "Garland, Texas",
  "Gilbert, Arizona",
  "Glendale, Arizona",
  "Glendale, California",
  "Grand Prairie, Texas",
  "Grand Rapids, Michigan",
  "Greensboro, North Carolina",
  "Henderson, Nevada",
  "Hialeah, Florida",
  "Honolulu, Hawaii",
  "Houston, Texas",
  "Huntington Beach, California",
  "Huntsville, Alabama",
  "Indianapolis, Indiana",
  "Irvine, California",
  "Irving, Texas",
  "Jackson, Mississippi",
  "Jacksonville, Florida",
  "Jersey City, New Jersey",
  "Kansas City, Missouri",
  "Knoxville, Tennessee",
  "Las Vegas, Nevada",
  "Lexington, Kentucky",
  "Lincoln, Nebraska",
  "Little Rock, Arkansas",
  "Long Beach, California",
  "Los Angeles, California",
  "Louisville, Kentucky",
  "Lubbock, Texas",
  "Madison, Wisconsin",
  "Memphis, Tennessee",
  "Mesa, Arizona",
  "Miami, Florida",
  "Milwaukee, Wisconsin",
  "Minneapolis, Minnesota",
  "Mobile, Alabama",
  "Montgomery, Alabama",
  "Moreno Valley, California",
  "Nashville, Tennessee",
  "Newark, New Jersey",
  "New Orleans, Louisiana",
  "Newport News, Virginia",
  "Norfolk, Virginia",
  "North Las Vegas, Nevada",
  "Oakland, California",
  "Oceanside, California",
  "Oklahoma City, Oklahoma",
  "Omaha, Nebraska",
  "Orlando, Florida",
  "Overland Park, Kansas",
  "Oxnard, California",
  "Philadelphia, Pennsylvania",
  "Phoenix, Arizona",
  "Plano, Texas",
  "Portland, Oregon",
  "Providence, Rhode Island",
  "Raleigh, North Carolina",
  "Reno, Nevada",
  "Richmond, Virginia",
  "Riverside, California",
  "Rochester, New York",
  "Sacramento, California",
  "Saint Paul, Minnesota",
  "Salt Lake City, Utah",
  "San Antonio, Texas",
  "San Bernardino, California",
  "San Diego, California",
  "San Francisco, California",
  "San Jose, California",
  "Santa Ana, California",
  "Santa Clarita, California",
  "Santa Rosa, California",
  "Scottsdale, Arizona",
  "Seattle, Washington",
  "Spokane, Washington",
  "St. Petersburg, Florida",
  "Stockton, California",
  "Tallahassee, Florida",
  "Tampa, Florida",
  "Tempe, Arizona",
  "Toledo, Ohio",
  "Tucson, Arizona",
  "Tulsa, Oklahoma",
  "Virginia Beach, Virginia",
  "Washington, District of Columbia",
  "Wichita, Kansas",
  "Winston-Salem, North Carolina",
  "Worcester, Massachusetts",
  "Yonkers, New York"
];

// MAP THE PROFESSIONS TO DROPDOWN VALUES
List<DropDownValueModel> dropdownValues = professions
    .map(
        (profession) => DropDownValueModel(name: profession, value: profession))
    .toList();

// MAP THE LOCATIONS TO DROPDOWN VALUES
List<DropDownValueModel> dropdownValuesLocation = locations
    .map((location) => DropDownValueModel(name: location, value: location))
    .toList();

