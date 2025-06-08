import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

Widget skeletonList({int itemCount = 6}) {
  return ListView.builder(
    itemCount: itemCount,
    itemBuilder: (_, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Container(
              height: 16,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(height: 14, width: 100, color: Colors.grey[300]),
                const SizedBox(height: 6),
                Container(height: 14, width: 150, color: Colors.grey[300]),
              ],
            ),
            trailing: Container(
              width: 60,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      );
    },
  );
}
