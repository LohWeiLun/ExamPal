import 'package:flutter/material.dart';
class CommunityList extends StatelessWidget {
  const CommunityList({
    Key? key,
    required this.title,
    this.colorl = const Color(0xFF7553F6),
    required this.desc,
    required this.isPrivate,
  }) : super(key: key);

  final String title;
  final String desc;
  final Color colorl;
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colorl,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isPrivate ? Icons.lock_person_rounded : Icons.public,
            size: 20.0,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}
