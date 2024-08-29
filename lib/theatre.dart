import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class Theatre extends StatelessWidget {
  const Theatre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "   Theatre shows in Mumbai",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildCategoryRow(context),
            const SizedBox(height: 20),
            _buildImageRowWithButtons(context),
            const SizedBox(height: 20),
            _buildImageRowWithPrices(context),
             const SizedBox(height: 20),
            _buildImageRowWithButtons(context),
            const SizedBox(height: 20),
            _buildImageRowWithPrices(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context) {
    return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategory('Drama'),
          _buildCategory('Comedy'),
          _buildCategory('Musical'),
          _buildCategory('Adaption'),
          _buildCategory('Historical'),
          _buildCategory('Mythological'),
          _buildCategory('Romantic'),
          _buildCategory('Suspense'),
          _buildCategory('Adventure'),
          _buildCategory('Contemporary'),
          _buildCategory('Regional'),
          _buildCategory('Adult'),
          _buildCategory('Biography'),
          _buildCategory('Classic'),
          _buildCategory('Fantasy'),
        ],
      ),
    );
  }

  Widget _buildCategory(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Rounded corners
        border: Border.all(color: const Color.fromARGB(255, 10, 49, 81), width: 1), // Grey border
      ),
      child: Text(
        categoryName,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 9, 41, 68), // Text color
        ),
      ),
    );
  }

Widget _buildImageRowWithButtons(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Make the row scrollable horizontally
    child: Row(
      children: [
        _buildImageWithButton(
            context, 'assets/images/theatre1.png'),
        const SizedBox(width: 16), // Spacing between images
        _buildImageWithButton(
            context, 'assets/images/theatre2.png'),
        const SizedBox(width: 16), // Spacing between images
        _buildImageWithButton(
            context, 'assets/images/theatre3.png'),
        const SizedBox(width: 16), // Spacing between images
        _buildImageWithButton(
            context, 'assets/images/theatre4.png'),
      ],
    ),
  );
}


  Widget _buildImageWithButton(
      BuildContext context, String imagePath) {
    return Column(
      children: [
        
        Image.asset(
          imagePath,
          width: 160, // Set the width of the image
          height: 250, // Set the height of the image
          fit: BoxFit.fitHeight,
        ),
      
      ],
    );
  }

 Widget _buildImageRowWithPrices(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Make the row scrollable horizontally
    child: Row(
      children: [
        _buildImageWithPrice(context, 'assets/images/theatre1.png'),
        const SizedBox(width: 16), // Spacing between images
        _buildImageWithPrice(
            context, 'assets/images/theatre2.png'),
        const SizedBox(width: 16), // Spacing between images
        _buildImageWithPrice(context, 'assets/images/theatre3.png'),
        const SizedBox(width: 16), // Spacing between images
        _buildImageWithPrice(context, 'assets/images/theatre4.png'),
      ],
    ),
  );
}

  Widget _buildImageWithPrice(
      BuildContext context, String imagePath) {
    return Column(
      children: [
        Image.asset(
          imagePath,
            width: 160, // Set the width of the image
          height: 250, // Set the height of the image
          fit: BoxFit.fitHeight,
        ),
       
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      "Filters",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
 SizedBox(width: 280),
                      Text(
                      "Clear All",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.red
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildFilterSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        _buildFilterRow(context, [
          'Today',
          'Tomorrow',
          'This Weekend',
          'Date Range',
        ]),
        const SizedBox(height: 20),
          const Text(
          "Language",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        _buildFilterRow(context, [
          'Hindi',
          'English',
          'Telugu',
          'Kannada',
          'Marathi',
          'Malayalam'
        ]),
        const SizedBox(height: 20),
        const Text(
          "Genres",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        _buildFilterRow(context, [
          'Drama',
          'Comedy',
          'Open Musical',
          'Adaption',
          'Mythological',
          'Historical',
          'Romantic',
          'Suspense',
          'Contemporary',
          'Adventure',
          'Regional',
          'Adult',

        ]),
     
        const SizedBox(height: 20),
        const Text(
          "Price",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        _buildFilterRow(context, [
          'Free',
          '0 - 500',
          '501 - 2000',
          'Above 2000',
        ]),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context, List<String> filterOptions) {
    return Wrap(
      spacing: 8,
      runSpacing: 5,
      children: filterOptions.map((option) {
        return GestureDetector(
          onTap: option == 'Date Range'
              ? () => _selectDateRange(context)
              : () {
                  // Handle other filter option selections
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              option,
              style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Do something with the picked date range
      if (kDebugMode) {
        print("Date range selected: ${picked.start} - ${picked.end}");
      }
    }
  }
}
