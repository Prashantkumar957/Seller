import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> orders = [
    {
      'dateHeader': 'Jun 16 2020',
      'id': '#BAN968',
      'details': [
        {'location': 'R.S.Puram, Coimbatore', 'date': 'Jun 16 2020', 'isDelivered': true},
        {'location': 'Basavanagudi, Bangaluru', 'date': 'Jun 16 2020'},
        {'location': 'Delivered', 'date': 'Jun 20 2020'},
      ],
      'amount': '2850',
      'weight': '3.5',
    },
    {
      'dateHeader': 'Mar 06 2020',
      'id': '#BAN115',
      'details': [
        {'location': 'Sarvanampatty, Coimbatore', 'date': 'Mar 06 2020'},
        {'location': 'IndiraNagar, Bangaluru', 'date': 'Mar 10 2020', 'isDelivered': true},
        {'location': 'Delivered', 'date': 'Mar 10 2020'},
      ],
      'amount': '2620',
      'weight': '3.2',
    },
    {
      'dateHeader': 'Jan 12 2020',
      'id': '#BAN872',
      'details': [
        {'location': 'Jayanagar, Bangaluru', 'date': 'Mar 06 2020'},
        {'location': '(In transit)', 'date': null, 'isInTransit': true},
      ],
    },
    {
      'dateHeader': 'Jan 12 2020', // Another order for the same date to test grouping
      'id': '#BAN873',
      'details': [
        {'location': 'Some Other Place', 'date': 'Jan 13 2020'},
      ],
    },
  ];

  // Group orders by dateHeader
  Map<String, List<Map<String, dynamic>>> _groupedOrders = {};

  @override
  void initState() {
    super.initState();
    _groupOrdersByDate();
  }

  void _groupOrdersByDate() {
    _groupedOrders = {};
    for (var order in orders) {
      final dateHeader = order['dateHeader'] as String;
      if (!_groupedOrders.containsKey(dateHeader)) {
        _groupedOrders[dateHeader] = [];
      }
      _groupedOrders[dateHeader]!.add(order);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_groupedOrders);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade400,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('History', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Order Id',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Handle filter/sort
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._groupedOrders.keys.map((date) {
              final orderListForDate = _groupedOrders[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          'Order Id ${orderListForDate.first['id'] ?? 'N/A'}', // Use the first order's ID as a representative
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  ...orderListForDate.map((order) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 8.0), // Add some spacing between individual orders
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // We've already displayed the date and order ID above the group
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (order['details'] as List<dynamic>?)?.map<Widget>((detail) {
                              if (detail is Map<String, dynamic>) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: detail['isDelivered'] == true
                                            ? Colors.green
                                            : detail['isInTransit'] == true
                                            ? Colors.amber
                                            : Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          detail['location'] ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      if (detail['date'] != null) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          detail['date']!,
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }).toList() ??
                                [],
                          ),
                          const SizedBox(height: 12),
                          if (order.containsKey('amount'))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                    children: [
                                      const TextSpan(text: 'Rs. '),
                                      TextSpan(
                                        text: order['amount'] ?? '0',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(text: '/-'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                    children: [
                                      const TextSpan(text: 'Net Wt: '),
                                      TextSpan(
                                        text: '${order['weight'] ?? '0'} Kg',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (order['details'] != null && order['details'].isNotEmpty && order['details'].last.containsKey('isDelivered') && order['details'].last['isDelivered'] == true) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Delivered',
                                  style: TextStyle(color: Colors.green, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                          if (order['details'] != null && order['details'].isNotEmpty && order['details'].last.containsKey('isInTransit') && order['details'].last['isInTransit'] == true) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'In transit',
                                  style: TextStyle(color: Colors.amber, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber.shade400,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.send_outlined), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes_outlined), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}