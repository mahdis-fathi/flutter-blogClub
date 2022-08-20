import 'package:blogclub/auth.dart';
import 'package:blogclub/data.dart';
import 'package:blogclub/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardinsScreen extends StatefulWidget {
  const OnBoardinsScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardinsScreen> createState() => _OnBoardinsScreenState();
}

class _OnBoardinsScreenState extends State<OnBoardinsScreen> {
  final PageController _controller = PageController();
  final items = AppDatabase.OnBoardingItems;
  int page = 0;
  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.page!.round() != page) {
        page = _controller.page!.round();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 8),
                child: Assets.img.background.onboarding.image(),
              ),
            ),
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: themeData.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                        itemCount: items.length,
                        controller: _controller,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].title,
                                  style: themeData.textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  items[index].description,
                                  style: themeData.textTheme.subtitle1!
                                      .apply(fontSizeFactor: 0.9),
                                ),
                              ],
                            ),
                          );
                        })),
                  ),
                  Container(
                    height: 60,
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothPageIndicator(
                          controller: _controller,
                          count: items.length,
                          effect: ExpandingDotsEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              activeDotColor: themeData.colorScheme.primary,
                              dotColor: themeData.colorScheme.primary
                                  .withOpacity(0.1)),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (page == items.length - 1) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthScreen()));
                              } else {
                                _controller.animateToPage(page+1, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
                              }
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(84, 60)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)))),
                            child: Icon(page == items.length - 1
                                ? CupertinoIcons.check_mark
                                : CupertinoIcons.arrow_right))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
