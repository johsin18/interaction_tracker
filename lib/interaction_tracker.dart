library interaction_tracker;

import 'dart:js';

/** Tracker that tracks user interactions with Piwik when a grace period has expired. */
class InteractionTracker {
  Duration _period;
  DateTime _lastTimeUserInteractionTracked = new DateTime.now();

  InteractionTracker(this._period) { }

  /** Track if period has elasped since last time. */
  void trackUserInteraction(String message) {
    Duration timeSinceLastTracking = new DateTime.now().difference(_lastTimeUserInteractionTracked);
    if (timeSinceLastTracking >= _period) {
      _track(message);
      _lastTimeUserInteractionTracked = new DateTime.now();
    }
  }

  /** Track now in any case. */
  void trackSpecificUserAction(String message) {
    _track(message);
  }

  void _track(String message) {
    if (context['_paq'] != null)
      context['_paq'].callMethod('push', [ new JsArray.from(['trackPageView', message]) ]);
  }
}
