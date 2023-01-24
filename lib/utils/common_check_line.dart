// import 'dart:math';

// import 'package:flutter/material.dart';

// import 'package:timelines/timelines.dart';

// const kTileHeight = 50.0;

// const completeColor = Color(0xff6A6E83);
// const inProgressColor = Color(0xff004AAd);
// const todoColor = Color(0xffd1d2d7);

// Color getColor(int index, index1) {
//   if (index == index1) {
//     return completeColor;
//   } else if (index < index1) {
//     return inProgressColor;
//   } else {
//     return todoColor;
//   }
// }

// Widget getCheckedLine(int currentIndex, BuildContext context, int length) {
//   return Timeline.tileBuilder(
//     padding: EdgeInsets.zero,
//     physics: const NeverScrollableScrollPhysics(),
//     theme: TimelineThemeData(
//       direction: Axis.horizontal,
//       connectorTheme: const ConnectorThemeData(
//         space: 16.0,
//         thickness: 2.0,
//       ),
//     ),
//     builder: TimelineTileBuilder.connected(
//       connectionDirection: ConnectionDirection.before,
//       itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / length,
//       indicatorBuilder: (_, index) {
//         Color color;
//         // ignore: prefer_typing_uninitialized_variables
//         var child;
//         if (index == currentIndex) {
//           color = Colors.white;
//           child = Stack(
//             children: [
//               CustomPaint(
//                 painter: _BezierPainter(
//                   color: Colors.white,
//                   drawStart: index > 0,
//                   drawEnd: index < length - 1,
//                 ),
//               ),
//               const OutlinedDotIndicator(
//                 size: 24,
//                 borderWidth: 2.0,
//                 color: inProgressColor,
//               ),
//             ],
//           );
//         } else if (index < currentIndex) {
//           color = inProgressColor;
//           child = const Icon(
//             Icons.check,
//             color: Colors.white,
//             size: 15.0,
//           );
//         } else {
//           color = todoColor;
//         }

//         if (index <= currentIndex) {
//           return Stack(
//             children: [
//               CustomPaint(
//                 painter: _BezierPainter(
//                   color: color,
//                   drawStart: index > 0,
//                   drawEnd: index < currentIndex,
//                 ),
//               ),
//               DotIndicator(
//                 size: 24.0,
//                 color: color,
//                 child: child,
//               ),
//             ],
//           );
//         } else {
//           return Stack(
//             children: [
//               CustomPaint(
//                 painter: _BezierPainter(
//                   color: color,
//                   drawStart: index > 0,
//                   drawEnd: index < length - 1,
//                 ),
//               ),
//               OutlinedDotIndicator(
//                 size: 24,
//                 borderWidth: 2.0,
//                 color: color,
//               ),
//             ],
//           );
//         }
//       },
//       connectorBuilder: (_, index, type) {
//         if (index > 0) {
//           if (index == currentIndex) {
//             final prevColor = getColor(index - 1, currentIndex);
//             // ignore: unused_local_variable
//             final color = getColor(index, currentIndex);
//             List<Color> gradientColors;
//             gradientColors = [
//               prevColor,
//               Color.lerp(prevColor, prevColor, 0.5)!
//             ];
//             return DecoratedLineConnector(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: gradientColors,
//                 ),
//               ),
//             );
//           } else {
//             ///PENDING STEPS
//             return SolidLineConnector(
//               color: getColor(index, currentIndex),
//             );
//           }
//         } else {
//           return null;
//         }
//       },
//       itemCount: length,
//     ),
//   );
// }

// /// hardcoded bezier painter
// class _BezierPainter extends CustomPainter {
//   const _BezierPainter({
//     required this.color,
//     this.drawStart = true,
//     this.drawEnd = true,
//   });

//   final Color color;
//   final bool drawStart;
//   final bool drawEnd;

//   Offset _offset(double radius, double angle) {
//     return Offset(
//       radius * cos(angle) + radius,
//       radius * sin(angle) + radius,
//     );
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = color;

//     final radius = size.width / 2;

//     double angle;
//     Offset offset1;
//     Offset offset2;

//     Path path;

//     if (drawStart) {
//       angle = 3 * pi / 4;
//       offset1 = _offset(radius, angle);
//       offset2 = _offset(radius, -angle);
//       path = Path()
//         ..moveTo(offset1.dx, offset1.dy)
//         ..quadraticBezierTo(
//             0.0,
//             size.height / 2,
//             -radius,
//             // ignore: todo
//             radius) // TODO connector start & gradient
//         ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
//         ..close();

//       canvas.drawPath(path, paint);
//     }
//     if (drawEnd) {
//       angle = -pi / 4;
//       offset1 = _offset(radius, angle);
//       offset2 = _offset(radius, -angle);

//       path = Path()
//         ..moveTo(offset1.dx, offset1.dy)
//         ..quadraticBezierTo(
//             size.width,
//             size.height / 2,
//             size.width + radius,
//             // ignore: todo
//             radius) // TODO connector end & gradient
//         ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
//         ..close();

//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(_BezierPainter oldDelegate) {
//     return oldDelegate.color != color ||
//         oldDelegate.drawStart != drawStart ||
//         oldDelegate.drawEnd != drawEnd;
//   }
// }
