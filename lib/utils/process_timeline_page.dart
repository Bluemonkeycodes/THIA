// import 'dart:math';

// import 'package:flutter/material.dart';

// const kTileHeight = 50.0;

// const completeColor = Color(0xff6A6E83);
// const inProgressColor = Color(0xff004AAd);
// const todoColor = Color(0xffd1d2d7);

// class ProcessTimelinePage extends StatefulWidget {
//   const ProcessTimelinePage({Key? key}) : super(key: key);

//   @override
//   _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
// }

// class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
//   int _processIndex = 0;

//   Color getColor(int index) {
//     if (index == _processIndex) {
//       return completeColor;
//     } else if (index < _processIndex) {
//       return inProgressColor;
//     } else {
//       return todoColor;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           title: const Text(
//         'Process TimeLine',
//         style: TextStyle(color: Colors.white),
//       )),
//       body: Timeline.tileBuilder(
//         theme: TimelineThemeData(
//           direction: Axis.horizontal,
//           connectorTheme: const ConnectorThemeData(
//             space: 30.0,
//             thickness: 5.0,
//           ),
//         ),
//         builder: TimelineTileBuilder.connected(
//           connectionDirection: ConnectionDirection.before,
//           itemExtentBuilder: (_, __) =>
//               MediaQuery.of(context).size.width / _processes.length,
//           indicatorBuilder: (_, index) {
//             Color color;
//             // ignore: prefer_typing_uninitialized_variables
//             var child;
//             if (index == _processIndex) {
//               color = Colors.white;
//               child = Stack(
//                 children: [
//                   CustomPaint(
//                     painter: _BezierPainter(
//                       color: Colors.white,
//                       drawStart: index > 0,
//                       drawEnd: index < _processes.length - 1,
//                     ),
//                   ),
//                   const OutlinedDotIndicator(
//                     size: 30,
//                     borderWidth: 2.0,
//                     color: inProgressColor,
//                   ),
//                 ],
//               );
//             } else if (index < _processIndex) {
//               color = inProgressColor;
//               child = const Icon(
//                 Icons.check,
//                 color: Colors.white,
//                 size: 15.0,
//               );
//             } else {
//               color = todoColor;
//             }

//             if (index <= _processIndex) {
//               return Stack(
//                 children: [
//                   CustomPaint(
//                     painter: _BezierPainter(
//                       color: color,
//                       drawStart: index > 0,
//                       drawEnd: index < _processIndex,
//                     ),
//                   ),
//                   DotIndicator(
//                     size: 30.0,
//                     color: color,
//                     child: child,
//                   ),
//                 ],
//               );
//             } else {
//               return Stack(
//                 children: [
//                   CustomPaint(
//                     painter: _BezierPainter(
//                       color: color,
//                       drawStart: index > 0,
//                       drawEnd: index < _processes.length - 1,
//                     ),
//                   ),
//                   OutlinedDotIndicator(
//                     size: 30,
//                     borderWidth: 2.0,
//                     color: color,
//                   ),
//                 ],
//               );
//             }
//           },
//           connectorBuilder: (_, index, type) {
//             if (index > 0) {
//               if (index == _processIndex) {
//                 final prevColor = getColor(index - 1);
//                 // ignore: unused_local_variable
//                 final color = getColor(index);
//                 List<Color> gradientColors;
//                 gradientColors = [
//                   prevColor,
//                   Color.lerp(prevColor, prevColor, 0.5)!
//                 ];
//                 return DecoratedLineConnector(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: gradientColors,
//                     ),
//                   ),
//                 );
//               } else {
//                 ///PENDING STEPS
//                 return SolidLineConnector(
//                   color: getColor(index),
//                 );
//               }
//             } else {
//               return null;
//             }
//           },
//           itemCount: _processes.length,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.done),
//         onPressed: () {
//           setState(() {
//             _processIndex = (_processIndex + 1) % _processes.length;
//           });
//         },
//         backgroundColor: inProgressColor,
//       ),
//     );
//   }
// }

// /// hardcoded bezier painter
// // ignore: todo
// /// TODO: Bezier curve into package component
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

// final _processes = [
//   '1',
//   '2',
//   '3',
//   '4',
//   '5',
// ];
