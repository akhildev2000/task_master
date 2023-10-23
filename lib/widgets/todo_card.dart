import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    required this.time,
    required this.check,
    required this.iconBgColor,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              primaryColor: Colors.blue,
              unselectedWidgetColor: const Color(0xff5e616a),
            ),
            child: Transform.scale(
              scale: 1.3,
              child: Checkbox(
                activeColor: const Color(0xff6cf8a9),
                checkColor: const Color(0xff0e3e26),
                value: check,
                onChanged: (bool? value) {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xff2a2e3d),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: iconBgColor),
                      child: Icon(
                        iconData,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
