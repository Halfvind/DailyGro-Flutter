import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';
import '../controllers/vendor_controller.dart';

class VendorEarningsScreen extends StatelessWidget {
  const VendorEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Wallet'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildWalletBalance(),
            const SizedBox(height: 20),
            _buildEarningsBreakdown(),
            const SizedBox(height: 20),
            _buildWithdrawSection(),
            const SizedBox(height: 20),
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalance() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Balance',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '\$2,450.75',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pending Settlement', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const Text('\$320.50', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: _withdrawEarnings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Withdraw'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Earnings Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildEarningRow('Total Sales', '\$3,240.75', Colors.green),
            _buildEarningRow('Platform Commission (8%)', '-\$259.26', Colors.red),
            _buildEarningRow('Delivery Charges', '+\$145.50', Colors.blue),
            _buildEarningRow('Tax Deduction', '-\$96.24', Colors.orange),
            const Divider(),
            _buildEarningRow('Net Earnings', '\$2,450.75', AppColors.primary, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningRow(String title, String amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Withdraw', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildWithdrawButton('\$500', '500')),
                const SizedBox(width: 8),
                Expanded(child: _buildWithdrawButton('\$1000', '1000')),
                const SizedBox(width: 8),
                Expanded(child: _buildWithdrawButton('All', '2450.75')),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Custom Amount',
                prefixText: '\$ ',
                border: const OutlineInputBorder(),
                suffixIcon: ElevatedButton(
                  onPressed: _customWithdraw,
                  child: const Text('Withdraw'),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawButton(String label, String amount) {
    return OutlinedButton(
      onPressed: () => _quickWithdraw(amount),
      child: Text(label),
    );
  }

  Widget _buildTransactionHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Get.toNamed('/vendor/transaction-history'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          //  ...controller.transactions.map((transaction) => _buildTransactionItem(transaction)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final amount = transaction['amount'] as double;
    final isPositive = amount > 0;
    final color = isPositive ? Colors.green : Colors.red;
    final amountText = '${isPositive ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (transaction['color'] as Color).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction['type'] == 'Withdrawal' ? Icons.arrow_upward : Icons.arrow_downward,
              color: transaction['color'] as Color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction['type'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(transaction['date'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction['amount'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transaction['color'] as Color,
                ),
              ),
              Text(
                transaction['status'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: transaction['status'] == 'Completed' ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _withdrawEarnings() {
    final controller = Get.find<VendorController>();
    Get.dialog(
      AlertDialog(
        title: const Text('Withdraw Earnings'),
        content: Text('Withdraw \$${controller.walletBalance.toStringAsFixed(2)} to your registered bank account?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.withdrawAmount(controller.walletBalance);
              Get.back();
              if (success) {
                Get.snackbar('Success', 'Withdrawal request submitted');
              } else {
                Get.snackbar('Error', 'Withdrawal failed');
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _quickWithdraw(String amount) async {
    final controller = Get.find<VendorController>();
    final withdrawAmount = double.parse(amount);
    final success = await controller.withdrawAmount(withdrawAmount);
    if (success) {
      Get.snackbar('Success', 'Withdrawal of \$$amount requested');
    } else {
      Get.snackbar('Error', 'Insufficient balance or withdrawal failed');
    }
  }

  void _customWithdraw() {
    final amountController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Custom Withdrawal'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                final controller = Get.find<VendorController>();
                final success = await controller.withdrawAmount(amount);
                Get.back();
                if (success) {
                  Get.snackbar('Success', 'Withdrawal of \$${amount.toStringAsFixed(2)} requested');
                } else {
                  Get.snackbar('Error', 'Insufficient balance or withdrawal failed');
                }
              } else {
                Get.snackbar('Error', 'Please enter a valid amount');
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}