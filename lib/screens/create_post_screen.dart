import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/models/user_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controller/create_post_controller.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
    required this.userDetail,
  });

  final UserModelFireBase userDetail;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<CreatePostControllerFirebase>(
        init: CreatePostControllerFirebase(),
        builder: (_) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back)),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('Create Post'),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        _.addPostToFirestore(
                            posttext: _.postTextcontroller.text,
                            userimageurl: widget.userDetail.profileImageUrl,
                            username: widget.userDetail.name);
                      },
                      child: const Text('Post'),
                    )
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          widget.userDetail.profileImageUrl,
                          fit: BoxFit.cover,
                        )),
                  ),
                  title: Text(widget.userDetail.name),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {},
                            icon: const Icon(Icons.group),
                            label: Row(
                              children: const [
                                Text('Friends'),
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: Row(
                              children: const [
                                Text('Album'),
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _.pickUserPostImage(context);
                  },
                  child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: _.postimageFile != null
                          ? Image.file(
                              _.postimageFile!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(MdiIcons.camera)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _.postTextcontroller,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What\'s on your Mind?',
                    hintStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
