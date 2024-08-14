import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketmart/search_results_page.dart';

class FlightPage extends StatefulWidget {
  const FlightPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlightPageState createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  final List<String> _cities = [
    'Delhi',
    'Mumbai',
    'Chennai',
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Chandigarh'
  ];

  String? _selectedSourceCity;
  String? _selectedDestinationCity;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now;
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _performSearch() {
    final source = _selectedSourceCity ?? 'Not Selected';
    final destination = _selectedDestinationCity ?? 'Not Selected';
    final date = _selectedDate != null
        ? DateFormat('EEE, d MMM').format(_selectedDate!)
        : 'Not Selected';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          source: source,
          destination: destination,
          date: date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM');

    return Scaffold(
      appBar: _buildAppBar(context),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(context, dateFormat),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/whiteflight.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.7),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DateFormat dateFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'BOOK FLIGHT TICKET',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildInputForm(dateFormat),
            const SizedBox(height: 20),
            _buildSearchButton(),
            const SizedBox(height: 20),
            _buildflightOperatorsSection(),
            const SizedBox(height: 20),
            const PopularflightRoutesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm(DateFormat dateFormat) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        children: [
          _buildDropdownWithIcon(
            icon: Icons.flight,
            hint: 'Select Source City',
            value: _selectedSourceCity,
            onChanged: (newValue) {
              setState(() {
                _selectedSourceCity = newValue;
              });
            },
          ),
          const Divider(thickness: 1),
          _buildDropdownWithIcon(
            icon: Icons.location_on,
            hint: 'Select Destination City',
            value: _selectedDestinationCity,
            onChanged: (newValue) {
              setState(() {
                _selectedDestinationCity = newValue;
              });
            },
          ),
          const Divider(thickness: 1),
          _buildDateAndTimeSelector(dateFormat),
        ],
      ),
    );
  }

  Widget _buildDropdownWithIcon({
    required IconData icon,
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade900),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButton<String>(
            value: value,
            hint: Text(hint),
            isExpanded: true,
            items: _cities.map((city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: onChanged,
            underline: Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateAndTimeSelector(DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '            Departure',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, size: 20),
                    border: InputBorder.none,
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Today, ${dateFormat.format(DateTime.now())}'
                        : dateFormat.format(_selectedDate!),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _performSearch,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: const Text('Find Flights', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildflightOperatorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'flight Operators',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'Andhra Pradesh'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'Himachal Road'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'Kadamba'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'South Bengal'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'Telangana'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'Uttar Pradesh'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'West Bengal'),
              FlightOperatorWidget(image: 'assets/images/bus_background.png', name: 'North Bengal'),
            ],
          ),
        ),
      ],
    );
  }
}

class PopularflightRouteWidget extends StatelessWidget {
  final String route;
  final String destinations;

  const PopularflightRouteWidget({
    super.key,
    required this.route,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            destinations,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class PopularflightRoutesSection extends StatelessWidget {
  const PopularflightRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular flight Routes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        PopularflightRouteWidget(
          route: 'Delhi to Chandigarh flightes',
          destinations: 'North Delhi, Ambala, Karnal, Kurukshetra',
        ),
        PopularflightRouteWidget(
          route: 'Bangalore to Hyderabad flightes',
          destinations: 'Bangalore, Anantapur, Kurnool, Mahbubnagar',
        ),
        PopularflightRouteWidget(
          route: 'Chennai to Bangalore flightes',
          destinations: 'Chennai, Vellore, Krishnagiri, Hosur',
        ),
        PopularflightRouteWidget(
          route: 'Hyderabad to Goa flightes',
          destinations: 'Hyderabad, Hubli, Ankola, Karwar',
        ),
      ],
    );
  }
}

class FlightOperatorWidget extends StatelessWidget {
  final String image;
  final String name;

  const FlightOperatorWidget({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        color: Colors.transparent.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: 90,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
