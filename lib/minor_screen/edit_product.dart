import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/uitilities/categ_list.dart';
import 'package:myapp/widgets/pink_button.dart';
import 'package:myapp/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myapp/widgets/yellow_button.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({super.key, required this.items});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String proname;
  late String proDiscr;
  late String proId;
  int? dicount = 0;
  bool processing = false;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];

  final ImagePicker _picker = ImagePicker();

  List<XFile>? imageFileList = [];
  List<dynamic> imageUrlList = [];
  dynamic _pickedImageError;

  void pickImageProduct() async {
    try {
      final pickedImage = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imageFileList = pickedImage!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imageFileList!.isNotEmpty) {
        if (mainCategValue != 'select category' &&
            subCategValue != 'subcategory') {
          try {
            for (var image in imageFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldkey, "Please selected  categories ?");
        }
      } else {
        imageUrlList= widget.items['proimages'];
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldkey, "Please fill all fields");
    }
  }

  editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("products")
          .doc(widget.items['proid']);
      transaction.update(documentReference, {
        'proname': proname,
        'maincateg': mainCategValue,
        'subcateg': subCategValue,
        'price': price,
        'instock': quantity,
        'producs': proDiscr,
        'proimages': imageUrlList,
        'dicount': dicount,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    await uploadImages().whenComplete(() => editProductData());
  }

  Widget previewImage() {
    if (imageFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imageFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imageFileList![index].path));
          });
    } else {
      return const Center(
        child: Text(
          " you have not \n \n picked images yet !",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget previewCurrentImage() {
    List<dynamic> itemImages = widget.items['proimages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
  }

  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                  height: size.width * 0.5,
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade300,
                                  ),
                                  child: previewCurrentImage()),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      imageFileList = [];
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: size.width * 0.5,
                            width: size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "  main category",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(6),
                                      constraints: BoxConstraints(
                                          minWidth: size.width * 0.3),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child:
                                              Text(widget.items['maincateg'])),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "* subcategory",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(6),
                                      constraints: BoxConstraints(
                                          minWidth: size.width * 0.3),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child:
                                              Text(widget.items['subcateg'])),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      ExpandablePanel(
                          theme: const ExpandableThemeData(hasIcon: false),
                          header: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text(
                                  "Change Images & Categories",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          collapsed: const SizedBox(
                              // height: 240,
                              ),
                          expanded: changesImage(size))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                            initialValue:
                                widget.items['price'].toStringAsFixed(2),
                            validator: (value) {
                              if (value!.isEmpty) {
                                // ignore: avoid_print
                                print(' Please Inter price');
                              } else if (value.isValidPrice() != true) {
                                return 'invalid ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormFields.copyWith(
                              labelText: "price",
                              hintText: "price.. \$",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                            initialValue: widget.items['dicount'].toString(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidDiscount() != true) {
                                return 'invalid  discount';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              dicount = int.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormFields.copyWith(
                              labelText: "discount",
                              hintText: "discount.. \$",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                          initialValue: widget.items['instock'].toString(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              // ignore: avoid_print
                              print(' Please Inter Quality ');
                            } else if (value.isValidQuality() != true) {
                              return 'Not Valid quanlity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormFields.copyWith(
                            labelText: "Quality",
                            hintText: "Add Quality",
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['proname'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              // ignore: avoid_print
                              print(' Please Inter Prodcut name');
                            } else {
                              return null;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            proname = value!;
                          },
                          maxLength: 100,
                          maxLines: 3,
                          decoration: textFormFields.copyWith(
                            labelText: "Product Name",
                            hintText: "Inter Product name ",
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['producs'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              // ignore: avoid_print
                              print(' Please Inter decription');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            proDiscr = value!;
                          },
                          maxLength: 800,
                          maxLines: 3,
                          decoration: textFormFields.copyWith(
                            labelText: "Product Decription",
                            hintText: "Inter Product Decription",
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            YellowButton(
                                label: 'Cancel',
                                width: 0.25,
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            YellowButton(
                                label: 'Save Changes',
                                width: 0.30,
                                onPressed: () {
                                  setState(() {
                                    saveChanges();
                                  });
                                })
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PinkButton(
                              label: "Delete Item",
                              width: 0.7,
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('products')
                                          .doc(widget.items['proid']);
                                  transaction.delete(documentReference);
                                }).whenComplete(() => Navigator.pop(context));
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changesImage(Size size) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  height: size.width * 0.5,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade300,
                  ),
                  child: imageFileList != null
                      ? previewImage()
                      : const Center(
                          child: Text(
                            " you have not \n \n picked images yet !",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        imageFileList = [];
                      });
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ))
              ],
            ),
            SizedBox(
              height: size.width * 0.5,
              width: size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        "* selected maincategory",
                        style: TextStyle(color: Colors.red),
                      ),
                      DropdownButton(
                        iconSize: 40,
                        iconEnabledColor: Colors.red,
                        // iconDisabledColor: Colors.black,
                        dropdownColor: Colors.yellow.shade400,
                        disabledHint: const Text(
                          ' select maincategory  ',
                        ),
                        value: mainCategValue,
                        items: maincateg.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          selectedMainCateg(value);
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "* selected subcategory",
                        style: TextStyle(color: Colors.red),
                      ),
                      DropdownButton(
                        iconSize: 40,
                        iconEnabledColor: Colors.red,
                        dropdownColor: Colors.yellow.shade400,
                        iconDisabledColor: Colors.black,
                        menuMaxHeight: 500,
                        disabledHint: const Text(
                          'select category',
                        ),
                        value: subCategValue,
                        items:
                            subCategList.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          print(value);
                          setState(() {
                            subCategValue = value!;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: imageFileList!.isEmpty
              ? YellowButton(
                  label: "Reset Images",
                  width: 0.6,
                  onPressed: () {
                    setState(() {
                      imageFileList = [];
                    });
                  })
              : YellowButton(
                  label: "Change Images",
                  width: 0.6,
                  onPressed: () {
                    setState(() {
                      pickImageProduct();
                    });
                  }),
        )
      ],
    );
  }
}

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

extension QualityValidator on String {
  bool isValidQuality() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
