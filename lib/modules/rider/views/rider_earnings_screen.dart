import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../themes/app_colors.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../controllers/rider_controller.dart';

class RiderEarningsScreen extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();
  final TextEditingController withdrawalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Earnings'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Earnings'),
              Tab(text: 'Withdrawals'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEarningsTab(),
            _buildWithdrawalsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsTab() {
    return Obx(() => SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Earnings Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildEarningsCard(
                  'Today',
                  '\$${controller.todayEarnings.toStringAsFixed(2)}',
                  Icons.today,
                  Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildEarningsCard(
                  'This Week',
                  '\$${controller.weeklyEarnings.toStringAsFixed(2)}',
                  Icons.date_range,
                  Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEarningsCard(
                  'This Month',
                  '\$${controller.monthlyEarnings.toStringAsFixed(2)}',
                  Icons.calendar_month,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildEarningsCard(
                  'Total',
                  '\$${controller.totalEarnings.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  Colors.purple,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Withdrawal Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Withdrawal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  CommonTextField(
                    controller: withdrawalController,
                    labelText: 'Amount',
                    hintText: 'Enter amount to withdraw',
                    keyboardType: TextInputType.number,
                    prefixIcon:Icon(Icons.attach_money) ,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      text: 'Request Withdrawal',
                      onPressed: () {
                        final amount = double.tryParse(withdrawalController.text);
                        if (amount != null && amount > 0) {
                          controller.requestWithdrawal(amount);
                          withdrawalController.clear();
                        } else {
                          Get.snackbar('Error', 'Please enter a valid amount');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Earnings History
          Text(
            'Earnings History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          controller.earnings.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No earnings yet', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.earnings.length,
                  itemBuilder: (context, index) {
                    final earning = controller.earnings[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getEarningTypeColor(earning.type),
                          child: Icon(
                            _getEarningTypeIcon(earning.type),
                            color: Colors.white,
                          ),
                        ),
                        title: Text('Order #${earning.orderId}'),
                        subtitle: Text(
                          '${earning.date.day}/${earning.date.month}/${earning.date.year} • ${earning.type.toUpperCase()}',
                        ),
                        trailing: Text(
                          '\$${earning.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    ));
  }

  Widget _buildWithdrawalsTab() {
    return Obx(() => controller.withdrawals.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No withdrawal requests', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.withdrawals.length,
            itemBuilder: (context, index) {
              final withdrawal = controller.withdrawals[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${withdrawal.amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          _buildWithdrawalStatusChip(withdrawal.status),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text(
                            'Requested: ${withdrawal.requestDate.day}/${withdrawal.requestDate.month}/${withdrawal.requestDate.year}',
                          ),
                        ],
                      ),
                      if (withdrawal.processedDate != null) ...[
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Processed: ${withdrawal.processedDate!.day}/${withdrawal.processedDate!.month}/${withdrawal.processedDate!.year}',
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.account_balance, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text('Bank Account: ${withdrawal.bankAccount}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ));
  }

  Widget _buildEarningsCard(String title, String amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalStatusChip(String status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'approved':
        color = Colors.blue;
        icon = Icons.check;
        break;
      case 'paid':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getEarningTypeColor(String type) {
    switch (type) {
      case 'delivery':
        return Colors.green;
      case 'bonus':
        return Colors.blue;
      case 'penalty':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEarningTypeIcon(String type) {
    switch (type) {
      case 'delivery':
        return Icons.delivery_dining;
      case 'bonus':
        return Icons.star;
      case 'penalty':
        return Icons.remove_circle;
      default:
        return Icons.monetization_on;
    }
  }
}