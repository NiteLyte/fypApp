import 'package:flutter/material.dart';

class ExpiryAlarmTile extends StatelessWidget {
  final String title;
  final String expiry;
  final void Function()? onPressed;
  final void Function()? onDismissed;

  const ExpiryAlarmTile({
    Key? key,
    required this.title,
    required this.expiry,
    this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.all(35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                      expiry,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.5),
                      )
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right_rounded, size: 35),
            ],
          ),
        ),
      ),
    );
  }
}