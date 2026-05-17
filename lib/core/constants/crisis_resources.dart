class CrisisResource {
  final String label;
  final String number;
  const CrisisResource({required this.label, required this.number});
}

const kCrisisResources = [
  CrisisResource(label: 'SAMU (Medical)', number: '15'),
  CrisisResource(label: 'Police', number: '17'),
  CrisisResource(label: 'Fire / Civil Protection', number: '14'),
  CrisisResource(label: 'Suicide Écoute (France)', number: '01 45 39 40 00'),
];
