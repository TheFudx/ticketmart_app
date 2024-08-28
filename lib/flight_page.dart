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
    'Delhi', 'Mumbai', 'Chennai', 'Bangalore', 'Hyderabad',
    'Pune', 'Kolkata', 'Chandigarh'
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
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(dateFormat),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
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

  Widget _buildContent(DateFormat dateFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const _Title(),
            const SizedBox(height: 20),
            _buildInputForm(dateFormat),
            const SizedBox(height: 20),
            _buildSearchButton(),
            const SizedBox(height: 20),
            _buildFlightOperatorsSection(),
            const SizedBox(height: 20),
            const PopularFlightRoutesSection(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '            Departure',
          style: TextStyle(fontSize: 14),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, size: 20, color: Colors.black),
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

  Widget _buildFlightOperatorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Flight Operators'),
        SizedBox(
          height: 135,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              FlightOperatorWidget(image: 'assets/images/flight_background.png', name: 'Air India'),
              FlightOperatorWidget(image: 'assets/images/flight_background.png', name: 'IndiGo'),
              FlightOperatorWidget(image: 'assets/images/flight_background.png', name: 'SpiceJet'),
              FlightOperatorWidget(image: 'assets/images/flight_background.png', name: 'GoAir'),
              FlightOperatorWidget(image: 'assets/images/flight_background.png', name: 'Vistara'),
              FlightOperatorWidget(image: 'assets/images/flight_background.png', name: 'AirAsia India'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'BOOK FLIGHT TICKET',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PopularFlightRouteWidget extends StatelessWidget {
  final String route;
  final String destinations;

  const PopularFlightRouteWidget({
    super.key,
    required this.route,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              route,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1),
            Text(
              destinations,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularFlightRoutesSection extends StatelessWidget {
  const PopularFlightRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Popular Flight Routes'),
        SizedBox(height: 10),
        PopularFlightRouteWidget(
          route: 'DEL to BOM',
          destinations: 'New Delhi to Mumbai',
        ),
        PopularFlightRouteWidget(
          route: 'BLR to HYD',
          destinations: 'Bangalore to Hyderabad',
        ),
        PopularFlightRouteWidget(
          route: 'DEL to MAA',
          destinations: 'New Delhi to Chennai',
        ),
        PopularFlightRouteWidget(
          route: 'CCU to DEL',
          destinations: 'Kolkata to New Delhi',
        ),
      ],
    );
  }
}

class FlightOperatorWidget extends StatelessWidget {
  final String image;
  final String name;

  const FlightOperatorWidget({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
