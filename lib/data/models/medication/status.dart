enum MedicationStatus { pendente, activo, inactivo }

extension MedicationStatusExtension on MedicationStatus {
  String get label {
    switch (this) {
      case MedicationStatus.pendente:
        return 'Pendente';
      case MedicationStatus.activo:
        return 'Ativo';
      case MedicationStatus.inactivo:
        return 'Inativo';
    }
  }
}
