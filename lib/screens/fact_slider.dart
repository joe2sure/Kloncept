import 'package:kloncept/model/dummy/dummy_model.dart';
import 'package:kloncept/provider/dummy/dummy_provider.dart';

import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class FactSlider extends StatefulWidget {
  final bool visible;
  const FactSlider(this.visible, {Key? key}) : super(key: key);

  @override
  State<FactSlider> createState() => _FactSliderState();
}

class _FactSliderState extends State<FactSlider> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;
  bool _isDisposed = false;
  List<DummyFactSlider>? _factList;
  bool _isAnimationInitialized = false;

  @override
  void initState() {
    super.initState();
    // Defer provider access to didChangeDependencies
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFactList();
  }

// Update the _initializeFactList method
void _initializeFactList() {
  try {
    final provider = Provider.of<DummyHomeDataProvider>(context, listen: false);
    if (!provider.dataLoaded) {
      provider.loadDummyHomeData().then((_) {
        if (mounted) {
          setState(() {
            _factList = provider.sliderFactList;
          });
        }
      });
    } else {
      _factList = provider.sliderFactList;
    }
    
    if ((_factList?.isNotEmpty ?? false) && !_isAnimationInitialized) {
      _isAnimationInitialized = true;
      _animationController.addStatusListener(_handleAnimationStatus);
      _startAnimationCycle();
    }
  } catch (e) {
    print("Error initializing fact list: $e");
    _factList = [];
  }
}

  // void _initializeFactList() {
  //   try {
  //     final provider = Provider.of<DummyHomeDataProvider>(context, listen: false);
  //     _factList = provider.sliderFactList;
      
  //     // Only initialize animation if we have facts and it's not already initialized
  //     if ((_factList?.isNotEmpty ?? false) && !_isAnimationInitialized) {
  //       _isAnimationInitialized = true;
  //       _animationController.addStatusListener(_handleAnimationStatus);
  //       _startAnimationCycle();
  //     }
  //   } catch (e) {
  //     print("Error initializing fact list: $e");
  //     _factList = [];
  //   }
  // }

  void _handleAnimationStatus(AnimationStatus status) {
    if (_isDisposed || !mounted) return;

    if (status == AnimationStatus.completed) {
      Timer(const Duration(seconds: 3), () {
        if (!_isDisposed && mounted) {
          _animationController.reverse();
        }
      });
    } else if (status == AnimationStatus.dismissed) {
      _updateFactIndex();
      Timer(const Duration(milliseconds: 300), () {
        if (!_isDisposed && mounted) {
          _animationController.forward();
        }
      });
    }
  }

  void _updateFactIndex() {
    // Safety check to prevent index out of range errors
    if (_factList == null || _factList!.isEmpty) return;
    
    setState(() {
      _currentIndex = (_currentIndex + 1) % _factList!.length;
    });
  }

  void _startAnimationCycle() {
    if (_factList != null && _factList!.isNotEmpty && mounted) {
      _animationController.forward();
    }
  }

  Widget _buildShimmerLoader() {
    return SliverToBoxAdapter(
      child: Container(
        height: _getContainerHeight(),
        margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFd3d7de),
          highlightColor: const Color(0xFFe2e4e9),
          child: Card(
            elevation: 0.0,
            color: const Color.fromRGBO(45, 45, 45, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
        ),
      ),
    );
  }

  Widget _buildFactSlide(DummyFactSlider fact) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.laptop, size: 55, color: Colors.white),
            SizedBox(width: _currentIndex == 0 ? 10 : 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fact.title ?? 'Fact Title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fact.description ?? 'Fact description goes here',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactContainer() {
    // Safety check to prevent index out of range errors
    if (_factList == null || _factList!.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: _getContainerHeight(),
          margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: const Center(
            child: Text("No facts available"),
          ),
        ),
      );
    }

    // Ensure current index is within bounds
    if (_currentIndex >= _factList!.length) {
      _currentIndex = 0;
    }

    final currentFact = _factList![_currentIndex];

    return SliverToBoxAdapter(
      child: Container(
        height: _getContainerHeight(),
        margin: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6E1A52), Color(0xFFF44A4A)],
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1c2464).withOpacity(0.30),
              blurRadius: 15.0,
              offset: const Offset(0.0, 20.5),
              spreadRadius: -15.0,
            ),
          ],
        ),
        child: _buildFactSlide(currentFact),
      ),
    );
  }

  double _getContainerHeight() {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? 120
        : MediaQuery.of(context).size.height / 9;
  }

  @override
  Widget build(BuildContext context) {
    // Re-initialize fact list on rebuild to catch any updates
    if (!_isDisposed && mounted) {
      _initializeFactList();
    }
    
    return widget.visible ? _buildFactContainer() : _buildShimmerLoader();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.removeStatusListener(_handleAnimationStatus);
    _animationController.dispose();
    super.dispose();
  }
}





// import '../provider/home_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:async';
// import 'package:shimmer/shimmer.dart';

// // ignore: must_be_immutable
// class FactSlider extends StatefulWidget {
//   bool _visible;
//   FactSlider(this._visible);
//   @override
//   _FactSliderState createState() => _FactSliderState();
// }

// class _FactSliderState extends State<FactSlider> with TickerProviderStateMixin {
//   AnimationController? animation;
//   Animation<double>? _fadeInFadeOut;
//   int index = 0;
//   int? factsLen;
//   bool _disposed = false;

//   @override
//   void initState() {
//     super.initState();
//     final sliderFacts = Provider.of<HomeDataProvider>(context, listen: false);
//     factsLen = sliderFacts.sliderFactList!.length - 1;
//     animation = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0)
//         .animate(animation as Animation<double>);

//     animation!.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         Timer(Duration(seconds: 4), () {
//           if (!_disposed) {
//             animation!.reverse();
//           }
//         });
//       } else if (status == AnimationStatus.dismissed) {
//         setState(() {
//           if (index < factsLen!) {
//             index = index + 1;
//           } else {
//             index = 0;
//           }
//         });
//         Timer(Duration(milliseconds: 600), () {
//           if (!_disposed) {
//             animation!.forward();
//           }
//         });
//       }
//     });
//     animation!.forward();
//   }

//   Widget showShimmer() {
//     return SliverToBoxAdapter(
//       child: Container(
//         height: MediaQuery.of(context).orientation == Orientation.landscape
//             ? 120
//             : MediaQuery.of(context).size.height / 9,
//         margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
//         child: Shimmer.fromColors(
//           baseColor: Color(0xFFd3d7de),
//           highlightColor: Color(0xFFe2e4e9),
//           child: Card(
//             elevation: 0.0,
//             color: Color.fromRGBO(45, 45, 45, 1.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10),
//               ),
//             ),
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget animationContainer(HomeDataProvider sliderFactsProvider) {
//     return SliverToBoxAdapter(
//       child: Container(
//         height: MediaQuery.of(context).orientation == Orientation.landscape
//             ? 120
//             : MediaQuery.of(context).size.height / 9,
//         margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF6E1A52),
//                 Color(0xFFF44A4A),
//               ]),
//           borderRadius: BorderRadius.circular(15.0),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x1c2464).withOpacity(0.30),
//               blurRadius: 15.0,
//               offset: Offset(0.0, 20.5),
//               spreadRadius: -15.0,
//             ),
//           ],
//         ),
//         child: FadeTransition(
//           opacity: _fadeInFadeOut as Animation<double>,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.laptop,
//                   size: 55,
//                   color: Colors.white,
//                 ),
//                 SizedBox(
//                   width: index == 0 ? 10 : 20,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                      Text(
//                             "${sliderFactsProvider.sliderFactList![index].heading}",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold),
//                           ),

//                       ],
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "${sliderFactsProvider.sliderFactList![index].subHeading}",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.7),
//                             fontSize: 14.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var sliderFactsProvider = Provider.of<HomeDataProvider>(context);
//     return widget._visible
//         ? animationContainer(sliderFactsProvider)
//         : showShimmer();
//   }

//   @override
//   void dispose() {
//     _disposed = true;
//     animation?.dispose();
//     super.dispose();
//   }
// }
