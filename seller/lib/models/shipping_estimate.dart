class ShippingEstimate {
  final String packageWeight;
  final String packageSize;
  final bool includeDamageCover;
  final DateTime estimatedDelivery;
  final double cost;

  ShippingEstimate({
    required this.packageWeight,
    required this.packageSize,
    required this.includeDamageCover,
    required this.estimatedDelivery,
    required this.cost,
  });
}