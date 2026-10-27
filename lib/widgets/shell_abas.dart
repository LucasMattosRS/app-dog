import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShellAbas extends StatefulWidget {
  final List<Widget> telas;
  final List<NavigationDestination> destinos;

  const ShellAbas({super.key, required this.telas, required this.destinos});

  @override
  State<ShellAbas> createState() => _ShellAbasState();
}

class _ShellAbasState extends State<ShellAbas> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _aba, children: widget.telas),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borda)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              children: [
                for (var i = 0; i < widget.destinos.length; i++)
                  Expanded(child: _item(i)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i) {
    final d = widget.destinos[i];
    final selecionado = i == _aba;
    final cor = selecionado ? AppColors.verdeEscuro : AppColors.textoSuave;

    return InkWell(
      key: Key('aba_$i'),
      onTap: () => setState(() => _aba = i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconTheme(
            data: IconThemeData(color: cor, size: 24),
            child: selecionado ? (d.selectedIcon ?? d.icon) : d.icon,
          ),
          const SizedBox(height: 3),
          Text(
            d.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: cor,
              fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selecionado ? 48 : 0,
            decoration: BoxDecoration(
              color: AppColors.verde,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
