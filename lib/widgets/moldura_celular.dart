import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Em telas grandes (navegador do computador), mostra o app dentro de uma
/// moldura de celular. Em celulares de verdade, o app ocupa a tela toda.
class MolduraCelular extends StatelessWidget {
  final Widget child;

  const MolduraCelular({super.key, required this.child});

  static const _largura = 390.0;
  static const _alturaMaxima = 844.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, limites) {
        if (limites.maxWidth < 600) return child;

        final altura = min(_alturaMaxima, limites.maxHeight - 32);
        final mostrarLogo = limites.maxWidth >= 1000;

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B1F12), Color(0xFF07661D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mostrarLogo) ...[
                  Image.asset('assets/images/logo_sps_escuro.png', width: 300),
                  const SizedBox(width: 64),
                ],
                Container(
                  width: _largura + 20,
                  height: altura + 20,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.verdeClaro.withValues(alpha: 0.25),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        size: Size(_largura, altura),
                        padding: EdgeInsets.zero,
                        viewPadding: EdgeInsets.zero,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
