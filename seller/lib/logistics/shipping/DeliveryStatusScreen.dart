import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryStatusScreen extends StatelessWidget {
  const DeliveryStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.amber.shade400,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Delivery Status',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.amber.shade400,
            child: Column(
              children: const [
                Text(
                  'Estimated Delivery Date',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'June 21    03:30 PM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Track Order',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Order id #BAN968',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: const [
                        StatusTile(
                          title: 'Request Accepted',
                          subtitle: '11:00 AM  June 16 2020',
                          isFirst: true,
                          isLast: false,
                          isCompleted: true,
                        ),
                        StatusTile(
                          title: 'Parcel Picked',
                          subtitle: '03:00 PM  June 16 2020',
                          isFirst: false,
                          isLast: false,
                          isCompleted: true,
                        ),
                        StatusTile(
                          title: 'Reached Bangalore Warehouse',
                          subtitle: '12:00 PM  June 18 2020',
                          isFirst: false,
                          isLast: false,
                          isCompleted: true,
                          hasImage: true,
                        ),
                        StatusTile(
                          title: 'Delivered at Address',
                          subtitle: '03:30 PM  June 21 2020',
                          isFirst: false,
                          isLast: true,
                          isCompleted: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade400,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'View Package Info',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// Timeline Tile Widget
class StatusTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final bool hasImage;

  const StatusTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isFirst,
    required this.isLast,
    required this.isCompleted,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: isCompleted ? Colors.orange : Colors.grey,
        indicatorXY: 0.2,
        padding: const EdgeInsets.all(6),
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted ? Colors.orange : Colors.grey.shade300,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isCompleted ? Colors.orange : Colors.grey.shade300,
        thickness: 2,
      ),
      endChild: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (hasImage)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://maps.googleapis.com/maps/api/staticmap?center=Bangalore&zoom=13&size=600x300',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
