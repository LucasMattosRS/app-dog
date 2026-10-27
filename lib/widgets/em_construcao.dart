import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'tela_app.dart';

class EmConstrucao extends StatelessWidget {
  final String titulo;

  const EmConstrucao({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: titulo,
      corpo: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 64, color: AppColors.verde),
            SizedBox(height: 12),
            Text(
              'Em construção',
              style: TextStyle(fontSize: 16, color: AppColors.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
