import 'package:flutter/material.dart';
import '../../widgets/comum.dart';
import '../../widgets/item_info.dart';
import '../../widgets/tela_app.dart';
import '../mensagens/mensagens_screen.dart';
import 'despesas_screen.dart';
import 'equipe_permissoes_screen.dart';
import 'servicos_regras_screen.dart';

class ProprietarioMaisScreen extends StatelessWidget {
  const ProprietarioMaisScreen({super.key});

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Mais',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ItemInfo(
            icone: Icons.chat_bubble_outline,
            titulo: 'Mensagens do atendimento',
            subtitulo: 'Conversas dos tutores com a IA e respostas da equipe',
            aoTocar: () => _abrir(
              context,
              const MensagensScreen(nomeResponsavel: 'Gestor'),
            ),
          ),
          ItemInfo(
            icone: Icons.bar_chart,
            titulo: 'Despesas e relatórios',
            subtitulo: 'Gastos por categoria e resultado de caixa',
            aoTocar: () => _abrir(context, const DespesasScreen()),
          ),
          ItemInfo(
            icone: Icons.groups_outlined,
            titulo: 'Equipe e permissões',
            subtitulo: 'Funcionários, funções e acessos',
            aoTocar: () => _abrir(context, const EquipePermissoesScreen()),
          ),
          ItemInfo(
            icone: Icons.pets,
            titulo: 'Serviços, preços e regras',
            subtitulo: 'Tabela de valores, Táxi Dog e retenção de fotos',
            aoTocar: () => _abrir(context, const ServicosRegrasScreen()),
          ),
          const SizedBox(height: 8),
          ItemInfo(
            icone: Icons.logout,
            titulo: 'Trocar perfil',
            subtitulo: 'Voltar para a escolha de perfil',
            aoTocar: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          const LogoRodape(),
        ],
      ),
    );
  }
}
