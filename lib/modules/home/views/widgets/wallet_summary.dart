import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../wallet/controllers/wallet_controller.dart';

class WalletSummary extends StatelessWidget {
  const WalletSummary({super.key});

  @override
  Widget build(BuildContext context) {
    WalletController? walletController;
    
    try {
      walletController = Get.find<WalletController>();
    } catch (e) {
      walletController = Get.put(WalletController());
    }
    
    // Load wallet data when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      walletController?.loadWallet();
    });

    return Container(
      padding: EdgeInsets.all(AppSizes.width(16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
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
              Text(
                'Wallet Balance',
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: AppSizes.fontXL,
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.height(8)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                '₹${walletController?.balance}',
                style: TextStyle(
                  fontSize: AppSizes.fontXXXL,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add money functionality
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(12),
                        vertical: AppSizes.height(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                      ),
                      child: Text(
                        'Add Money',
                        style: TextStyle(
                          fontSize: AppSizes.fontS,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.height(16)),
          
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    walletController?.loadTransactions();
                    _showTransactionsBottomSheet();
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.width(12)),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                          size: AppSizes.fontXL,
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: AppSizes.fontS,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: AppSizes.width(12)),
              
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.width(12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: AppSizes.fontXL,
                      ),
                      SizedBox(height: AppSizes.height(4)),
                      Text(
                        '${walletController?.availableCoupons ?? 0} Coupons',
                        style: TextStyle(
                          fontSize: AppSizes.fontS,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTransactionsBottomSheet() {
    WalletController? walletController;
    try {
      walletController = Get.find<WalletController>();
    } catch (e) {
      return;
    }
    
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radius(20))),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (walletController?.transactions.isEmpty ?? true) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No transactions yet'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(AppSizes.width(16)),
                  itemCount: walletController?.transactions.length ?? 0,
                  itemBuilder: (context, index) {
                    final transaction = walletController!.transactions[index];
                    final isCredit = transaction.type == 'credit';
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.height(12)),
                      padding: EdgeInsets.all(AppSizes.width(16)),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSizes.width(8)),
                            decoration: BoxDecoration(
                              color: isCredit ? Colors.green[100] : Colors.red[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCredit ? Icons.add : Icons.remove,
                              color: isCredit ? Colors.green : Colors.red,
                              size: AppSizes.fontL,
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
                                    fontSize: AppSizes.fontM,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  transaction.createdAt.toString().split(' ')[0],
                                  style: TextStyle(
                                    fontSize: AppSizes.fontS,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isCredit ? '+' : '-'}₹${transaction.amount}',
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
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}