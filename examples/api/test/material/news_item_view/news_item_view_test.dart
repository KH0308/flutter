// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/material/news_item_view/news_item_view.1.dart';

void main() {
  testWidgets('FixedNewsItemView displays without unwanted spacing', (WidgetTester tester) async {
    // Create a fixed NewsItemView widget
    const Widget testWidget = MaterialApp(
      home: Scaffold(
        body: FixedNewsItemView(
          imageUrl: 'https://picsum.photos/300/200',
          title: 'Test Title',
          subtitle: 'Test Subtitle',
          boxFit: BoxFit.cover,
        ),
      ),
    );

    await tester.pumpWidget(testWidget);

    // Verify the widget tree structure
    expect(find.byType(FixedNewsItemView), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);

    // Verify that Image widget is using the correct BoxFit
    final Image imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.fit, BoxFit.cover);

    // Verify the Stack structure for proper image overlay
    expect(find.byType(Stack), findsOneWidget);
    
    // Verify BackdropFilter is present
    expect(find.byType(BackdropFilter), findsOneWidget);
    
    // Verify no Expanded widgets are used (which caused spacing issues)
    expect(find.byType(Expanded), findsNothing);
  });

  testWidgets('FixedNewsItemView respects custom BoxFit parameter', (WidgetTester tester) async {
    // Test with different BoxFit values
    const Widget testWidget = MaterialApp(
      home: Scaffold(
        body: FixedNewsItemView(
          imageUrl: 'https://picsum.photos/300/200',
          title: 'Test Title',
          subtitle: 'Test Subtitle',
          boxFit: BoxFit.fitWidth,
        ),
      ),
    );

    await tester.pumpWidget(testWidget);

    // Verify that Image widget uses the custom BoxFit
    final Image imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.fit, BoxFit.fitWidth);
  });

  testWidgets('FixedNewsItemView has proper structure without unnecessary nesting', (WidgetTester tester) async {
    const Widget testWidget = MaterialApp(
      home: Scaffold(
        body: FixedNewsItemView(
          imageUrl: 'https://picsum.photos/300/200',
          title: 'Test Title',
          subtitle: 'Test Subtitle',
          boxFit: BoxFit.cover,
        ),
      ),
    );

    await tester.pumpWidget(testWidget);

    // Check that the structure is simplified:
    // Card -> Column -> [SizedBox(Stack), Container]
    final Card card = tester.widget<Card>(find.byType(Card));
    expect(card.clipBehavior, Clip.antiAlias);

    // Verify SizedBox is used instead of complex flex structure
    expect(find.byType(SizedBox), findsWidgets);
    
    // Verify Stack has StackFit.expand for proper image filling
    final Stack stack = tester.widget<Stack>(find.byType(Stack));
    expect(stack.fit, StackFit.expand);
    
    // Verify BackdropFilter is positioned correctly
    expect(find.byType(Positioned), findsOneWidget);
  });
}