import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyek_uas/firebase_options.dart';

class CRUDEoperation extends StatefulWidget {
  const CRUDEoperation({Key? key}) : super(key: key);

  @override
  State<CRUDEoperation> createState() => _MyWidgetState();
}

// Class untuk menyambungkan Collection dari Firebase
class _MyWidgetState extends State<CRUDEoperation> {
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('items');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _pantone_valueController =
      TextEditingController();

// Fungsi Create Data
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    // Tampilan Update BottomSheet
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Masukan Data:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name', hintText: 'Contoh: Fauzan Zulfa'),
                  ),
                  TextField(
                    controller: _colorController,
                    decoration: const InputDecoration(
                        labelText: 'Code Warna', hintText: 'Contoh: #FFFFF'),
                  ),
                  TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                        labelText: 'Angka', hintText: 'Contoh: 1'),
                  ),
                  TextField(
                    controller: _pantone_valueController,
                    decoration: const InputDecoration(
                        labelText: 'Pantone Value', hintText: 'Contoh: 1817829'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String color = _colorController.text;
                        final int? number =
                            int.tryParse(_numberController.text);
                        final int? pantone_value =
                            int.tryParse(_pantone_valueController.text);
                        if (number != null) {
                          await _items.add({
                            "name": name,
                            "color": color,
                            "number": number,
                            "pantone value": pantone_value
                          });
                          _nameController.text = '';
                          _colorController.text = '';
                          _numberController.text = '';
                          _pantone_valueController.text = '';

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Data berhasil disimpan!'),
                            ),
                          );
                        } else {
                          // Fungsi Error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal menyimpan data!'),
                            ),
                          );
                        }
                      },
                      child: const Text("Simpan Data",
                          style: TextStyle(color: Colors.black)))
                ],
              ));
        });
  }

// Fungsi Delete Data
  Future<void> _delete(String productID) async {
    await _items.doc(productID).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data Telah Terhapus")));
  }

  // Fungsi Edit atau Update Data
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _colorController.text = documentSnapshot['color'];
      _numberController.text = documentSnapshot['number'].toString();
      _pantone_valueController.text =
          documentSnapshot['pantone value'].toString();
    }

    // Tampilan Update BottomSheet
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Perbarui Data:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name', hintText: 'Contoh: Fauzan Zulfa'),
                  ),
                  TextField(
                    controller: _colorController,
                    decoration: const InputDecoration(
                        labelText: 'Code Warna', hintText: 'Contoh: #FFFFFF'),
                  ),
                  TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                        labelText: 'Angka', hintText: 'Contoh: 1'),
                  ),
                  TextField(
                    controller: _pantone_valueController,
                    decoration: const InputDecoration(
                        labelText: 'Pantone Value', hintText: 'Contoh: 1817829'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String color = _colorController.text;
                        final int? number =
                            int.tryParse(_numberController.text);
                        final int? pantone_value =
                            int.tryParse(_pantone_valueController.text);

                        if (name.isNotEmpty &&
                            color.isNotEmpty &&
                            number != null &&
                            pantone_value != null &&
                            documentSnapshot != null) {
                          await _items.doc(documentSnapshot.id).update({
                            "name": name,
                            "color": color,
                            "number": number,
                            "pantone value": pantone_value
                          });
                          _nameController.text = '';
                          _colorController.text = '';
                          _numberController.text = '';
                          _pantone_valueController.text = '';

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Data berhasil diperbarui!'),
                            ),
                          );
                        } else {
                          // Fungsi Error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal memperbarui data!'),
                            ),
                          );
                        }
                      },
                      child: const Text("Perbarui Data",
                          style: TextStyle(color: Colors.black)))
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API - Kelompok 3 SIB3D"),
      ),
      body: StreamBuilder(
          stream: _items.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    // Memanggil Item dengan tampilan Card
                    return Card(
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            documentSnapshot['number'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          radius: 17,
                          backgroundColor: Colors.grey,
                        ),
                        title: Text(
                          documentSnapshot['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(documentSnapshot['color'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              // Button untuk Update dan Delete
                              IconButton(
                                  color: Colors.white,
                                  onPressed: () => _update(documentSnapshot),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  color: Colors.white,
                                  onPressed: () => _delete(documentSnapshot.id),
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      // Button untuk Create
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Kelompok 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      // untuk menggunakan State CRUDoperation sebagai tampilan
      home: const CRUDEoperation(),
    );
  }
}
