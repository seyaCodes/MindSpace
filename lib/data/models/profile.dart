class Profile {
  final String id;
  final String? displayName;
  final String? statusIntention;
  final bool onboardingCompleted;

  const Profile({
    required this.id,
    this.displayName,
    this.statusIntention,
    this.onboardingCompleted = false,
  });
}
