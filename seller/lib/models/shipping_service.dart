import 'package:seller/models/shipping_estimate.dart';

class ShippingService {
  Future<ShippingEstimate> calculateShipping({
    required String weight,
    required String size,
    bool damageCover = false,
  }) async {
    // Implement actual API call here
    await Future.delayed(const Duration(seconds: 1)); // Mock delay

    return ShippingEstimate(
      packageWeight: weight,
      packageSize: size,
      includeDamageCover: damageCover,
      estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
      cost: damageCover ? 2000 + _calculateBaseCost(weight) : _calculateBaseCost(weight),
    );
  }

  double _calculateBaseCost(String weight) {
    // Simple mock calculation
    final kg = double.parse(weight.replaceAll('kg', ''));
    return kg * 100;
  }
}