import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../controller/home_controller.dart';
import '../../../../../controllers/wallet_controller.dart';

class WalletSummary extends StatelessWidget {
  const WalletSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final walletController = Get.find<WalletController>();
    final homeController = Get.find<HomeController>();

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wallet Balance",
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Obx(() => Text(
                    "₹${walletController.walletBalance.value.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: AppSizes.fontXXL,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Vouchers",
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Obx(() => Text(
                    "${homeController.voucherCount.value} Available",
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.height(16)),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showAddMoneyDialog(context, walletController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.height(8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                    ),
                  ),
                  child: Text(
                    'Add Money',
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.width(12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => WalletTransactionsView()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.height(8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context, WalletController walletController) {
    final amounts = [100.0, 200.0, 500.0, 1000.0];
    
    Get.dialog(
      AlertDialog(
        title: Text('Add Money to Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select amount to add:'),
            SizedBox(height: AppSizes.height(16)),
            Wrap(
              spacing: 8,
              children: amounts.map((amount) => 
                ElevatedButton(
                  onPressed: () {
                    walletController.addMoney(amount);
                    Get.back();
                    Get.snackbar(
                      'Success',
                      '₹${amount.toStringAsFixed(0)} added to wallet',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('₹${amount.toStringAsFixed(0)}'),
                ),
              ).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class WalletTransactionsView extends StatelessWidget {
  const WalletTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletController = Get.find<WalletController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet Transactions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (walletController.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: AppSizes.font(80),
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSizes.height(16)),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSizes.width(16)),
          itemCount: walletController.transactions.length,
          itemBuilder: (context, index) {
            final transaction = walletController.transactions[index];
            final isCredit = transaction.type == 'credit';
            
            return Container(
              margin: EdgeInsets.only(bottom: AppSizes.height(12)),
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.width(8)),
                    decoration: BoxDecoration(
                      color: isCredit ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                    ),
                    child: Icon(
                      isCredit ? Icons.add : Icons.remove,
                      color: isCredit ? Colors.green : Colors.red,
                      size: AppSizes.fontXL,
                    ),
                  ),
                  
                  SizedBox(width: AppSizes.width(12)),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: TextStyle(
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year} ${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: AppSizes.fontS,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (transaction.orderId != null)
                          Text(
                            'Order: ${transaction.orderId}',
                            style: TextStyle(
                              fontSize: AppSizes.fontS,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  Text(
                    '${isCredit ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                      color: isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
