import 'package:final_group_project/dao/customerDatabase.dart';
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import '../dao/customerDAO.dart';
import '../model/customer.dart';

class CustomerListPage extends StatefulWidget {
  final CustomerDatabase database;
  const CustomerListPage({super.key, required this.database});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
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

    $FloorCustomerDatabase.databaseBuilder('CustomerFile.db').build().then((database){
      customerDAO = database.myDAO;
      customerDAO.getAllCustomers().then((listOfCustomers){
        setState(() {
          list1.addAll(listOfCustomers);
        });
      });
    });
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

  Widget ListPage(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row( mainAxisAlignment: MainAxisAlignment.center, children:[
            Flexible(flex:2, child:
            TextField(controller: _controller_firstName,
              decoration: InputDecoration(
                hintText: "Type first name",
                border: OutlineInputBorder(),
              ),
            )),
            Flexible(flex:2, child:
            TextField(controller: _controller_lastName,
              decoration: InputDecoration(
                hintText: "Type last name",
                border: OutlineInputBorder(),
              ),
            )),
            Flexible(flex:2, child:
            TextField(controller: _controller_address,
              decoration: InputDecoration(
                hintText: "Type address",
                border: OutlineInputBorder(),
              ),
            )),
            Flexible(flex:2, child:
            TextField(controller: _controller_bday,
              decoration: InputDecoration(
                hintText: "Type birthday",
                border: OutlineInputBorder(),
              ),
            )),
            Flexible(flex:2, child:
            TextField(controller: _controller_licenseNum,
              decoration: InputDecoration(
                hintText: "Type license number",
                border: OutlineInputBorder(),
              ),
            )),
            Flexible(
                flex:2,
                child: ElevatedButton( child:Text("Add"), onPressed:() {
                  setState(() {
                    int? licenceNum = int.tryParse(_controller_licenseNum.value.text);

                    Customer newCustomer = Customer(
                        firstName: _controller_firstName.value.text,
                        lastName: _controller_lastName.value.text,
                        address: _controller_address.value.text,
                        bday: _controller_bday.value.text,
                        licenseNum: licenceNum!.toInt());
                    customerDAO.insertCustomer(newCustomer);

                    list1.add(newCustomer);
                    _controller_firstName.text = "";
                    _controller_lastName.text = "";
                    _controller_address.text = "";
                    _controller_bday.text = "";
                    _controller_licenseNum.text = "";
                  });
                } )

            ),
          ]),

          Expanded(child:
          (list1.length == 0)?
          Text("There is no customer in list")
              :
          ListView.builder(
              itemCount: list1.length,
              itemBuilder:(context, rowNum) =>
                  GestureDetector(child:Center(child: Text("ID ${list1[rowNum].id} "
                      "Name: ${list1[rowNum].firstName} ${list1[rowNum].lastName} "
                      "Address: ${list1[rowNum].address} Birthday: ${list1[rowNum].bday} "
                      "License Number: ${list1[rowNum].licenseNum}")),

                    onTap: (){
                      setState(() {selectedCustomer = list1[rowNum];});
                    },
                  )
          )
          )
        ]);
  }
}
