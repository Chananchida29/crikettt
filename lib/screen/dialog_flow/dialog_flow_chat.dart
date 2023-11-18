import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:newtest/config/constant.dart';
import 'package:newtest/screen/dialog_flow/app_body.dart';

class DialogFlowChat extends StatefulWidget {
  // การกำหนดส่วนด้านในคลาส
  DialogFlowChat({Key key})
      : super(key: key); // ใช้ key แบบไม่ซ้ำกัน ตัวสร้างเรีกว่า superclass

  @override
  _DialogFlowChatState createState() =>
      _DialogFlowChatState(); // เป็นการเชื่อมโยงคลาส และ เมธอด
}

class _DialogFlowChatState extends State<DialogFlowChat> {
  // ไว้จัดการสถานะของ dialogflowchat
  DialogFlowtter dialogFlowtter; // ประกาศตัวแปร ที่ใช้เพื่อสื่อสาร แบบกำหนดเอง
  final TextEditingController _controller =
      TextEditingController(); // ประกาศ เตรียมใช้งาน เพื่อป้อนข้อความ แก้ไขข้อความ

  List<Map<String, dynamic>> messages =
      []; // รายการที่มีชื่อ แบบสตริง ค่าประเภทไดนามิก เพื่อจัดเก็บข้อมูล หรือประวัติสนทนา

  @override
  void initState() {
    super.initState(); // เรียกใช้เมธอด
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // กำหนดเวลา เพื่อใช้หลังจากเฟรมปัจจุบัน
      dialogFlowtter = await DialogFlowtter.fromFile(
          // ตัวแปรจะสร้างอินสแตน(ขนาดย่อหน้าต่าง)
          path: 'asset/dialog_flow/dialog_flow.json',
          projectId:
              'bot-oxrf'); // เพื่อกำหนดค่าไฟล์ json ถูกตั่งค่า projectId 'bot-oxrf'
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // โครงสร้าง UI
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat Bot Cricket',
          ),
          backgroundColor: pColor,
        ),
        body: Column(
          children: [
            Expanded(
                child: AppBody(messages: messages)), // ขยายกล่องข้อความในแนวนอน
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10, // แนวนอน
                vertical: 5, // แนวตั้ง
              ),
              color: pColor,
              child: Row(
                // แนวนอน
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return; // ตรวจสอบ ถ้าว่างไม่จำเป็นต้องส่งข้อความ
    setState(() {
      // อัพเดตสถานะ
      addMessage(
        // เพิ่มข้อความผู้ใช้ในรายการข้อความ
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      // ตรวจสอบข้อความของผู้ใช้งาน
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message == null)
      return; // ตรวจสอบ หากข้อความจาก dialogflow เป้นค่าว่าง เมธอดจะส่งกลับ เพื่อตรวจสอบให้แน่ใจว่าตอบกลับถูกต้อง
    setState(() {
      // จะถูกเรียกใช้อีกครั้ง เพื่อข้อความการตอบกลับ
      addMessage(response.message);
    });
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    // เพิ่มข้อความจากผู้ใช้งาน
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  void dispose() {
    // วิธีการกำจัดจะถูกเรียกเมื่อสถานะถูกลบออก
    dialogFlowtter.dispose();
    super.dispose();
  }
}
