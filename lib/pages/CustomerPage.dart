import 'package:final_group_project/dao/customerDatabase.dart';
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dao/customerDAO.dart';
import '../model/customer.dart';

class CustomerPage extends StatefulWidget {
  final CustomerDatabase database;
  const CustomerPage({super.key, required this.database});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer> list1 = [];
  Customer? selectedCustomer = null;

  late TextEditingController _controller_firstName;
  late TextEditingController _controller_lastName;
  late TextEditingController _controller_address;
  late TextEditingController _controller_bday;
  late TextEditingController _controller_licenseNum;
  late CustomerDAO customerDAO;

  @override
  void initState() {
    super.initState();

    _controller_firstName = TextEditingController();
    _controller_lastName = TextEditingController();
    _controller_address = TextEditingController();
    _controller_bday = TextEditingController();
    _controller_licenseNum = TextEditingController();

    customerDAO = widget.database.myDAO;
    customerDAO.getAllCustomers().then((listOfCustomers) {
      setState(() {
        list1.addAll(listOfCustomers);
      });
    });
  }

  void _addCustomer() async{
    // create a non-ID object (id = null)
    Customer newCustomer = Customer(
        firstName: _controller_firstName.text,
        lastName: _controller_lastName.text,
        address: _controller_address.text,
        bday: _controller_bday.text,
        licenseNum: _controller_licenseNum.text);

    // insert database, floor auto-generate ID
    int newID = await customerDAO.insertCustomer(newCustomer);

    // create a customer data with ID
    Customer newIDCustomer = Customer(
        id: newID,
        firstName: newCustomer.firstName,
        lastName: newCustomer.lastName,
        address: newCustomer.address,
        bday: newCustomer.bday,
        licenseNum: newCustomer.licenseNum);

    // update UI
    setState(() {
      list1.add(newIDCustomer);
    });

    // snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Customer added successfully.")),
    );

    await _saveLastInput();

    // clear TextFields
    _controller_firstName.clear();
    _controller_lastName.clear();
    _controller_address.clear();
    _controller_bday.clear();
    _controller_licenseNum.clear();
  }

  Future<void> _saveLastInput() async{
    final storage = FlutterSecureStorage();
    await storage.write(key: "firstName", value: _controller_firstName.text);
    await storage.write(key: "lastName", value: _controller_lastName.text);
    await storage.write(key: "address", value: _controller_address.text);
    await storage.write(key: "bday", value: _controller_bday.text);
    await storage.write(key: "licenseNum", value: _controller_licenseNum.text);
  }

  void _copyLastInput() async{
    final storage = FlutterSecureStorage();
    _controller_firstName.text = await storage.read(key: "firstName") ?? "";
    _controller_lastName.text = await storage.read(key: "lastName") ?? "";
    _controller_address.text = await storage.read(key: "address") ?? "";
    _controller_bday.text = await storage.read(key: "bday") ?? "";
    _controller_licenseNum.text = await storage.read(key: "licenseNum") ?? "";

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Last input restored.")),
    );
  }

  @override
  void dispose() {
    //free memory:
    _controller_firstName.dispose();
    _controller_lastName.dispose();
    _controller_address.dispose();
    _controller_bday.dispose();
    _controller_licenseNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: reactiveLayout(),
    );
  }

  Widget reactiveLayout(){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if((width>height) && (width > 720)){
      return Row(children: [
        Expanded(child: ListPage(), flex: 1),
        Expanded(child: DetailsPage(), flex: 2)
      ]);
    }
    else{
      if(selectedCustomer == null)
        return ListPage();
      else
        return DetailsPage();
    }
  }

  Widget buildForm() {
    bool isWide = MediaQuery.of(context).size.width > 720;

    if (!isWide) {
      // portrait view
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller_firstName,
              decoration: const InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _controller_lastName,
              decoration: const InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _controller_address,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _controller_bday,
              decoration: const InputDecoration(
                labelText: "Birthday",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _controller_licenseNum,
              decoration: const InputDecoration(
                labelText: "License Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text("Add"),
                  onPressed: _addCustomer,
                ),
                ElevatedButton(
                  child: const Text("Copy Last Input"),
                  onPressed: _copyLastInput,
                ),
              ],
            ),
          ],
        ),
      );
    }

    else {
      // landscape view
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(child: TextField(
              controller: _controller_firstName,
              decoration: const InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(),
              ),
            )),
            const SizedBox(width: 10),

            Expanded(child: TextField(
              controller: _controller_lastName,
              decoration: const InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(),
              ),
            )),
            const SizedBox(width: 10),

            Expanded(child: TextField(
              controller: _controller_address,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            )),
            const SizedBox(width: 10),

            Expanded(child: TextField(
              controller: _controller_bday,
              decoration: const InputDecoration(
                labelText: "Birthday",
                border: OutlineInputBorder(),
              ),
            )),
            const SizedBox(width: 10),

            Expanded(child: TextField(
              controller: _controller_licenseNum,
              decoration: const InputDecoration(
                labelText: "License Number",
                border: OutlineInputBorder(),
              ),
            )),
            const SizedBox(width: 10),

            ElevatedButton(
              child: const Text("Add"),
              onPressed: _addCustomer,
            ),
            const SizedBox(width: 10),

            ElevatedButton(
              child: const Text("Copy Last Input"),
              onPressed: _copyLastInput,
            ),
          ],
        ),
      );
    }
  }

  Widget ListPage() {
    return Column(
      children: [
        buildForm(),
        Expanded(
          child: (list1.isEmpty)
              ? const Center(child: Text("There is no customer in list"))
              : buildListView(),
        ),
      ],
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: list1.length,
      itemBuilder: (context, index) {
        final c = list1[index];
        return ListTile(
          title: Text("${c.firstName} ${c.lastName}"),
          subtitle: Text("Address: ${c.address}"),
          onTap: () {
            setState(() {
              selectedCustomer = c;
            });
          },
        );
      },
    );
  }

  Widget DetailsPage(){
    if(selectedCustomer != null){
      return Center(child: Column(children: [
        Text("ID: ${selectedCustomer!.id}", style: TextStyle(fontSize: 40.0)),
        Text("First Name: ${selectedCustomer!.firstName}", style: TextStyle(fontSize: 40.0)),
        Text("Last Name: ${selectedCustomer!.lastName}", style: TextStyle(fontSize: 40.0)),
        Text("Address: ${selectedCustomer!.address}", style: TextStyle(fontSize: 40.0)),
        Text("Birthday: ${selectedCustomer!.bday}", style: TextStyle(fontSize: 40.0)),
        Text("License Number: ${selectedCustomer!.licenseNum}", style: TextStyle(fontSize: 40.0)),
        Spacer(),
        OutlinedButton(onPressed: () async{
          await customerDAO.deleteCustomer(selectedCustomer!);
          setState(() {
            list1.remove(selectedCustomer);
            selectedCustomer = null;
          });
        }, child: Text("Delete")),
        OutlinedButton(onPressed: (){
          setState(() {
            selectedCustomer = null;
          });
        }, child: Text("Close"))
      ], mainAxisAlignment: MainAxisAlignment.center,)
      );
    }
    else{
      return Text("Please select a customer from the list", style: TextStyle(fontSize: 30.0));
    }
  }
}
