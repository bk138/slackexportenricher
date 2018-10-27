# slack export enricher

Quick and dirty script to spice up Slack exports for Mattermost to digest
more nicely.

This does two things for Slack->Mattermost export/import:

* Where messages were sent in Slack with files attached, it pastes the
  file URLs into the text in order to have MM show file previews, as MM
  does not seem to honour Slack's `files` JSON.

* For slack-exported http(s) links enclosed in `<>`, it removes the
  brackets in order to let MM not only show the URL but fetch previews.