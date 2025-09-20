// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/material.dart';

/// Flutter code sample for NewsItemView widget demonstrating spacing issues.

void main() => runApp(const NewsItemViewApp());

class NewsItemViewApp extends StatelessWidget {
  const NewsItemViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsItemView Sample',
      theme: ThemeData(useMaterial3: true),
      home: const NewsItemViewExample(),
    );
  }
}

class NewsItemViewExample extends StatelessWidget {
  const NewsItemViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NewsItemView Sample')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text('Current NewsItemView with spacing issues:'),
          const SizedBox(height: 16),
          NewsItemView(
            imageUrl: 'https://picsum.photos/300/200',
            title: 'Breaking News: Flutter Advances',
            subtitle: 'The latest developments in Flutter framework',
            boxFit: BoxFit.cover,
          ),
          const SizedBox(height: 32),
          const Text('Fixed NewsItemView without spacing issues:'),
          const SizedBox(height: 16),
          FixedNewsItemView(
            imageUrl: 'https://picsum.photos/300/200?random=1',
            title: 'Breaking News: Flutter Advances',
            subtitle: 'The latest developments in Flutter framework',
            boxFit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

/// NewsItemView widget with the current spacing issues
/// This demonstrates the problems mentioned in the issue:
/// 1. Unnecessary nested container structure
/// 2. Expanded widget with flex:3 creating vertical spacing
/// 3. Padding within image container
/// 4. BackdropFilter not properly overlaying entire image area
/// 5. Image not filling container properly
class NewsItemView extends StatelessWidget {
  const NewsItemView({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.boxFit = BoxFit.cover,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // This structure demonstrates the issues:
          // Unnecessary nesting and spacing problems
          Container(
            height: 200,
            child: Column(
              children: <Widget>[
                // Issue 1: Unnecessary Expanded with flex:3 creates spacing
                Expanded(
                  flex: 3,
                  child: Container(
                    // Issue 2: Unnecessary nested container structure
                    child: Container(
                      // Issue 3: Padding within image container creates extra space
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: <Widget>[
                          // The image itself
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                // Issue 5: BoxFit not properly utilized
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover, // Should use the provided boxFit parameter
                              ),
                            ),
                          ),
                          // Issue 4: BackdropFilter not properly overlaying entire image area
                          Positioned(
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    'Breaking',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // More unnecessary spacing from flex structure
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[50],
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed NewsItemView widget that addresses all the spacing issues:
/// 1. ✅ Simplified container structure (removed unnecessary nesting)
/// 2. ✅ Eliminated Expanded widget with flex:3 (removed vertical spacing)
/// 3. ✅ Removed padding within image container
/// 4. ✅ BackdropFilter properly overlays entire image area
/// 5. ✅ Image fills container using provided BoxFit parameter
class FixedNewsItemView extends StatelessWidget {
  const FixedNewsItemView({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.boxFit = BoxFit.cover,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Fix 1 & 2: Simplified structure - removed unnecessary nesting and Expanded with flex
          // Fix 3: Removed padding within image container
          // Fix 4 & 5: Direct Stack for proper BackdropFilter overlay and image filling
          SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand, // Ensures children fill the entire stack area
              children: <Widget>[
                // Fix 5: Image fills container properly using provided BoxFit parameter
                Image.network(
                  imageUrl,
                  fit: boxFit, // Uses the provided BoxFit parameter
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    // Fallback for network image loading errors
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                // Fix 4: BackdropFilter properly overlays entire image area without extra space
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Text(
                          'Breaking',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content area with proper constraints (no unnecessary flex structure)
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}