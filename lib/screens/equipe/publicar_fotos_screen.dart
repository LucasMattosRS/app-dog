import 'package:flutter/material.dart';
import '../../data/atividades.dart';
import '../../data/dados_demo.dart';
import '../../models/operacao.dart';
import '../../theme/app_colors.dart';
import '../../widgets/comum.dart';
import '../../widgets/tela_app.dart';

class PublicarFotosScreen extends StatefulWidget {
  const PublicarFotosScreen({super.key});

  @override
  State<PublicarFotosScreen> createState() => _PublicarFotosScreenState();
}

class _PublicarFotosScreenState extends State<PublicarFotosScreen> {
  static const _fotos = [DadosDemo.fotoCapaThor, ...DadosDemo.fotosThor];

  String _pet = DadosDemo.petsDaCasa.first.$1;
  int? _foto = 0;
  final _legenda = TextEditingController();

  @override
  void dispose() {
    _legenda.dispose();
    super.dispose();
  }

  // Na demonstração, "tirar" ou "selecionar" alterna entre fotos de exemplo.
  void _escolherFoto() {
    setState(() => _foto = ((_foto ?? -1) + 1) % _fotos.length);
  }

  void _publicar() {
    final legenda = _legenda.text.trim();
    Atividades.instancia.registrar(
      tipo: TipoAtividade.foto,
      pet: _pet,
      titulo: 'Foto publicada',
      detalhe: legenda.isEmpty ? 'Disponível para o tutor' : legenda,
    );
    avisar(context, 'Foto publicada para o tutor de $_pet');
    setState(() => _foto = null);
    _legenda.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TelaApp(
      titulo: 'Publicar fotos',
      rodape: FilledButton(
        onPressed: _foto == null ? null : _publicar,
        child: const Text('Publicar'),
      ),
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _pet,
                  isExpanded: true,
                  itemHeight: 68,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    for (final p in DadosDemo.petsDaCasa)
                      DropdownMenuItem(
                        value: p.$1,
                        child: Row(
                          children: [
                            AvatarPet(p.$1, raio: 24),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.$1,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  p.$2,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textoSuave),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _pet = v!),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: _foto == null
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borda),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.textoSuave),
                          SizedBox(height: 8),
                          Text(
                            'Nenhuma foto selecionada',
                            style: TextStyle(color: AppColors.textoSuave),
                          ),
                        ],
                      ),
                    ),
                  )
                : FotoPet(_fotos[_foto!], raio: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _escolherFoto,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    backgroundColor: AppColors.verdeEscuro,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: const Text('Tirar foto'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _escolherFoto,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: AppColors.borda),
                    foregroundColor: AppColors.texto,
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  icon: const Icon(Icons.image_outlined, size: 20),
                  label: const Text('Selecionar arquivo'),
                ),
              ),
            ],
          ),
          const Rotulo('Legenda da foto'),
          TextField(
            controller: _legenda,
            maxLength: 200,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'Escreva uma legenda...'),
          ),
          const Rotulo('Marca do estabelecimento (prévia)'),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.chip.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borda),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/logo_sps.png', height: 56),
                const SizedBox(height: 6),
                const Text(
                  'Aplicada automaticamente em todas as fotos.',
                  style: TextStyle(fontSize: 12, color: AppColors.textoSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
