import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller/models/product.dart';
import 'package:seller/spinners.dart';
import 'package:seller/views/product_manager/add_commission_screen.dart';
import 'package:seller/views/product_manager/edit_product/step_one_screen.dart';
import 'package:seller/views/product_manager/product_detail_screen.dart';
import 'package:share_plus/share_plus.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function onDelete, onEdit;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  });

  static String getStatus(dynamic id) {
    String ans = "";
    int x = int.parse(id.toString());
    switch(x) {
      case 1:
        ans = "Approved";
        break;
      case 0:
        ans = "Pending";
        break;
      case 2:
        ans = "Removed";
        break;
    }
    return ans;
  }
  static Color getStatusColor(dynamic id) {
    int x = int.parse(id.toString());
    Color ans = Colors.grey;
    switch(x) {
      case 1:
        ans = Colors.green;
        break;
      case 0:
        ans = Colors.blue;
        break;
      case 2:
        ans = Colors.red;
        break;
    }

    return ans;
  }
  static IconData getStatusIcon(dynamic id) {
    int x = int.parse(id.toString());
    IconData ans = CupertinoIcons.clock;
    switch(x) {
      case 1:
        ans = Icons.check_circle_outline;
        break;
      case 0:
        ans = CupertinoIcons.clock;
        break;
      case 2:
        ans = CupertinoIcons.xmark_circle;
        break;
    }

    return ans;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image and Three Dots Menu Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product['main_image'],
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: Image(image: AssetImage("assets/placeholder/loadingImage.gif")),
                    ), // Loading indicator
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)), // Error icon
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     print(product['id']);
                //     print(product['price']);
                //   },
                //   child: Text("Test"),
                // ),
                // Three Dots Menu
                PopupMenuButton<String>(
                  onSelected: (value) async {

                    if (value == 'view_item_details') {
                      final x = Product.fromJson(product);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(x)));
                    } else if (value == 'share_product') {
                      await Share.shareWithResult(
                          product['variants']
                          [0]['share_link']);
                    } else if (value == 'delete_product') {
                      onDelete();
                    } else if (value == "edit_product") {
                      onEdit();
                    } else if (value == "add_commission") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeCommissionsScreen(product: product,)));
                    }
                    // Add other actions for the options here...
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'view_item_details',
                      child: Text('View Item Details'),
                    ),
                    const PopupMenuItem(
                      value: 'view_stats',
                      child: Text('View Stats'),
                    ),
                    const PopupMenuItem(
                      value: 'view_variants',
                      child: Text('View Variants'),
                    ),
                    const PopupMenuItem(
                      value: 'edit_product',
                      child: Text('Edit Product'),
                    ),
                    const PopupMenuItem(
                      value: 'proliferate',
                      child: Text('Proliferate'),
                    ),
                    const PopupMenuItem(
                      value: 'add_commission',
                      child: Text('Change Commissions'),
                    ),
                    const PopupMenuItem(
                      value: 'delete_product',
                      child: Text('Delete Product'),
                    ),
                    const PopupMenuItem(
                      value: 'share_product',
                      child: Text('Share'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Product Name
            Text(
              product['product_title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Product Category and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    if (product['cat_id'] != null)
                      Chip(
                        label: Text(
                          product['cat_id'],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.deepPurple),
                        ),
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        side: BorderSide.none,
                      ),
                    if (product['sub_cat_id'] != null  &&  product['sub_cat_id'].toString().isNotEmpty)
                      Chip(
                        label: Text(
                          product['sub_cat_id'],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.deepPurple),
                        ),
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        side: BorderSide.none,
                      ),
                    if (product['child_cat_id'] != null  &&  product['child_cat_id'].toString().isNotEmpty)
                      Chip(
                        label: Text(
                          product['child_cat_id'],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.deepPurple),
                        ),
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                Text(
                  "\u20B9 ${product['price']}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Status
            Row(
              children: [
                Icon(
                  getStatusIcon(product['status']),
                  color: getStatusColor(product['status']),
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  getStatus(product['status']),
                  style: TextStyle(
                    fontSize: 12,
                    color: getStatusColor(product['status']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Posted By
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Posted by: ${product['posted_by']}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                // Promote Button with only icon
                Align(
                  alignment: Alignment.bottomRight,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle promote action here
                      if (value == 'apply_coupon') {
                        // Handle Apply Coupon
                      }
                      // Add other promote actions here...
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'apply_coupon',
                        child: Text('Apply Coupon'),
                      ),
                      const PopupMenuItem(
                        value: 'update_document',
                        child: Text('Update Document'),
                      ),
                      const PopupMenuItem(
                        value: 'update_donations',
                        child: Text('Update Donations'),
                      ),
                      const PopupMenuItem(
                        value: 'update_margin_rate',
                        child: Text('Update Margin Rate'),
                      ),
                    ],
                    icon: const Icon(Icons.campaign, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
