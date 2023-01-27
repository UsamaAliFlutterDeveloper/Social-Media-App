import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/screens/chats/rooms.dart';

class AgoraScreen extends StatefulWidget {
  const AgoraScreen({Key? key}) : super(key: key);
  @override
  State<AgoraScreen> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  final AgoraClient client = AgoraClient(
    enabledPermission: [Permission.camera, Permission.microphone],
    agoraConnectionData: AgoraConnectionData(
      appId: "ef68c2e6461c4cce837ae30b872fbd1b",
      channelName: "test",
      username: "user",
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Social Media App'),
        leading: IconButton(
            onPressed: () {
              Get.offAll(const RoomsPage());
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true,
              showAVState: true,
              showNumberOfUsers: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              autoHideButtons: true,
            ),
          ],
        ),
      ),
    );
  }
}
