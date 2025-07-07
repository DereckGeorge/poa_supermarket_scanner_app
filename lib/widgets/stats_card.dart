import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color ?? AppTheme.primaryRed, size: 24),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Determine text size based on available space and text length
                        double fontSize;
                        if (value.length > 12) {
                          fontSize = constraints.maxWidth > 120 ? 16 : 14;
                        } else if (value.length > 8) {
                          fontSize = constraints.maxWidth > 120 ? 18 : 16;
                        } else {
                          fontSize = constraints.maxWidth > 120 ? 20 : 18;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            value,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: color ?? AppTheme.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
