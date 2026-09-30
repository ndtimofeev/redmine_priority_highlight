# Redmine Priority Highlight

Highlights issues in lists by priority so long queries are easier to scan.
The highlight mode is a setting of each **saved issue query**.

- Colors are stored once, per priority, in a custom field (type "Issue priorities").
- Priorities without a color keep Redmine's own look; the normal priority has none by default.
- Closed issues and rows selected in the context menu are never highlighted.
- Colors come from Open Color, the palette Redmine's theme is built on.

## Modes

Set in the query form under *Options* → "Highlight by priority":

| Mode | Look |
|---|---|
| None | Redmine's default |
| Priority cell | stripe on the left and a tinted priority cell |
| Whole row | stripe on the left and a tinted row |
| Stripe on the left | stripe only |

## Requirements

Redmine 6.0 or newer (developed against 7.0).

## Install

```
cd <redmine>/plugins
git clone https://github.com/ndtimofeev/redmine_priority_highlight
cd <redmine>
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

Restart Redmine. The migration creates the custom field **Highlight color**
(a `#rrggbb` string) and fills in default colors for priorities that have none,
relative to the normal priority:

| Priority | Default color |
|---|---|
| normal | none |
| lower | grays, the lower the paler |
| higher | orange, then red; the highest is always red |

Change colors in *Administration → Enumerations → Issue priorities*.
Rolling the migration back (`NAME=redmine_priority_highlight VERSION=0`)
deletes the field together with the colors.

## Known limitations

- Only issue lists of saved queries; Gantt, calendar, issue page and e-mails are not covered.
- The checkbox-like control in the query form is injected by JavaScript, because
  `queries/_form.html.erb` has no hook.
- The layout head hook reads the color map on every page (two small queries).
- Dark themes are untested.

## Tests

The pure parts run without Redmine:

```
ruby test/unit/default_scheme_test.rb
ruby test/unit/stylesheet_test.rb
```
