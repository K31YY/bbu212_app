import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:bbu212_app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _keyForm = GlobalKey<FormState>();
  File? _image;

  Future<void> _pickImage() async {
    final imgPicker = ImagePicker();
    final image = await imgPicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
    // Function to pick image from gallery or camera
  }

  Future<void> addCategory(String name, String desc, File? image) async {
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 1));
    var uri = Uri.parse('http://10.0.2.2/btb212/categories/add_category.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['category_name_new'] = name;
    request.fields['desc_new'] = desc;
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image_new', image.path),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final msg = jsonDecode(res.body);
      if (msg['success'] == 1) {
        EasyLoading.showSuccess("${msg['msg_success']}");
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        EasyLoading.showError("${msg['msg_error']}");
      }
    } else {
      EasyLoading.showError('Failed to add category');
    }
  }

  void _addCategoryDialog(BuildContext context) {
    final namecontroller = TextEditingController();
    final desccontroller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _keyForm,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "New Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child:
                        // condition ? EXPR1 :  EXPR2
                        _image == null
                        ? Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                        : Image.file(_image!, height: 150, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter category name';
                      }
                      return null;
                    },
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: desccontroller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        String name = namecontroller.text;
                        String desc = desccontroller.text;
                        addCategory(name, desc, _image);
                      }
                      // Handle save action
                    },
                    icon: Icon(Icons.add, color: AppColors.white),
                    label: Text(
                      "Add Category",
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: AppColors.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
    // Function to add a new category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_rounded),
            onPressed: () => _addCategoryDialog(context),
          ),
        ],
      ),
      body: ListView(),
    );
  }
}
