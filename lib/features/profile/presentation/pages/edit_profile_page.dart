import 'dart:math';

import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/profile/index.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage;
  String? _base64Image;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _pickAndEncodeImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        _selectedImage = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff4356B4),
            Color(0xff3DCFCF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.2],
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              CupertinoIcons.back,
              size: 24,
              color: Colors.white,
            ),
          ),
          title: Text(
            S.current.edit_info,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                getIt<ProfileBloc>().add(
                  ProfileEvent.updateProfile(
                    username: _nameController.text,
                    avatarFile: _selectedImage,
                  ),
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Lưu thành công!')));
              },
              child: Text(
                S.current.save,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: getIt<ProfileBloc>(),
            builder: (context, state) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.h,
                    ),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : user?.photoURL != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: user!.photoURL!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff4356B4),
                                            Color(0xff3DCFCF),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person_solid,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: GestureDetector(
                              onTap: _pickAndEncodeImage,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xff4356B4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                    style: BorderStyle.solid,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(1, 2),
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Icon(
                                  CupertinoIcons.camera_fill,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
