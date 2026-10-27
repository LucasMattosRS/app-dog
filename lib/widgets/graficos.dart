import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GraficoBarras extends StatelessWidget {
  final List<String> rotulos;
  final List<List<double>> series;
  final List<Color> cores;
  final bool empilhado;
  final double altura;

  const GraficoBarras({
    super.key,
    required this.rotulos,
    required this.series,
    required this.cores,
    this.empilhado = false,
    this.altura = 120,
  });

  @override
  Widget build(BuildContext context) {
    var maximo = 0.0;
    for (var j = 0; j < rotulos.length; j++) {
      if (empilhado) {
        var soma = 0.0;
        for (final s in series) {
          soma += s[j];
        }
        maximo = max(maximo, soma);
      } else {
        for (final s in series) {
          maximo = max(maximo, s[j]);
        }
      }
    }
    if (maximo == 0) maximo = 1;

    return Column(
      children: [
        SizedBox(
          height: altura,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var j = 0; j < rotulos.length; j++)
                Expanded(
                  child: empilhado
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var i = series.length - 1; i >= 0; i--)
                              _barra(
                                altura * series[i][j] / maximo,
                                cores[i],
                                16,
                                topo: i == series.length - 1,
                              ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (var i = 0; i < series.length; i++)
                              _barra(
                                altura * series[i][j] / maximo,
                                cores[i],
                                series.length > 1 ? 9 : 18,
                                topo: true,
                              ),
                          ],
                        ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final r in rotulos)
              Expanded(
                child: Text(
                  r,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.textoSuave),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _barra(double altura, Color cor, double largura, {required bool topo}) {
    return Container(
      width: largura,
      height: altura,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: topo ? const BorderRadius.vertical(top: Radius.circular(4)) : null,
      ),
    );
  }
}

class GraficoLinha extends StatelessWidget {
  final List<double> valores;
  final List<String> rotulos;
  final double altura;

  const GraficoLinha({
    super.key,
    required this.valores,
    required this.rotulos,
    this.altura = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: altura,
          width: double.infinity,
          child: CustomPaint(painter: _PintorLinha(valores)),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final r in rotulos)
              Text(r, style: const TextStyle(fontSize: 11, color: AppColors.textoSuave)),
          ],
        ),
      ],
    );
  }
}

class _PintorLinha extends CustomPainter {
  final List<double> valores;

  _PintorLinha(this.valores);

  @override
  void paint(Canvas canvas, Size size) {
    if (valores.length < 2) return;
    final maior = valores.reduce(max);
    final menor = valores.reduce(min);
    final faixa = maior == menor ? 1.0 : maior - menor;

    final pontos = [
      for (var i = 0; i < valores.length; i++)
        Offset(
          size.width * i / (valores.length - 1),
          size.height - 6 - (valores[i] - menor) / faixa * (size.height - 12),
        ),
    ];

    final linha = Path()..moveTo(pontos.first.dx, pontos.first.dy);
    for (final p in pontos.skip(1)) {
      linha.lineTo(p.dx, p.dy);
    }
    final area = Path.from(linha)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(area, Paint()..color = AppColors.verdeClaro.withValues(alpha: 0.18));
    canvas.drawPath(
      linha,
      Paint()
        ..color = AppColors.verde
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    for (final p in pontos) {
      canvas.drawCircle(p, 3.5, Paint()..color = AppColors.verde);
    }
  }

  @override
  bool shouldRepaint(_PintorLinha old) => old.valores != valores;
}

class GraficoRosca extends StatelessWidget {
  final List<double> valores;
  final List<Color> cores;
  final double tamanho;

  const GraficoRosca({
    super.key,
    required this.valores,
    required this.cores,
    this.tamanho = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: tamanho,
      child: CustomPaint(painter: _PintorRosca(valores, cores)),
    );
  }
}

class _PintorRosca extends CustomPainter {
  final List<double> valores;
  final List<Color> cores;

  _PintorRosca(this.valores, this.cores);

  @override
  void paint(Canvas canvas, Size size) {
    final total = valores.fold<double>(0, (a, b) => a + b);
    if (total == 0) return;
    final espessura = size.width * 0.22;
    final area = (Offset.zero & size).deflate(espessura / 2);
    var inicio = -pi / 2;
    for (var i = 0; i < valores.length; i++) {
      final angulo = valores[i] / total * 2 * pi;
      canvas.drawArc(
        area,
        inicio,
        angulo - 0.03,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = espessura
          ..color = cores[i % cores.length],
      );
      inicio += angulo;
    }
  }

  @override
  bool shouldRepaint(_PintorRosca old) => old.valores != valores;
}

class Medidor extends StatelessWidget {
  final double valor;
  final String rotulo;
  final double tamanho;

  const Medidor({
    super.key,
    required this.valor,
    required this.rotulo,
    this.tamanho = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: tamanho,
      child: CustomPaint(
        painter: _PintorMedidor(valor),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(valor * 100).round()}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(rotulo, style: const TextStyle(fontSize: 11, color: AppColors.textoSuave)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PintorMedidor extends CustomPainter {
  final double valor;

  _PintorMedidor(this.valor);

  @override
  void paint(Canvas canvas, Size size) {
    final espessura = size.width * 0.11;
    final area = (Offset.zero & size).deflate(espessura / 2);
    const inicio = 0.75 * pi;
    const total = 1.5 * pi;
    final pincel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = espessura
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(area, inicio, total, false, pincel..color = AppColors.chip);
    canvas.drawArc(area, inicio, total * valor, false, pincel..color = AppColors.verde);
  }

  @override
  bool shouldRepaint(_PintorMedidor old) => old.valor != valor;
}

class AnelVagas extends StatelessWidget {
  final int livres;
  final int total;
  final bool destaque;

  const AnelVagas({
    super.key,
    required this.livres,
    required this.total,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 64,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: livres / total,
            strokeWidth: destaque ? 6 : 4,
            color: destaque ? AppColors.verde : AppColors.verdeClaro,
            backgroundColor: AppColors.chip,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$livres',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('vagas', style: TextStyle(fontSize: 10, color: AppColors.textoSuave)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
