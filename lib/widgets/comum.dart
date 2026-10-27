import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

void avisar(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(mensagem)));
}

IconData iconeServico(String servico) => switch (servico) {
      'Hotel' => Icons.hotel,
      'Creche' => Icons.wb_sunny_outlined,
      'Escolinha' => Icons.school,
      'Adestramento' => Icons.pets,
      'Banho' => Icons.bathtub_outlined,
      _ => Icons.star_outline,
    };

class AvatarPet extends StatelessWidget {
  final String nome;
  final double raio;

  const AvatarPet(this.nome, {super.key, this.raio = 22});

  static const _cores = [
    Color(0xFFD9A55B),
    Color(0xFF8D6E63),
    Color(0xFF4E342E),
    Color(0xFFC8A27A),
    Color(0xFF6D4C41),
  ];

  static const _fotos = {'Thor': 'assets/images/pets/thor_avatar.jpg'};

  @override
  Widget build(BuildContext context) {
    final foto = _fotos[nome];
    if (foto != null) {
      return CircleAvatar(radius: raio, backgroundImage: AssetImage(foto));
    }
    final indice = nome.codeUnits.fold<int>(0, (a, b) => a + b) % _cores.length;
    return CircleAvatar(
      radius: raio,
      backgroundColor: _cores[indice],
      child: Icon(Icons.pets, color: Colors.white, size: raio),
    );
  }
}

class AvatarPessoa extends StatelessWidget {
  final String nome;
  final double raio;

  const AvatarPessoa(this.nome, {super.key, this.raio = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: raio,
      backgroundColor: AppColors.chip,
      child: Text(
        nome.substring(0, 1),
        style: TextStyle(
          fontSize: raio * 0.9,
          fontWeight: FontWeight.bold,
          color: AppColors.verdeEscuro,
        ),
      ),
    );
  }
}

class Selo extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final Color cor;
  final Color fundo;

  const Selo(
    this.texto, {
    super.key,
    this.icone,
    this.cor = AppColors.verdeEscuro,
    this.fundo = AppColors.chip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 13, color: cor),
            const SizedBox(width: 4),
          ],
          Text(
            texto,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor),
          ),
        ],
      ),
    );
  }
}

class TituloSecao extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final Widget? acao;
  final bool seta;

  const TituloSecao(this.texto, {super.key, this.icone, this.acao, this.seta = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (icone != null) ...[
            Icon(icone, color: AppColors.verde, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
          ),
          ?acao,
          if (seta) const Icon(Icons.chevron_right, color: AppColors.texto),
        ],
      ),
    );
  }
}

class Secao extends StatelessWidget {
  final String? titulo;
  final IconData? icone;
  final Widget? acao;
  final bool seta;
  final Widget child;
  final EdgeInsetsGeometry margem;

  const Secao({
    super.key,
    this.titulo,
    this.icone,
    this.acao,
    this.seta = false,
    required this.child,
    this.margem = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margem,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (titulo != null) TituloSecao(titulo!, icone: icone, acao: acao, seta: seta),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class CabecalhoPet extends StatelessWidget {
  final String nome;
  final String raca;
  final VoidCallback? aoTocar;

  const CabecalhoPet({
    super.key,
    required this.nome,
    required this.raca,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: aoTocar,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: AvatarPet(nome, raio: 24),
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(raca),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class FiltroAbas extends StatelessWidget {
  final List<String> opcoes;
  final int selecionada;
  final ValueChanged<int> aoSelecionar;

  const FiltroAbas({
    super.key,
    required this.opcoes,
    required this.selecionada,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < opcoes.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == opcoes.length - 1 ? 0 : 6),
              child: Material(
                color: i == selecionada ? AppColors.verdeEscuro : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: i == selecionada ? AppColors.verdeEscuro : AppColors.borda,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => aoSelecionar(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        opcoes[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: i == selecionada ? Colors.white : AppColors.texto,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AbasSublinhadas extends StatelessWidget {
  final List<String> opcoes;
  final int selecionada;
  final ValueChanged<int> aoSelecionar;

  const AbasSublinhadas({
    super.key,
    required this.opcoes,
    required this.selecionada,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < opcoes.length; i++)
          Expanded(
            child: InkWell(
              onTap: () => aoSelecionar(i),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      opcoes[i],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: i == selecionada ? AppColors.verdeEscuro : AppColors.textoSuave,
                      ),
                    ),
                  ),
                  Container(
                    height: i == selecionada ? 3 : 1,
                    color: i == selecionada ? AppColors.verdeEscuro : AppColors.borda,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class BotaoOpcao extends StatelessWidget {
  final IconData icone;
  final String nome;
  final bool selecionado;
  final VoidCallback aoTocar;

  const BotaoOpcao({
    super.key,
    required this.icone,
    required this.nome,
    required this.selecionado,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selecionado ? AppColors.chip : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selecionado ? AppColors.verde : AppColors.borda,
          width: selecionado ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              Icon(icone, color: AppColors.verdeEscuro),
              const SizedBox(height: 4),
              Text(
                nome,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CampoSelecao extends StatelessWidget {
  final IconData icone;
  final String texto;
  final bool vazio;
  final VoidCallback? aoTocar;

  const CampoSelecao({
    super.key,
    required this.icone,
    required this.texto,
    this.vazio = false,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borda),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icone, size: 20, color: AppColors.textoSuave),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                    color: vazio ? AppColors.textoSuave : AppColors.texto,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textoSuave),
            ],
          ),
        ),
      ),
    );
  }
}

class Rotulo extends StatelessWidget {
  final String texto;

  const Rotulo(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(texto, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class OpcaoRadio extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final bool selecionado;
  final VoidCallback aoTocar;

  const OpcaoRadio({
    super.key,
    required this.texto,
    this.icone,
    required this.selecionado,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              selecionado ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selecionado ? AppColors.verde : AppColors.textoSuave,
            ),
            const SizedBox(width: 10),
            if (icone != null) ...[
              Icon(icone, size: 20, color: AppColors.verdeEscuro),
              const SizedBox(width: 8),
            ],
            Text(texto),
          ],
        ),
      ),
    );
  }
}

class Legenda extends StatelessWidget {
  final Color cor;
  final String texto;

  const Legenda(this.cor, this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(texto, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class MarcaDagua extends StatelessWidget {
  final double altura;

  const MarcaDagua({super.key, this.altura = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Image.asset('assets/images/logo_sps.png', height: altura),
    );
  }
}

/// Foto do pet com a logo da SPS aplicada como marca-d'água.
class FotoPet extends StatelessWidget {
  final String caminho;
  final double raio;

  const FotoPet(this.caminho, {super.key, this.raio = 12});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(raio),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(caminho, fit: BoxFit.cover),
          const Positioned(right: 6, bottom: 6, child: MarcaDagua()),
        ],
      ),
    );
  }
}

class LogoRodape extends StatelessWidget {
  const LogoRodape({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Image.asset('assets/images/logo_sps.png', height: 44),
    );
  }
}
