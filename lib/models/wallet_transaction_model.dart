class WalletTransactionModel {
  final int transactionId;
  final int walletId;
  final int? orderId;
  final String type;
  final double amount;
  final String description;
  final String referenceId;
  final String status;
  final DateTime createdAt;

  WalletTransactionModel({
    required this.transactionId,
    required this.walletId,
    this.orderId,
    required this.type,
    required this.amount,
    required this.description,
    required this.referenceId,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      transactionId: json['transaction_id'] ?? 0,
      walletId: json['wallet_id'] ?? 0,
      orderId: json['order_id'],
      type: json['type'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      referenceId: json['reference_id'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}