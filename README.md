# slack export enricher

This does two things for Slack->Mattermost export/import:

* Where files were sent in Slack with an empty text message, it pastes
  the file URLs in the text in order to have MM show file previews instead
  of simply an empty message, as it does not seem to honour the files
  section.

* For slack-exported http(s) links enclosed in `<>`, it removes the
  brackets in order to let MM not only show the URL but fetch previews.