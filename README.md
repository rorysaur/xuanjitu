# Overview 

[**xuanjitu**](http://xuanjitu.herokuapp.com/) is an online, web-based implementation of Xuanji Tu (璇玑图), an ancient palindrome poem by Chinese poet Su Hui. "One of the earliest extant poems by a woman--also among the most complex and unsung--the Xuanji Tu takes the form of a 29 x 29 character grid, embroidered or woven in five colors in silk, written in classical Chinese in the fourth century." --Jen Bervin, in an [interview](https://www.asymptotejournal.com/interview/an-interview-with-jen-bervin/)

As the poem can be read horizontally, vertically, or diagonally, in either direction, there are thousands and thousands of ways through the grid that can form rhyming poems of various line lengths. Plenty of scholars have published books and papers about how to read it, over the thousand+ years since it was created, but mostly in the form of text and printed diagrams to show the paths through the grid.

This app animates those readings proposed by scholars, and (eventually, I hope) will allow visitors to discover new readings of their own.

Visit the app [here](http://xuanjitu.herokuapp.com/), preferably in Chrome on a device with a large wide screen, like a tablet (landscape mode), laptop, or desktop.


# Tech stack

**xuanjitu** is a Rails app that uses HTML5 Canvas on the frontend.

The technologies used are:
+ Backend framework: **Rails**
+ Database: **Postgres**
+ Frontend: **JavaScript (TypeScript, ES2020)**
+ Canvas library: **Konva.js**
+ Rails testing: **MiniTest**
+ JS testing: **Jest**
+ Web hosting and deployment: **Heroku**


# What the app does

The app is still a work in progress (see **Roadmap** below for future features).

So far, it only has a non-interactive demo mode, where it runs in a continuous loop, about an hour long. The loop consists of over 500 readings (distinct poems) proposed by Michèle Métail in her book _Wild Geese Returning: Chinese Reversible Poems_ (translated by Jody Gladding). For all colors other than red, the loop includes every reading listed in Métail's book (with minor exceptions); for red--which has such a disproportionately large number of possible readings that Métail doesn't list them in the book--the loop contains a sampling of readings that would be valid according to Métail's system.

Pinyin is provided in the sidebar.


# Roadmap

A few of the features I plan to tackle next, in order of priority:

+ **Dictionary definitions:** Add the ability to mouse over characters and see some possible definitions.
+ **Interactive mode:** An alternative to the demo mode, where instead of watching existing readings play, you can create your own, in accordance with existing rules of poem formation.
+ **A second Xuanji Tu variant:** The current implementation is heavily influenced by Métail's interpretation, which I chose because it was available to me in English and easy to follow. There is at least one other interpretation I'd like to implement, which is by Li Wei, a Chinese author. The variant would consist of a different color scheme, a slightly different version of the text, and a different system of rules for forming poems.


# Codebase walkthrough and data model

### Backend

The Rails models, controllers, and JSON views live in their conventional directories under `app/`.

The most important models are:

`Position` represents a position within the 29x29 grid, by x- and y-coordinate. This is actually kind of a "behind-the-scenes" model, usually only queried through one of the other models, but it's included here because I think it's helpful for understanding the data model.

`Character` represents a Chinese character, with text and form (`simplified` vs `traditional`). A position has many characters. This is to potentially support both `simplified` and `traditional` characters at the same position.

`Segment` represents a possible valid line (string of characters) in a poem/reading. Segments consist of characters. The same character can belong to multiple segments. So segments and characters are many-to-many. A segment has a head and a tail. All characters in a segment are of the same color (thus, the segment itself has a `color`). Segments have different lengths, which vary by which color block they are in and the kinds of line lengths that make sense in a given block.

`Reading` represents a possible distinct poem that can be read from the grid, as proposed by a given scholar's interpretation. A reading consists of segments. The same segment can belong to multiple readings. So readings and segments are many-to-many (the join table includes a `line_number` to order the segments). To help locate/index it, a reading has a `block_number` (I broke the grid into 18 blocks and assigned numbers to them), a `number` within its block, and a `color`. With these, you can cross-reference each reading between the model and the source text. For example, the reading with `{ color: "green", block_number: 1, number: 3 }` corresponds to Métail's "Poems in Green", upper left block, 3rd way of reading.

The latter three models are exposed in the API via the endpoints `/characters.json`, `/segments.json`, `/readings.json`, respectively.


### Frontend

The entry point to the frontend code is at `app/javascript/packs/index`. The rest of the frontend code lives in `app/javascript/lib`. Each module defines a class. `Xuanjitu` is the main class and runs the program. The other classes `Character`, `Segment`, and `Reading` each correspond to a backend model.


### Data

Almost all of the rules that determine which segments and readings the app should include, exist in the app as config data. They originate in CSVs, some of which were created manually and some of which are generated from Ruby scripts. These CSVs are seeded into the database via the `seeds` file.

The CSVs and other source data can be found in `db/data`. The generator scripts can be found in `db/scripts`.

To change the logic for generating valid segments:
1. Edit the script `segments_generator.rb`
2. Load the file and run `SegmentsGenerator.new.generate`
3. This will overwrite `db/data/generated_segments.csv`

To change the logic for generating readings:
1. Edit the script `reading_segment_assignments_generator.rb` (or one of the `ReadingGenerator` classes it calls on)
2. Load the file and run `ReadingSegmentAssignmentsGenerator.new.generate`
3. This will overwrite `db/data/generated_reading_segment_assignments.csv`

The pinyin and dictionary definitions come from CC-CEDICT, a downloadable Chinese/English dictionary, converted to CSV form. The full dictionary is not included in the repo. Instead, the script `cedict_filter.rb` produces a small dictionary of just the words that are in the poem. This filtered dictionary is used, so far, only in `lib/tasks/pinyin_forms.rake`.

To update the filtered dictionary:
1. Edit the script `cedict_filter.rb` (note the paths it intends to read from and write to)
2. Load the file and run `CedictFilter.new.run`
3. This will overwrite `db/data/filtered_cedict.csv`

To change any other source data, you would edit the file manually.


# Run locally

1. Clone the repo.
2. Dependencies: `bundle`, `yarn`
3. Set up the db: `rails db:create`, `rails db:schema:load` (OR `rails db:migrate`), `rails db:seed`
4. A couple of rake tasks need to be run after the db is seeded: `rails readings:populate`, `rails pinyin_forms:populate`
5. Run the server: `rails s`, visit on `localhost:3000`
6. (Optional) Also run `./bin/webpack-dev-server` for instant TypeScript compilation and hot-swapping.
7. (Optional) To run tests locally: `rails test` for backend, `yarn test` for frontend (or simply `jest` if you have `jest-cli`)


# Contact me

If you have any comments, suggestions/requests, corrections, or bug reports, open an issue in the repo, or email me at the address on my [profile](https://github.com/rorysaur).


# Further reading

This project originated as part of a conversation with artist [Jen Bervin](http://jenbervin.com/), who has been researching and working with Xuanji Tu for years. You can read more about her related project on her own page [here](http://jenbervin.com/projects/su-huis-reversible-poem#1), and read an interview with her [here](https://www.asymptotejournal.com/interview/an-interview-with-jen-bervin/) (the same one linked to in the **Overview**).

Readings in the app are from [_Wild Geese Returning: Chinese Reversible Poems_](https://www.amazon.com/Wild-Geese-Returning-Chinese-Reversible/dp/9629968002) by Michèle Métail, trans. Jody Gladding.
