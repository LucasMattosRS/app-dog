import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../theme/app_colors.dart';
import '../../widgets/comum.dart';
import '../mensagens/mensagens_screen.dart';
import 'despesas_screen.dart';
import 'equipe_permissoes_screen.dart';
import 'servicos_regras_screen.dart';

List<Widget> acoesGestor(BuildContext context) {
  return [
    IconButton(
      onPressed: () => avisar(
        context,
        '${DadosDemo.solicitacoes.length} solicitações aguardando confirmação',
      ),
      icon: Badge(
        isLabelVisible: DadosDemo.solicitacoes.isNotEmpty,
        backgroundColor: AppColors.verdeClaro,
        smallSize: 8,
        child: const Icon(Icons.notifications, size: 26),
      ),
    ),
    Builder(
      builder: (context) => IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.account_circle_outlined, size: 28),
      ),
    ),
  ];
}

class MenuGestor extends StatelessWidget {
  const MenuGestor({super.key});

  @override
  Widget build(BuildContext context) {
    void abrir(Widget tela) {
      final nav = Navigator.of(context);
      nav.pop();
      nav.push(MaterialPageRoute(builder: (_) => tela));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Image.asset('assets/images/logo_sps.png', height: 70),
            ),
          ),
          ListTile(
            leading: const IconeMensagens(),
            title: const Text('Mensagens do atendimento'),
            onTap: () => abrir(const MensagensScreen(nomeResponsavel: 'Gestor')),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Despesas e relatórios'),
            onTap: () => abrir(const DespesasScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('Equipe e permissões'),
            onTap: () => abrir(const EquipePermissoesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Serviços, preços e regras'),
            onTap: () => abrir(const ServicosRegrasScreen()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Trocar perfil'),
            onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),
        ],
      ),
    );
  }
}
