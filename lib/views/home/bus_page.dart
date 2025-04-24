import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketmart/search_results_page.dart';

class BusPage extends StatefulWidget {
  const BusPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusPageState createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
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
          image: AssetImage('assets/images/whitebus.jpeg'),
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
            _buildBusOperatorsSection(),
            const SizedBox(height: 20),
            const PopularBusRoutesSection(),
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
            icon: Icons.directions_bus,
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
      child: const Text('Find Buses', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildBusOperatorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Bus Operators'),
        SizedBox(
          height: 135,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'Andhra Pradesh'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'Himachal Road'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'Kadamba'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'South Bengal'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'Telangana'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'Uttar Pradesh'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'West Bengal'),
              BusOperatorWidget(image: 'assets/images/bus_background.png', name: 'North Bengal'),
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
      'BOOK BUS TICKET',
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

class PopularBusRouteWidget extends StatelessWidget {
  final String route;
  final String destinations;

  const PopularBusRouteWidget({
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

class PopularBusRoutesSection extends StatelessWidget {
  const PopularBusRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Popular Bus Routes'),
        PopularBusRouteWidget(route: 'Chennai to Bangalore', destinations: 'Bangalore, Chennai'),
        PopularBusRouteWidget(route: 'Hyderabad to Vijayawada', destinations: 'Hyderabad, Vijayawada'),
        PopularBusRouteWidget(route: 'Mumbai to Pune', destinations: 'Mumbai, Pune'),
        PopularBusRouteWidget(route: 'Bangalore to Chennai', destinations: 'Bangalore, Chennai'),
      ],
    );
  }
}


class BusOperatorWidget extends StatelessWidget {
  final String image;
  final String name;

  const BusOperatorWidget({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
