import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_frontend/widgets/custom_button.dart';

class ChooseRoleScreen extends StatefulWidget {
  final String? connectionCode;
  const ChooseRoleScreen({Key? key, this.connectionCode}) : super(key: key);
  @override
  _ChooseRoleScreenState createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  int selectedIndex = -1;

  void onImageTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget buildCircleImage(String path, int index, double maxWidth) {
    bool isSelected = selectedIndex == index;

    double imageSize = maxWidth * 0.325;

    return GestureDetector(
      onTap: () => onImageTap(index),
      child: ColorFiltered(
        colorFilter:
            isSelected || selectedIndex == -1
                ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : ColorFilter.matrix(<double>[
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
        child: ClipOval(
          child: Image.asset(
            path,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Your Role")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select your role",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          buildCircleImage(
                            'assets/images/parent_bears.png',
                            0,
                            maxWidth,
                          ),
                          SizedBox(height: 10),
                          Text("I am a Parent"),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        children: [
                          buildCircleImage(
                            'assets/images/children_bear.png',
                            1,
                            maxWidth,
                          ),
                          SizedBox(height: 10),
                          Text("I am a Son/Daughter"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: "Continue",
                      onPressed: () {
                        if (selectedIndex != -1) {
                          context.go(
                            '/see-connectioncode',
                            extra: widget.connectionCode,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select a role")),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
