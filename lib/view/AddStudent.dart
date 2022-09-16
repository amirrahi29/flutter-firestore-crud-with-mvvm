import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../view_model/StudentViewModel.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final studentViewModel = Get.put(StudentViewModel());

  chooseProfileImage() async{
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add Student"),
          ),
          body: Obx(()=>LoadingOverlay(
            isLoading: studentViewModel.isLoading.value,
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[

                    SizedBox(height: 24,),
                    imageFile == null?
                    InkWell(
                      onTap: (){
                        chooseProfileImage();
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ):InkWell(
                      onTap: (){
                        chooseProfileImage();
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(imageFile!),
                                fit: BoxFit.cover
                            ),
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),

                    SizedBox(height: 24,),

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: 'Name',
                          hintText: 'Enter name'
                      ),
                    ),

                    SizedBox(height: 8,),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: 'E-mail',
                          hintText: 'Enter email'
                      ),
                    ),
                    SizedBox(height: 8,),

                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: 'Password',
                          hintText: 'Enter password'
                      ),
                    ),
                    SizedBox(height: 24,),

                    InkWell(
                      onTap: (){
                        if(imageFile != null && nameController.text != ""
                            && emailController.text != "" && passwordController.text != "")
                        {
                          studentViewModel.addStudent(
                              imageFile!,nameController.text,
                              emailController.text,
                              passwordController.text
                          );

                          nameController.text = "";
                          emailController.text = "";
                          passwordController.text = "";

                        }
                        else{
                          Get.snackbar("Form validation",
                              "Please fill all the field and try again",
                              colorText: Colors.white,backgroundColor: Colors.red);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text("Submit",style: TextStyle(color: Colors.white),),
                      ),
                    )



                  ],
                ),
              ),
            ),
          )),
        )
    );
  }
}
