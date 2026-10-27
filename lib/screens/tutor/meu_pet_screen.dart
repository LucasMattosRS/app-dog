import 'package:flutter/material.dart';
import '../../data/dados_demo.dart';
import '../../theme/app_colors.dart';
import '../../widgets/comum.dart';
import '../../widgets/item_info.dart';
import '../../widgets/tela_app.dart';

class MeuPetScreen extends StatelessWidget {
  const MeuPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const pet = DadosDemo.thor;

    return TelaApp(
      titulo: 'Meu pet',
      rodape: FilledButton(
        onPressed: () => avisar(context, 'Cadastro salvo'),
        child: const Text('Salvar'),
      ),
      corpo: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(DadosDemo.fotoCapaThor, fit: BoxFit.cover),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: AppColors.verdeEscuro),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.nome,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.texto,
                          ),
                        ),
                      ),
                      const Icon(Icons.edit, color: AppColors.verdeEscuro, size: 20),
                    ],
                  ),
                  Text(
                    pet.raca,
                    style: const TextStyle(fontSize: 15, color: AppColors.textoSuave),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 22,
                      child: Row(
                        children: [
                          _Dado(icone: Icons.male, texto: pet.sexo),
                          const VerticalDivider(width: 24),
                          _Dado(icone: Icons.schedule, texto: '${pet.idade} anos'),
                          const VerticalDivider(width: 24),
                          _Dado(icone: Icons.pets, texto: pet.porte),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ItemInfo(
            icone: Icons.pets,
            titulo: 'Porte',
            subtitulo: pet.porte,
          ),
          ItemInfo(
            icone: Icons.vaccines,
            titulo: 'Vacinas',
            subtitulo: pet.vacinas.join('\n'),
          ),
          ItemInfo(
            icone: Icons.rice_bowl,
            titulo: 'Alimentação',
            subtitulo: pet.alimentacao,
          ),
          ItemInfo(
            icone: Icons.person,
            titulo: 'Contato do tutor',
            subtitulo: '${pet.tutorNome}\n${pet.tutorTelefone}',
          ),
        ],
      ),
    );
  }
}

class _Dado extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _Dado({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: 18, color: AppColors.verdeEscuro),
        const SizedBox(width: 6),
        Text(texto, style: const TextStyle(fontSize: 13, color: AppColors.texto)),
      ],
    );
  }
}
