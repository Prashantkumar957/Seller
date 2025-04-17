import 'package:flutter/material.dart';

class EstimateShippingScreen extends StatefulWidget {
  const EstimateShippingScreen({Key? key}) : super(key: key);

  @override
  State<EstimateShippingScreen> createState() => _EstimateShippingScreenState();
}

class _EstimateShippingScreenState extends State<EstimateShippingScreen> {
  int selectedSizeIndex = 1;
  bool isExpressDelivery = true;
  bool isDamageCover = false;

  final List<Map<String, String>> packageSizes = [
    {'label': 'Small', 'range': '< 1Kg'},
    {'label': 'Medium', 'range': '1 - 5 Kg'},
    {'label': 'Large', 'range': '5 - 15 Kg'},
    {'label': 'X Large', 'range': '> 15 Kg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Estimate Shipping'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        actions: const [Padding(padding: EdgeInsets.all(12), child: Icon(Icons.notifications))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(Icons.location_on_outlined, 'Pickup'),
            const SizedBox(height: 12),
            buildTextField(Icons.location_pin, 'Delivery'),
            const SizedBox(height: 24),
            const Text('Package Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(packageSizes.length, (index) {
                final selected = index == selectedSizeIndex;
                return GestureDetector(
                  onTap: () => setState(() => selectedSizeIndex = index),
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.orange.shade50 : Colors.white,
                      border: Border.all(
                          color: selected ? Colors.orange : Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/package${index + 1}.png', height: 40), // You must add these assets
                        const SizedBox(height: 8),
                        Text(packageSizes[index]['range']!, style: const TextStyle(fontSize: 12)),
                        Text(packageSizes[index]['label']!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            CheckboxListTile(
              value: isExpressDelivery,
              activeColor: Colors.orange,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) => setState(() => isExpressDelivery = val!),
              title: const Text("Express Delivery", style: TextStyle(fontWeight: FontWeight.w500)),
            ),

            CheckboxListTile(
              value: isDamageCover,
              activeColor: Colors.orange,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) => setState(() => isDamageCover = val!),
              title: const Text("Rs.2000 For Damage Cover", style: TextStyle(fontWeight: FontWeight.w500)),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Items In The Parcel", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Add Items", style: TextStyle(color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter item details...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Add estimation logic here
                },
                child: const Text("Get Estimation Now", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
