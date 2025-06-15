import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nawa_app/core/ui/ui_improvements.dart';
import 'package:nawa_app/core/constants/constants.dart';

void main() {
  group('UIImprovements', () {
    group('Color Utilities', () {
      test('getColorWithAlpha returns color with correct alpha', () {
        const color = Colors.blue;
        const alpha = 0.5;
        
        final result = UIImprovements.getColorWithAlpha(color, alpha);
        
        expect(result.alpha, equals((255 * alpha).round()));
        expect(result.red, equals(color.red));
        expect(result.green, equals(color.green));
        expect(result.blue, equals(color.blue));
      });

      test('getColorWithAlpha clamps alpha values', () {
        const color = Colors.red;
        
        // Test alpha > 1.0
        final result1 = UIImprovements.getColorWithAlpha(color, 1.5);
        expect(result1.alpha, equals(255));
        
        // Test alpha < 0.0
        final result2 = UIImprovements.getColorWithAlpha(color, -0.5);
        expect(result2.alpha, equals(0));
      });

      test('getShadowColor returns color with correct opacity', () {
        const color = Colors.green;
        const opacity = 0.2;
        
        final result = UIImprovements.getShadowColor(color, opacity: opacity);
        
        expect(result.alpha, equals((255 * opacity).round()));
      });

      test('getBorderColor returns color with default opacity', () {
        const color = Colors.purple;
        
        final result = UIImprovements.getBorderColor(color);
        
        expect(result.alpha, equals((255 * 0.2).round()));
      });
    });

    group('Widget Builders', () {
      testWidgets('buildEnhancedContainer creates container with correct properties', (tester) async {
        const testChild = Text('Test Child');
        const backgroundColor = Colors.white;
        const borderRadius = 16.0;
        
        final container = UIImprovements.buildEnhancedContainer(
          child: testChild,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: container)));
        
        expect(find.text('Test Child'), findsOneWidget);
        
        final containerWidget = tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        
        expect(decoration.color, equals(backgroundColor));
        expect(decoration.borderRadius, equals(BorderRadius.circular(borderRadius)));
      });

      testWidgets('buildEnhancedCard creates tappable card', (tester) async {
        bool tapped = false;
        const testChild = Text('Test Card');
        
        final card = UIImprovements.buildEnhancedCard(
          child: testChild,
          onTap: () => tapped = true,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: card)));
        
        expect(find.text('Test Card'), findsOneWidget);
        expect(find.byType(InkWell), findsOneWidget);
        
        await tester.tap(find.byType(InkWell));
        expect(tapped, isTrue);
      });

      testWidgets('buildEnhancedButton creates button with text and icon', (tester) async {
        bool pressed = false;
        const buttonText = 'Test Button';
        const buttonIcon = Icons.add;
        
        final button = UIImprovements.buildEnhancedButton(
          text: buttonText,
          icon: buttonIcon,
          onPressed: () => pressed = true,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));
        
        expect(find.text(buttonText), findsOneWidget);
        expect(find.byIcon(buttonIcon), findsOneWidget);
        
        await tester.tap(find.byType(ElevatedButton));
        expect(pressed, isTrue);
      });

      testWidgets('buildEnhancedButton shows loading indicator when isLoading is true', (tester) async {
        final button = UIImprovements.buildEnhancedButton(
          text: 'Loading Button',
          onPressed: () {},
          isLoading: true,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));
        
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading Button'), findsOneWidget);
      });

      testWidgets('buildEnhancedButton creates outlined button when isOutlined is true', (tester) async {
        final button = UIImprovements.buildEnhancedButton(
          text: 'Outlined Button',
          onPressed: () {},
          isOutlined: true,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));
        
        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.text('Outlined Button'), findsOneWidget);
      });
    });

    group('Text Widgets', () {
      testWidgets('buildEnhancedTitle creates title with icon', (tester) async {
        const titleText = 'Test Title';
        const titleIcon = Icons.star;
        
        final title = UIImprovements.buildEnhancedTitle(
          text: titleText,
          icon: titleIcon,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: title)));
        
        expect(find.text(titleText), findsOneWidget);
        expect(find.byIcon(titleIcon), findsOneWidget);
      });

      testWidgets('buildEnhancedSubtitle creates subtitle with correct style', (tester) async {
        const subtitleText = 'Test Subtitle';
        
        final subtitle = UIImprovements.buildEnhancedSubtitle(
          text: subtitleText,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: subtitle)));
        
        expect(find.text(subtitleText), findsOneWidget);
        
        final textWidget = tester.widget<Text>(find.text(subtitleText));
        expect(textWidget.style?.color, equals(AppColors.textSecondary));
      });
    });

    group('Layout Widgets', () {
      testWidgets('buildEnhancedDivider creates divider with correct height', (tester) async {
        const dividerHeight = 2.0;
        
        final divider = UIImprovements.buildEnhancedDivider(
          height: dividerHeight,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: divider)));
        
        final containerWidget = tester.widget<Container>(find.byType(Container));
        expect(containerWidget.constraints?.maxHeight, equals(dividerHeight));
      });

      testWidgets('buildEnhancedSpacer creates sized box with correct dimensions', (tester) async {
        const spacerWidth = 20.0;
        const spacerHeight = 30.0;
        
        final spacer = UIImprovements.buildEnhancedSpacer(
          width: spacerWidth,
          height: spacerHeight,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: spacer)));
        
        final sizedBoxWidget = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxWidget.width, equals(spacerWidth));
        expect(sizedBoxWidget.height, equals(spacerHeight));
      });
    });

    group('State Widgets', () {
      testWidgets('buildEnhancedEmptyState creates empty state with action button', (tester) async {
        bool actionPressed = false;
        const emptyIcon = Icons.inbox;
        const emptyTitle = 'No Data';
        const emptyMessage = 'No data available';
        const actionText = 'Retry';
        
        final emptyState = UIImprovements.buildEnhancedEmptyState(
          icon: emptyIcon,
          title: emptyTitle,
          message: emptyMessage,
          actionText: actionText,
          onAction: () => actionPressed = true,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: emptyState)));
        
        expect(find.byIcon(emptyIcon), findsOneWidget);
        expect(find.text(emptyTitle), findsOneWidget);
        expect(find.text(emptyMessage), findsOneWidget);
        expect(find.text(actionText), findsOneWidget);
        
        await tester.tap(find.text(actionText));
        expect(actionPressed, isTrue);
      });

      testWidgets('buildEnhancedLoadingIndicator creates loading indicator with message', (tester) async {
        const loadingMessage = 'Loading data...';
        
        final loadingIndicator = UIImprovements.buildEnhancedLoadingIndicator(
          message: loadingMessage,
        );
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: loadingIndicator)));
        
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text(loadingMessage), findsOneWidget);
      });

      testWidgets('buildEnhancedLoadingIndicator creates loading indicator without message', (tester) async {
        final loadingIndicator = UIImprovements.buildEnhancedLoadingIndicator();
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: loadingIndicator)));
        
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(Text), findsNothing);
      });
    });
  });
}
