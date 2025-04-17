/*
* File : Animated Carousel
* Version : 1.0.0
* */

import 'dart:async';

import 'package:seller/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../../images.dart';

class AnimatedCarouselWidget extends StatefulWidget {
  String bodyContent;
  List<Widget> tileUI;
  double height;
  AnimatedCarouselWidget(this.bodyContent, this.tileUI, {this.height = 150});

  @override
  _AnimatedCarouselWidgetState createState() => _AnimatedCarouselWidgetState();
}

class _AnimatedCarouselWidgetState extends State<AnimatedCarouselWidget>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late ThemeData theme;

  int numPages = 0;

  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer timerAnimation;

  List<Widget> _buildPageIndicatorAnimated() {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary.withAlpha(220) : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.shoppingTheme;

    numPages = widget.tileUI.length;

    timerAnimation = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < numPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    timerAnimation.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: theme.colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      color:
                          AppTheme.shoppingTheme.colorScheme.primaryContainer,
                      height: widget.height,
                      child: PageView(
                        pageSnapping: true,
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: widget.tileUI,
                      ),
                    ),


                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicatorAnimated(),
                      ),
                    ),
                  ],
                ),
                (widget.bodyContent.isNotEmpty)
                    ? Expanded(
                        child: Center(
                          child: FxText.titleMedium("Body content",
                              color: theme.colorScheme.onBackground,
                              letterSpacing: 0.3),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            )));
  }
}
