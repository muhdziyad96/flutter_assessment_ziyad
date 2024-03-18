import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/model/address_model.dart';
import 'package:flutter_assessment_ziyad/screen/shared/button_shared.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address> addresses = [];

  Future<void> loadAddresses() async {
    List<String>? encodedAddresses = Preference.getStringList('address');
    if (encodedAddresses != null) {
      List<Address> loadedAddresses = [];
      for (String encodedAddress in encodedAddresses) {
        Map<String, dynamic> decodedAddress = json.decode(encodedAddress);
        loadedAddresses.add(Address.fromJson(decodedAddress));
      }
      setState(() {
        addresses = loadedAddresses;
      });
    }
  }

  Future<void> deleteAddress(Address addressToDelete) async {
    List<String>? encodedAddresses = Preference.getStringList('address');
    if (encodedAddresses != null) {
      List<Address> updatedAddresses = encodedAddresses
          .map(
              (encodedAddress) => Address.fromJson(json.decode(encodedAddress)))
          .toList();

      updatedAddresses
          .removeWhere((address) => address.id == addressToDelete.id);
      List<String> updatedEncodedAddresses = updatedAddresses
          .map((address) => json.encode(address.toJson()))
          .toList();

      await Preference.setStringList('address', updatedEncodedAddresses); 
      setState(() {
        addresses = updatedAddresses;
      });
    }
  }

  Future<void> saveAddresses() async {
    List<String> encodedAddresses =
        addresses.map((address) => json.encode(address.toJson())).toList();
    await Preference.setStringList('address', encodedAddresses);
  }

  void updateDefaultAddress(Address changedAddress) {
    setState(() {
      for (var address in addresses) {
        address.isDefault = (address == changedAddress);
      }
      saveAddresses();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Preference.remove(Preference.address);
            },
            child: const Text('My Addresses')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addresses.isEmpty
                ? const Center(
                    child: Text('No addresses found'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      Address address = addresses[index];
                      return ListTile(
                        title: Text(address.name),
                        subtitle: Text(
                            '${address.address} ${address.city}, ${address.state}, ${address.postcode}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await deleteAddress(address);
                          },
                        ),
                        leading: Checkbox(
                          value: address.isDefault,
                          onChanged: (bool? value) {
                            if (value == true) {
                              updateDefaultAddress(address);
                            }
                          },
                        ),
                      );
                    },
                  ),
            SharedButton(
              title: "+ Add Address",
              isFilled: true,
              onTap: () {
                Get.toNamed('/addAddress')!.then((value) => loadAddresses());
              },
            )
          ],
        ),
      ),
    );
  }
}
