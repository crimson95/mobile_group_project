import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../dao/customerDatabase.dart';
import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';
import '../dao/customerDAO.dart';
import '../model/customer.dart';

/// Page that displays, inserts, updates and deletes customer records.
/// Supports both mobile and desktop responsive layouts.
class CustomerPage extends StatefulWidget {
  /// Reference to the shared Floor database.
  final CustomerDatabase database;
  const CustomerPage({super.key, required this.database});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

/// State class for [CustomerPage].
///
/// This class manages:
/// - Loading all customers from the database
/// - Handling user interactions for Add / Edit / Delete
/// - Managing text controllers for the input fields
/// - Supporting responsive layout (mobile ↔ desktop)
/// - Tracking the currently selected or edited customer
/// - Triggering UI updates using `setState()`
///
/// It acts as the main controller for all CRUD logic and user input behavior.
class _CustomerPageState extends State<CustomerPage> {
  /// List of all customers loaded from the database.
  List<Customer> list1 = [];
  /// The customer currently selected in the list (null when none selected).
  Customer? selectedCustomer;
  /// ID of the customer currently being edited (mobile mode support).
  int? editingCustomerId;
  /// True when editing an existing customer instead of inserting a new one.
  bool isEditing = false;

  /// Controllers for each input field.
  late TextEditingController _controller_firstName;
  late TextEditingController _controller_lastName;
  late TextEditingController _controller_address;
  late TextEditingController _controller_bday;
  late TextEditingController _controller_licenseNum;

  /// DAO instance for database operations.
  late CustomerDAO customerDAO;

  /// Initializes controllers and loads customers from the database.
  @override
  void initState() {
    super.initState();

    _controller_firstName = TextEditingController();
    _controller_lastName = TextEditingController();
    _controller_address = TextEditingController();
    _controller_bday = TextEditingController();
    _controller_licenseNum = TextEditingController();

    customerDAO = widget.database.myDAO;
    customerDAO.getAllCustomers().then((list){
      setState(() {
        list1 = list;
      });
    });
  }

  /// Releases controller resources.
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

  /// Clears all input text fields.
  void _clearInput(){
    // clear TextFields
    _controller_firstName.clear();
    _controller_lastName.clear();
    _controller_address.clear();
    _controller_bday.clear();
    _controller_licenseNum.clear();
  }

  /// Inserts a new customer into the database after validating input.
  void _addCustomer() async{
    late final loc = AppLocalizations.of(context)!;
    // check if variable is null
    if (_controller_firstName.text.trim().isEmpty ||
        _controller_lastName.text.trim().isEmpty ||
        _controller_address.text.trim().isEmpty ||
        _controller_bday.text.trim().isEmpty ||
        _controller_licenseNum.text.trim().isEmpty) {

      // show AlertDialog if variable is null
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(loc.translate('Missing Information')!),
          content: Text(loc.translate('Please fill in all fields before adding a customer.')!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.translate('OK')!),
            ),
          ],
        ),
      );

      return; // stop add
    }

    // create a non-ID object (id = null)
    Customer newCustomer = Customer(
        firstName: _controller_firstName.text,
        lastName: _controller_lastName.text,
        address: _controller_address.text,
        bday: _controller_bday.text,
        licenseNum: _controller_licenseNum.text
    );

    // insert database, floor auto-generate ID
    int newID = await customerDAO.insertCustomer(newCustomer);

    // create a customer data with ID
    Customer newIDCustomer = Customer(
        id: newID,
        firstName: newCustomer.firstName,
        lastName: newCustomer.lastName,
        address: newCustomer.address,
        bday: newCustomer.bday,
        licenseNum: newCustomer.licenseNum
    );

    // update UI
    setState(() {
      list1.add(newIDCustomer);
    });

    // snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.translate('Customer added successfully.')!)),
    );

    await _saveLastInput();

    _clearInput();
  }

  /// Updates an existing customer.
  /// Includes mobile-mode support, and checks whether the user made changes.
  void _updateCustomer() async {
    late final loc = AppLocalizations.of(context)!;

    final int? editingId = editingCustomerId;
    if (editingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate('No customer selected to update.')!)),
      );
      return;
    }

    final Customer original = list1.firstWhere(
          (c) => c.id == editingId,
      orElse: () => Customer(
        id: editingId,
        firstName: "",
        lastName: "",
        address: "",
        bday: "",
        licenseNum: "",
      ),
    );

    String newFirst = _controller_firstName.text.trim();
    String newLast = _controller_lastName.text.trim();
    String newAddress = _controller_address.text.trim();
    String newBday = _controller_bday.text.trim();
    String newLicense = _controller_licenseNum.text.trim();

    bool noChanges =
        newFirst == original.firstName &&
            newLast == original.lastName &&
            newAddress == original.address &&
            newBday == original.bday &&
            newLicense == original.licenseNum;

    if (noChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate("No changes detected.")!)),
      );
      return;
    }

    Customer updated = Customer(
      id: editingId,
      firstName: newFirst,
      lastName: newLast,
      address: newAddress,
      bday: newBday,
      licenseNum: newLicense,
    );

    await customerDAO.updateCustomer(updated);

    // refresh list
    List<Customer> refreshed = await customerDAO.getAllCustomers();

    setState(() {
      list1 = refreshed;

      selectedCustomer = refreshed.firstWhere(
            (c) => c.id == updated.id,
        orElse: () => updated,
      );

      isEditing = false;
      editingCustomerId = null;
    });

    _clearInput();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.translate('Customer updated.')!)),
    );
  }

  /// Saves the last input values using EncryptedSharedPreferences.
  Future<void> _saveLastInput() async{
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    await prefs.setString("firstName", _controller_firstName.text);
    await prefs.setString("lastName", _controller_lastName.text);
    await prefs.setString("address", _controller_address.text);
    await prefs.setString("bday", _controller_bday.text);
    await prefs.setString("licenseNum", _controller_licenseNum.text);
  }

  /// Restores the last saved input values from EncryptedSharedPreferences.
  void _copyLastInput() async{
    late final loc = AppLocalizations.of(context)!;
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    _controller_firstName.text = await prefs.getString("firstName") ?? "";
    _controller_lastName.text = await prefs.getString("lastName") ?? "";
    _controller_address.text = await prefs.getString("address") ?? "";
    _controller_bday.text = await prefs.getString("bday") ?? "";
    _controller_licenseNum.text = await prefs.getString("licenseNum") ?? "";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.translate('Last input restored.')!)),
    );
  }

  /// Displays a help dialog explaining how to use the page.
  void _showHelpDialog() {
    late final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('How to use this page')!),
        content: Text(
          "${loc.translate('help_use_fields')!}\n"
          "${loc.translate('help_press_add')!}\n"
          "${loc.translate('help_tap_customer')!}\n"
          "${loc.translate('help_press_edit')!}\n"
          "${loc.translate('help_press_delete')!}\n"
          "${loc.translate('help_copy_last_input')!}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.translate('OK')!),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    late final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          title: Text(loc.translate('Customer Page')!),
        actions: [
          IconButton(onPressed: _showHelpDialog, icon: const Icon(Icons.help_outline),
          tooltip: loc.translate('Help')!
          ),
        ],
      ),
      body: reactiveLayout(),
    );
  }

  /// Determines whether the page should show list+details or single-page layout.
  Widget reactiveLayout(){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if((width>height) && (width > 720)){
      return Row(children: [
        Expanded(child: ListPage(), flex: 2),
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

  /// Returns the appropriate form layout depending on screen width.
  Widget buildForm() {
    return LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 720;

          if (!isWide) {
            // portrait view
            return _buildVerticalForm();
          }

          else {
            // landscape view
            return _buildHorizontalForm();
          }
        },
    );
  }

  /// Vertical form used in mobile portrait mode.
  Widget _buildVerticalForm(){
    late final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller_firstName,
            decoration: InputDecoration(
              labelText: loc.translate('First Name')!,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _controller_lastName,
            decoration: InputDecoration(
              labelText: loc.translate('Last Name')!,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _controller_address,
            decoration: InputDecoration(
              labelText: loc.translate('Address')!,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _controller_bday,
            decoration: InputDecoration(
              labelText: loc.translate('Birthday')!,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _controller_licenseNum,
            decoration: InputDecoration(
              labelText: loc.translate('License Number')!,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isEditing ? _updateCustomer : _addCustomer,
                child: Text(isEditing ? loc.translate('Update')! : loc.translate('Add')!),
              ),
              ElevatedButton(
                child: Text(loc.translate('Copy Last Input')!),
                onPressed: _copyLastInput,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Horizontal form used in desktop / wide mode.
  Widget _buildHorizontalForm(){
    late final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _controller_firstName,
            decoration: InputDecoration(
              labelText: loc.translate('First Name')!,
              border: OutlineInputBorder(),
            ),
          )),
          const SizedBox(width: 10),

          Expanded(child: TextField(
            controller: _controller_lastName,
            decoration: InputDecoration(
              labelText: loc.translate('Last Name')!,
              border: OutlineInputBorder(),
            ),
          )),
          const SizedBox(width: 10),

          Expanded(child: TextField(
            controller: _controller_address,
            decoration: InputDecoration(
              labelText: loc.translate('Address')!,
              border: OutlineInputBorder(),
            ),
          )),
          const SizedBox(width: 10),

          Expanded(child: TextField(
            controller: _controller_bday,
            decoration: InputDecoration(
              labelText: loc.translate('Birthday')!,
              border: OutlineInputBorder(),
            ),
          )),
          const SizedBox(width: 10),

          Expanded(child: TextField(
            controller: _controller_licenseNum,
            decoration: InputDecoration(
              labelText: loc.translate('License Number')!,
              border: OutlineInputBorder(),
            ),
          )),
          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: isEditing ? _updateCustomer : _addCustomer,
            child: Text(isEditing ? loc.translate('Update')! : loc.translate('Add')!),
          ),
          const SizedBox(width: 10),

          ElevatedButton(
            child: Text(loc.translate('Copy Last Input')!),
            onPressed: _copyLastInput,
          ),
        ],
      ),
    );
  }

  /// Displays the customer list and form.
  Widget ListPage() {
    late final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        buildForm(),
        Expanded(
          child: (list1.isEmpty)
              ? Center(child: Text(loc.translate('There is no customer in list')!))
              : buildListView(),
        ),
      ],
    );
  }

  /// Builds the ListView of all customers.
  Widget buildListView() {
    late final loc = AppLocalizations.of(context)!;
    return ListView.builder(
      itemCount: list1.length,
      itemBuilder: (context, index) {
        final c = list1[index];
        return ListTile(
          title: Text("${c.firstName} ${c.lastName}"),
          subtitle: Text("${loc.translate('Address')!}: ${c.address}\n"
              "${loc.translate('Birthday')!}: ${c.bday}\n"
              "${loc.translate('License Number')!}: ${c.licenseNum}",),
          onTap: () {
            setState(() {
              selectedCustomer = c;
            });
          },
        );
      },
    );
  }

  /// Shows the detailed information of the selected customer.
  Widget DetailsPage() {
    late final loc = AppLocalizations.of(context)!;
    if (selectedCustomer == null) {
      return Center(
        child: Text(
          loc.translate('Please select a customer from the list')!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      );
    }


    // ========= VIEW MODE =========
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ID: ${selectedCustomer!.id}", style: TextStyle(fontSize: 28)),
          Text(
            "${loc.translate('First Name')!}: ${selectedCustomer!.firstName}",
            style: const TextStyle(fontSize: 28),
          ),
          Text(
            "${loc.translate('Last Name')!}: ${selectedCustomer!.lastName}",
            style: const TextStyle(fontSize: 28),
          ),
          Text(
            "${loc.translate('Address')!}: ${selectedCustomer!.address}",
            style: const TextStyle(fontSize: 28),
          ),
          Text(
            "${loc.translate('Birthday')!}: ${selectedCustomer!.bday}",
            style: const TextStyle(fontSize: 28),
          ),
          Text(
            "${loc.translate('License Number')!}: ${selectedCustomer!.licenseNum}",
            style: const TextStyle(fontSize: 28),
          ),
          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              setState(() {
                editingCustomerId = selectedCustomer!.id;
                _controller_firstName.text = selectedCustomer!.firstName;
                _controller_lastName.text = selectedCustomer!.lastName;
                _controller_address.text = selectedCustomer!.address;
                _controller_bday.text = selectedCustomer!.bday;
                _controller_licenseNum.text = selectedCustomer!.licenseNum;
                isEditing = true;

                // 手機模式需要切回 ListPage()
                selectedCustomer = null;
              });
            },
            child: Text(loc.translate('Edit')!),
          ),

          ElevatedButton(
            onPressed: () async {
              if (selectedCustomer == null) return;

              final bool? shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(loc.translate('Delete customer')!),
                      content: Text(
                          '${loc.translate('Are you sure you want to delete')} '
                              '[${selectedCustomer!
                              .firstName} ${selectedCustomer!.lastName}]?'
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(loc.translate('Cancel')!),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(loc.translate('Delete')!),
                        ),
                      ],
                    ),
              );

              // if user press Cancel or close dialog, execute delete
              if (shouldDelete == true) {
                await customerDAO.deleteCustomer(selectedCustomer!);
                setState(() {
                  list1.remove(selectedCustomer);
                  selectedCustomer = null;
                });


              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.translate('Customer deleted.')!)),
              );
              }
            },
            child: Text(loc.translate('Delete')!),
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCustomer = null;
              });
            },
            child: Text(loc.translate('Close')!),
          ),
        ],
      ),
    );
  }
}
