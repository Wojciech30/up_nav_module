import 'package:flutter/material.dart';
import 'package:up_nav_module/models/building.dart';
import 'package:up_nav_module/widgets/building_image.dart';

class BuildingListItem extends StatelessWidget {
  final Building building;
  final VoidCallback onTap;

  const BuildingListItem({
    super.key,
    required this.building,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            BuildingImage(
              imageUrl: building.imageUrl,
              width: 100,
              height: 100,
              borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      building.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      building.address,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
