import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/widgets/appbar_widgets.dart';
import 'package:myapp/widgets/snackbar.dart';
import 'package:myapp/widgets/yellow_button.dart';

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({required this.data, super.key});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic _pickerImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String overImage;
  late bool processing = true;

  final ImagePicker _picker = ImagePicker();
  pickStoreLogo() async {
    final pickedStoreLogo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95);
    setState(() {
      imageFileLogo = pickedStoreLogo;
    });
    try {} catch (e) {
      setState(() {
        _pickerImageError = 0;
      });
      print(_pickerImageError);
    }
  }

  pickCoverImage() async {
    final pickCoverImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95);
    setState(() {
      imageFileCover = pickCoverImage;
    });
    try {} catch (e) {
      setState(() {
        _pickerImageError = 0;
      });
      print(_pickerImageError);
    }
  }

  // Fucntion UploadStoreLogo
  Future uploadStoreLogo() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-image/${widget.data['email']}.jpg');
        await ref.putFile(File(imageFileLogo!.path));
        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  // UploadCoverImage
  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-image/${widget.data['email']}.jpg-cover');
        await ref2.putFile(File(imageFileCover!.path));
        overImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      overImage = widget.data['coverimage'];
    }
  }

  // Function EditeStoreData
  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': overImage,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

// Fucntion SaveChanges
  saveChanges() async {
    if (_formKey.currentState!.validate()) {
      //Continue
      _formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(
          () async => await uploadCoverImage().whenComplete(() => null));
    } else {
      MyMessageHandler.showSnackBar(_scaffoldkey, "Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBaTitle(title: 'Edit Store'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  const Text("Store Logo",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontSize: 24)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.data['storelogo']),
                        radius: 50,
                      ),
                      Column(
                        children: [
                          YellowButton(
                              label: "Change",
                              width: 0.25,
                              onPressed: () {
                                pickStoreLogo();
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          imageFileLogo == null
                              ? const SizedBox()
                              : YellowButton(
                                  label: "Rset",
                                  width: 0.25,
                                  onPressed: () {
                                    pickStoreLogo();
                                  }),
                        ],
                      ),
                      imageFileLogo == null
                          ? const SizedBox()
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  FileImage(File(imageFileLogo!.path)),
                            ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Divider(
                      color: Colors.amber,
                      thickness: 2.5,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Text("Cover Images",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontSize: 24)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.data['coverimage']),
                        radius: 50,
                      ),
                      Column(
                        children: [
                          YellowButton(
                              label: "Change",
                              width: 0.25,
                              onPressed: () {
                                pickCoverImage();
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          imageFileCover == null
                              ? const SizedBox()
                              : YellowButton(
                                  label: "Rset",
                                  width: 0.25,
                                  onPressed: () {
                                    imageFileCover = null;
                                  }),
                        ],
                      ),
                      imageFileCover == null
                          ? const SizedBox()
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  FileImage(File(imageFileCover!.path)),
                            ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Divider(
                      color: Colors.amber,
                      thickness: 2.5,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        print("Please Inter store name");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      storeName = value!;
                    },
                    initialValue: widget.data['storename'],
                    decoration: textFormFields.copyWith(
                        labelText: "Cover Images",
                        hintText: "Enter Store name")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        print("Please Inter Phone");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormFields.copyWith(
                        labelText: "Phone", hintText: "Enter phone")),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    processing == true
                        ? YellowButton(
                            label: "Canel",
                            width: 0.25,
                            onPressed: () {
                              null;
                            })
                        : YellowButton(
                            label: "Please wait...",
                            width: 0.25,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                    YellowButton(
                        label: "Save Changes",
                        width: 0.5,
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Input Decoration
var textFormFields = InputDecoration(
  labelStyle: const TextStyle(color: Colors.purple),
  labelText: "price",
  hintText: "price.. \$",
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.yellow, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.yellow, width: 1),
  ),
);
