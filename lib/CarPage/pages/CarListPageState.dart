import 'package:flutter/material.dart';

import '../model/car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  const CarCard({
    super.key,
    required this.car,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 左边：图片 + 名字
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  // 先用一个灰色方块占位，之后换成真实图片
                  Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey,
                    child: const Icon(Icons.directions_car),
                  ),
                  const SizedBox(height: 8),
                  const Text("ID #12"),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // 右边：详细信息 Expanded = 占据 Row/Column 里“剩下的全部空间”
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${car.year} ${car.make} ${car.model}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(car.price),
                  Text("${car.mileage} · ${car.type}"),
                  Text("ID #${car.id}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
