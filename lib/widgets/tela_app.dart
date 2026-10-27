import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Estrutura padrão das telas: cabeçalho escuro e conteúdo em painel
/// arredondado, com um botão fixo opcional no rodapé.
class TelaApp extends StatelessWidget {
  final String titulo;
  final IconData? iconeTitulo;
  final bool tituloGrande;
  final List<Widget>? acoes;
  final Widget? menu;
  final Widget corpo;
  final Widget? rodape;

  const TelaApp({
    super.key,
    required this.titulo,
    this.iconeTitulo,
    this.tituloGrande = false,
    this.acoes,
    this.menu,
    required this.corpo,
    this.rodape,
  });

  @override
  Widget build(BuildContext context) {
    final grande = tituloGrande || iconeTitulo != null;

    return Scaffold(
      backgroundColor: AppColors.verdeEscuro,
      drawer: menu,
      appBar: AppBar(
        centerTitle: !grande && menu == null,
        toolbarHeight: grande ? 68 : kToolbarHeight,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconeTitulo != null) ...[
              Icon(iconeTitulo, size: 30),
              const SizedBox(width: 14),
            ],
            Flexible(
              child: Text(
                titulo,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: grande ? 24 : 19),
              ),
            ),
          ],
        ),
        actions: acoes,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        child: ColoredBox(
          color: AppColors.fundo,
          child: Column(
            children: [
              Expanded(child: corpo),
              if (rodape != null)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: rodape,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
