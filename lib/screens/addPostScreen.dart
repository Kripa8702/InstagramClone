import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/userModel.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? post;
  TextEditingController _descriptionController = TextEditingController();

  bool loading = false;

  postImage(String username, String uid, String profImage) async {
    setState(() {
      loading = true;
    });

    try {
      String res = await FirestoreMethods().uploadImage(
          uid, post!, username, _descriptionController.text, profImage);

      setState(() {
        loading = false;
      });

      if (res == "success")
        showSnackBar('Posted!', context);
      else
        showSnackBar(res, context);

      setState(() {
        post = null;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);

                  setState(() {
                    post = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  Uint8List file = await pickImage(ImageSource.gallery);

                  setState(() {
                    post = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return post == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload_rounded),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    post = null;
                  });
                },
              ),
              title: const Text("New Post"),
              centerTitle: false,
              actions: [
                IconButton(
                    onPressed: () =>
                        postImage(user.username, user.uid, user.photoUrl),
                    icon: Icon(
                      Icons.check,
                      color: blueColor,
                      size: 22.sp,
                    )),
                SizedBox(
                  width: 4.w,
                )
              ],
            ),
            body: Column(
              children: [
                loading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Profile pic
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),

                    //Caption
                    SizedBox(
                      width: 45.w,
                      child: TextField(
                        maxLines: 8,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none),
                      ),
                    ),

                    //Post
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: AspectRatio(
                        aspectRatio: 6.w / 2.h,
                        child: Container(
                            decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(post!),
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter),
                        )),
                      ),
                    ),
                  ],
                ),
                const Divider()
              ],
            ),
          );
  }
}
