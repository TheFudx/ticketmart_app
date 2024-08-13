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
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay initialTime = _selectedTime ?? TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _performSearch() {
    final source = _sourceController.text;
    final destination = _destinationController.text;
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
          time: _selectedTime != null ? _selectedTime!.format(context) : 'Not Selected',
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
          image: AssetImage('assets/images/whitebus.jpeg'),
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
              'BOOK BUS TICKET',
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
          _buildTextField(_sourceController, Icons.directions_bus, 'Enter Source Name'),
          const Divider(thickness: 1),
          _buildTextField(_destinationController, Icons.location_on, 'Enter Destination Name'),
          const Divider(thickness: 1),
          _buildDateAndTimeSelector(dateFormat),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        hintText: hintText,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildDateAndTimeSelector(DateFormat dateFormat) {
    return Row(
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
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            _selectTime(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            textStyle: const TextStyle(fontSize: 12),
            elevation: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                _selectedTime == null
                    ? 'Select Time'
                    : _selectedTime!.format(context),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _performSearch,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: const Text('Search', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildBusOperatorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bus Operators',
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

class PopularBusRoutesSection extends StatelessWidget {
  const PopularBusRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Bus Routes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Divider(),
        PopularBusRouteWidget(
          route: 'Delhi Buses',
          destinations: 'To: Manali, Chandigarh, Jaipur, Dehradun',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Mumbai Buses',
          destinations: 'To: Goa, Pune, Bangalore, Shirdi',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Chennai Buses',
          destinations: 'To: Coimbatore, Pondicherry, Bangalore, Hyderabad',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Bangalore Buses',
          destinations: 'To: Mumbai, Hyderabad, Chennai, Goa',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Hyderabad Buses',
          destinations: 'To: Mumbai, Chennai, Bangalore, Goa',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Pune Buses',
          destinations: 'To: Mumbai, Shirdi, Bangalore, Goa',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Kolkata Buses',
          destinations: 'To: Digha, Siliguri, Durgapur, Asansol',
        ),
        Divider(),
        PopularBusRouteWidget(
          route: 'Chandigarh Buses',
          destinations: 'To: Manali, Shimla, Amritsar, Delhi',
        ),
      ],
    );
  }
}
class BusOperatorWidget extends StatelessWidget {
  final String image;
  final String name;

  const BusOperatorWidget({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          ClipOval(
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
