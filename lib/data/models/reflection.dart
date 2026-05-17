class Reflection {
  final String id;
  final String userId;
  final String chatId;
  final String? arcId;
  final int? spiritId;
  final String? whatSageHeard;
  final String? questionToSitWith;
  final String? sharedPerspective;
  final String? momentOfClarity;
  final String? carryForward;
  final DateTime createdAt;

  const Reflection({
    required this.id,
    required this.userId,
    required this.chatId,
    this.arcId,
    this.spiritId,
    this.whatSageHeard,
    this.questionToSitWith,
    this.sharedPerspective,
    this.momentOfClarity,
    this.carryForward,
    required this.createdAt,
  });
}
