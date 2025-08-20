import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CommonComponents/CommonUtils/app_sizes.dart';
import '../../../controllers/address_controller.dart';
import 'add_address_view.dart';

class AddressListView extends GetView<AddressController> {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Addresses'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => AddAddressView()),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: AppSizes.font(80),
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSizes.height(16)),
                Text(
                  'No addresses added',
                  style: TextStyle(
                    fontSize: AppSizes.fontL,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: AppSizes.height(16)),
                ElevatedButton(
                  onPressed: () => Get.to(() => AddAddressView()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Add Address'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSizes.width(16)),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return Container(
              margin: EdgeInsets.only(bottom: AppSizes.height(12)),
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                border: Border.all(
                  color: address.isDefault ? Colors.green : Colors.grey[300]!,
                  width: address.isDefault ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.width(8),
                          vertical: AppSizes.height(4),
                        ),
                        decoration: BoxDecoration(
                          color: address.isDefault ? Colors.green : Colors.grey[200],
                          borderRadius: BorderRadius.circular(AppSizes.radius(4)),
                        ),
                        child: Text(
                          address.title,
                          style: TextStyle(
                            fontSize: AppSizes.fontS,
                            fontWeight: FontWeight.bold,
                            color: address.isDefault ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ),
                      if (address.isDefault) ...[
                        SizedBox(width: AppSizes.width(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.width(6),
                            vertical: AppSizes.height(2),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(AppSizes.radius(4)),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: TextStyle(
                              fontSize: AppSizes.fontXS,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      Spacer(),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          if (!address.isDefault)
                            PopupMenuItem(
                              value: 'default',
                              child: Text('Set as Default'),
                            ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'default':
                              controller.setDefaultAddress(index);
                              break;
                            case 'edit':
                              Get.to(() => AddAddressView(address: address, index: index));
                              break;
                            case 'delete':
                              _showDeleteDialog(context, index);
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.height(8)),
                  Text(
                    address.fullName,
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Text(
                    '${address.addressLine1}${address.addressLine2.isNotEmpty ? ', ${address.addressLine2}' : ''}',
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${address.city}, ${address.state} - ${address.pincode}',
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Text(
                    address.phone,
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddAddressView()),
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAddress(index);
              Get.back();
              Get.snackbar(
                'Success',
                'Address deleted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}