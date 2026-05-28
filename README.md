# MedicationTracker

Aplicativo mobile desenvolvido em **Flutter** para ajudar pacientes a controlarem seus medicamentos e permitir que cuidadores acompanhem o tratamento.

## Funcionalidades principais

- Lembretes de medicação com confirmação (acções "Tomei" / "Não tomei")
- Histórico de doses tomadas, perdidas e em atraso
- Gestão de medicamentos com dosagem, frequência e horários
- Vinculação local de cuidadores
- Múltiplos utilizadores no mesmo dispositivo

## Tecnologias

- Flutter + Dart
- **SQLite local** (`sqflite`) — toda a persistência fica no dispositivo
- Provider (gestão de estado)
- `flutter_local_notifications` + `timezone` (lembretes locais)
- `crypto` (hash SHA-256 das passwords)

## Estrutura da base de dados

A base de dados local é criada em `medication_tracker.db` no directório de documentos da aplicação. Contém quatro tabelas:

- `users` — utilizadores e respectivos perfis (password com SHA-256)
- `medications` — medicamentos por utilizador
- `reminders` — lembretes/confirmações de ingestão (com notas opcionais)
- `caregivers` — cuidadores associados a cada paciente

## Como rodar

```bash
flutter pub get
flutter run
```

## Plataformas

- Android
