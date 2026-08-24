/// Iconic quotes from Solo Leveling (Sung Jin-Woo / the System).
class SoloLevelingQuotes {
  SoloLevelingQuotes._();

  static const List<String> quotes = [
    // Arise / Shadow Army
    "Arise.",
    "The Shadow Monarch does not kneel.",
    "My shadows are my army.",
    "I am the Shadow Monarch.",
    "The King of the Dead has returned.",
    "I will never let you die again.",
    "All shadows, hear my voice. Arise!",
    "I'll protect them all with my own hands.",
    "My soldiers, arise and fight.",
    "The shadows bow to no one but me.",

    // System / Leveling
    "You have acquired a new level.",
    "A new quest has been added to the System.",
    "The System has recognized your growth.",
    "Your strength is beyond the System's expectations.",
    "The System rewards those who persevere.",
    "Level up. The path of the monarch awaits.",
    "The gate to the next level has opened.",
    "Your power is growing exponentially.",
    "The System is merely a tool. The real power is yours.",
    "You have unlocked a new ability.",

    // Determination / Growth
    "I don't want to be weak anymore.",
    "The weak exist to be trampled by the strong.",
    "I'll become stronger. For them.",
    "I'm not the same person I was yesterday.",
    "Pain is temporary. Growth is forever.",
    "The hunt continues. There is no rest for the hunter.",
    "I will protect what matters, no matter the cost.",
    "Every battle makes me stronger.",
    "I must become stronger. There is no other choice.",
    "The weak die, and the strong live. That is the rule of the hunter.",
    "I will never go back to being weak.",
    "The only way is forward.",
    "I'm doing this for the ones I care about.",
    "Strength is not just physical. It's the will to protect.",
    "I will rise, no matter how many times I fall.",

    // Hunter / Rank
    "An S-Rank hunter never backs down.",
    "The higher the rank, the greater the responsibility.",
    "Rank is just a number. Willpower is what matters.",
    "Even an E-Rank can become a Monarch.",
    "The strongest hunters are born from the deepest struggles.",
    "Your rank does not define your potential.",
    "I've climbed from the lowest rank to the highest.",
    "The true measure of a hunter is not their rank, but their heart.",
    "Every hunter walks their own path.",
    "The guild is nothing without its members.",

    // Reflection / Wisdom
    "In the end, we are all just hunters searching for meaning.",
    "The gates never stop appearing. Neither do I.",
    "The world is not fair. That's why I'll make it fair.",
    "Power without purpose is meaningless.",
    "The real battle is the one within.",
    "Sometimes the greatest enemy is your own doubt.",
    "I've learned that strength comes from the bonds we share.",
    "The night is darkest before the dawn.",
    "Even a hunter needs to rest.",
    "The journey of a thousand gates begins with a single step.",
    "A true hunter does not fear the dark. They become it.",
    "The shadows are my allies, not my enemies.",
    "I fight not for glory, but for those who cannot fight.",
    "The strongest weapon is an unbreakable will.",
    "Every gate is a new beginning.",

    // Iconic / Signature Lines
    "I alone level up.",
    "It's been a while since I've felt this way.",
    "I'm not a hunter anymore. I'm the one who hunts hunters.",
    "You dare to stand before the Shadow Monarch?",
    "My name is Sung Jin-Woo. I am the Shadow Monarch.",
    "This is the power of the Shadow Monarch.",
    "I've been waiting for this moment.",
    "The System is my greatest ally.",
    "I will not bow to anyone.",
    "Death is not the end. It's just the beginning.",
    "I'll show you what a true monarch is.",
    "The weak will always be preyed upon by the strong.",
    "I have no need for a guild. I am my own guild.",
    "The System has chosen me.",
    "I'll protect them, even if it costs me everything.",
    "A monarch does not ask. A monarch commands.",
    "I've walked through hell and come back stronger.",
    "The shadows obey my every command.",
    "I am not the same man who was once called the weakest hunter.",
    "Let the hunt begin.",
  ];

  /// Returns a random quote from the list.
  static String get random {
    final copy = List<String>.of(quotes)..shuffle();
    return copy.first;
  }
}