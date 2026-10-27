import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../utils/datas.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class TaxiEquipeScreen extends StatefulWidget {
  const TaxiEquipeScreen({super.key});

  @override
  State<TaxiEquipeScreen> createState() => _TaxiEquipeScreenState();
}

class _TaxiEquipeScreenState extends State<TaxiEquipeScreen> {
  static const _filtros = [null, StatusViagem.aBuscar, StatusViagem.emTransporte, StatusViagem.entregue];
  int _filtro = 0;

  static String rotulo(StatusViagem s) => switch (s) {
        StatusViagem.aBuscar => 'A buscar',
        StatusViagem.emTransporte => 'Em transporte',
        StatusViagem.entregue => 'Entregue',
      };

  void _abrir(Viagem v) {
    final (acao, proximo) = switch (v.status) {
      StatusViagem.aBuscar => ('Registrar busca', StatusViagem.emTransporte),
      StatusViagem.emTransporte => ('Registrar entrega', StatusViagem.entregue),
      StatusViagem.entregue => ('', StatusViagem.entregue),
    };

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AvatarPet(v.pet),
                title: Text(v.pet, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(v.raca),
                trailing: Selo(rotulo(v.status)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone, color: AppColors.verde),
                title: Text(v.tutor),
                subtitle: Text(v.telefone),
              ),
              const SizedBox(height: 8),
              if (v.status != StatusViagem.entregue)
                FilledButton(
                  onPressed: () {
                    final busca = v.status == StatusViagem.aBuscar;
                    setState(() => v.status = proximo);
                    Atividades.instancia.registrar(
                      tipo: TipoAtividade.taxi,
                      pet: v.pet,
                      titulo: busca ? 'Busca realizada' : 'Entrega realizada',
                      detalhe: busca
                          ? '${v.enderecoBusca} - ${v.bairroBusca}'
                          : '${v.enderecoEntrega} - ${v.bairroEntrega}',
                    );
                    Navigator.pop(ctx);
                    avisar(context, '$acao: ${v.pet} às ${Datas.hora(DateTime.now())}');
                  },
                  child: Text(acao),
                )
              else
                const Text(
                  'Viagem concluída.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textoSuave),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final filtro = _filtros[_filtro];
    final viagens =
        DadosDemo.viagens.where((v) => filtro == null || v.status == filtro).toList();

    return TelaApp(
      titulo: 'Táxi Dog da equipe',
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FiltroAbas(
            opcoes: const ['Todos', 'A buscar', 'Em transporte', 'Entregue'],
            selecionada: _filtro,
            aoSelecionar: (i) => setState(() => _filtro = i),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.event, size: 18, color: AppColors.verde),
              const SizedBox(width: 6),
              Text(
                'Hoje, ${hoje.day} de ${Datas.meses[hoje.month - 1].toLowerCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (viagens.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Nenhuma viagem neste status.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textoSuave),
              ),
            ),
          for (final v in viagens)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: InkWell(
                  onTap: () => _abrir(v),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AvatarPet(v.pet),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v.pet, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    v.raca,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textoSuave),
                                  ),
                                ],
                              ),
                            ),
                            Selo(rotulo(v.status)),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _Trecho(
                          titulo: 'Busca • ${v.horaBusca}',
                          endereco: v.enderecoBusca,
                          bairro: v.bairroBusca,
                          feito: v.status != StatusViagem.aBuscar,
                          linha: true,
                        ),
                        _Trecho(
                          titulo: 'Entrega • ${v.horaEntrega}',
                          endereco: v.enderecoEntrega,
                          bairro: v.bairroEntrega,
                          feito: v.status == StatusViagem.entregue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Trecho extends StatelessWidget {
  final String titulo;
  final String endereco;
  final String bairro;
  final bool feito;
  final bool linha;

  const _Trecho({
    required this.titulo,
    required this.endereco,
    required this.bairro,
    required this.feito,
    this.linha = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              feito ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 16,
              color: feito ? AppColors.verde : AppColors.textoSuave,
            ),
            if (linha) Container(width: 2, height: 34, color: AppColors.borda),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text(endereco, style: const TextStyle(fontSize: 13)),
              Text(bairro, style: const TextStyle(fontSize: 11, color: AppColors.textoSuave)),
            ],
          ),
        ),
      ],
    );
  }
}
