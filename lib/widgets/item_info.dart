import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ItemInfo extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback? aoTocar;

  const ItemInfo({
    super.key,
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.chip,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icone, color: AppColors.verde),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.texto,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitulo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textoSuave,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textoSuave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
