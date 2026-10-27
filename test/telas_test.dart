import 'package:app_pet/data/atividades.dart';
import 'package:app_pet/models/operacao.dart';
import 'package:app_pet/screens/equipe/equipe_shell.dart';
import 'package:app_pet/screens/proprietario/concluidos_screen.dart';
import 'package:app_pet/screens/equipe/cuidados_screen.dart';
import 'package:app_pet/screens/equipe/publicar_fotos_screen.dart';
import 'package:app_pet/screens/perfil_screen.dart';
import 'package:app_pet/screens/proprietario/despesas_screen.dart';
import 'package:app_pet/screens/proprietario/equipe_permissoes_screen.dart';
import 'package:app_pet/screens/proprietario/ia_whatsapp_screen.dart';
import 'package:app_pet/screens/proprietario/proprietario_shell.dart';
import 'package:app_pet/screens/proprietario/servicos_regras_screen.dart';
import 'package:app_pet/screens/tutor/banho_tosa_screen.dart';
import 'package:app_pet/screens/tutor/cobrancas_screen.dart';
import 'package:app_pet/screens/tutor/fotos_screen.dart';
import 'package:app_pet/screens/tutor/taxi_dog_screen.dart';
import 'package:app_pet/screens/tutor/tutor_shell.dart';
import 'package:app_pet/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Renderiza cada tela no tamanho de um celular e falha se houver erro de layout.
void main() {
  final telas = <String, Widget>{
    'Perfil': const PerfilScreen(),
    'Fotos': const FotosScreen(),
    'Táxi Dog': const TaxiDogScreen(),
    'Banho e tosa': const BanhoTosaScreen(),
    'Cobranças': const CobrancasScreen(),
    'Cuidados': const CuidadosScreen(pet: 'Thor', raca: 'Golden Retriever', servico: 'Hotel'),
    'Publicar fotos': const PublicarFotosScreen(),
    'Despesas': const DespesasScreen(),
    'Equipe e permissões': const EquipePermissoesScreen(),
    'Serviços e regras': const ServicosRegrasScreen(),
    'IA no WhatsApp': const IaWhatsappScreen(),
  };

  final shells = <String, Widget>{
    'Tutor': const TutorShell(),
    'Equipe': const EquipeShell(),
    'Proprietário': const ProprietarioShell(),
  };

  Future<void> abrir(WidgetTester tester, Widget tela) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(theme: AppTheme.tema, home: tela));
    await tester.pump(const Duration(milliseconds: 300));
  }

  telas.forEach((nome, tela) {
    testWidgets('Tela $nome', (tester) async {
      await abrir(tester, tela);
    });
  });

  shells.forEach((nome, shell) {
    testWidgets('Abas do $nome', (tester) async {
      await abrir(tester, shell);
      for (var i = 0; find.byKey(Key('aba_$i')).evaluate().isNotEmpty; i++) {
        await tester.tap(find.byKey(Key('aba_$i')));
        await tester.pump(const Duration(milliseconds: 300));
      }
    });
  });

  testWidgets('Finalização da equipe aparece em Concluídos', (tester) async {
    Atividades.instancia.registrar(
      tipo: TipoAtividade.banho,
      pet: 'Bella',
      titulo: 'Teste de finalização',
    );
    await abrir(tester, const ConcluidosScreen());
    expect(find.text('Bella • Teste de finalização'), findsOneWidget);
  });
}
