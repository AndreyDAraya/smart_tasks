part of '../page.dart';

TutorialCoachMark _showAITutorial(
  GlobalKey<State<StatefulWidget>> aiButtonKey,
  SharedPreferences prefs,
  String tutorialShownKey,
) {
  var boxDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFE3F2FD),
        Color(0xFFE1F5FE),
        Colors.white,
      ],
      stops: [0.0, 0.3, 1.0],
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  var boxDecoration2 = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _kAccentColor.withOpacity(0.2),
        _kAccentColor.withOpacity(0.1),
      ],
    ),
    borderRadius: BorderRadius.circular(8),
  );

  return TutorialCoachMark(
    targets: [
      TargetFocus(
        identify: 'aiButton',
        keyTarget: aiButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                decoration: boxDecoration,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: boxDecoration2,
                          child: const Icon(
                            Icons.auto_awesome,
                            color: _kAccentColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'AI Task Assistant',
                          style: TextStyle(
                            color: _kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Let AI help you create better task descriptions:',
                      style: TextStyle(
                        color: _kPrimaryColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Write clear and concise title descriptions\n'
                      '• Enhance task details with relevant context\n'
                      '• Make tasks more actionable and easy to understand',
                      style: TextStyle(
                        color: Color(0xFF37474F),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ],
    colorShadow: Colors.black.withOpacity(0.8),
    hideSkip: true,
    alignSkip: Alignment.topRight,
    textSkip: "Skip Tutorial",
    paddingFocus: 10,
    opacityShadow: 0.8,
    onFinish: () {
      prefs.setBool(tutorialShownKey, true);
      return true;
    },
  );
}
