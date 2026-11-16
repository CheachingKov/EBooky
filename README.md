# eBooky

> An offline-first mobile eBook library for discovering, organizing, and
> reading books.

## About the Project

eBooky is a Flutter mobile application project developed for **Mobile
Development -- Term 1, GEN 11**.

The goal of eBooky is to provide readers with one convenient place to
browse a collection of books, view book information, organize their
personal library, and read selected books directly inside the
application.

The application is designed to work offline using locally available
data. The initial demonstration is planned to include a larger catalog
of book details and reading content for approximately two or three
sample books.

## Problem Statement

Readers may need to use multiple websites or applications to find books,
discover new titles, and access reading material. eBooky aims to make
these activities more convenient by bringing book discovery, personal
library organization, and reading into one mobile application.

## Target Users

-   Students
-   Book enthusiasts
-   Casual readers
-   People who want to discover and read books digitally

## Planned Features

The following features are based on the project's Milestone 1
requirements and current design plan. They describe the intended scope;
they should not be considered completed until implemented and tested.

### Book Discovery

-   Browse the available book catalog.
-   Search books by title or other supported information.
-   Filter books, such as by genre.
-   View book details, including cover, title, author, genre, and
    description.
-   Show whether a book has reading content available.

### Reading

-   Open available book content inside the application.
-   Navigate between pages.
-   Save the reader's last reading position.
-   Continue reading from the saved position.

The initial demonstration is planned to provide text-based content for
approximately two or three sample books. Other catalog entries may
contain book details only.

### My Library

Planned personal library organization includes:

-   Save or remove books from Favorites.
-   Save books to Read Later.
-   Track reading status, such as Want to Read, Currently Reading, and
    Completed.
-   Create custom reading lists.
-   Add books to and remove books from custom lists.
-   View reading history.

A book may be both a favorite and part of another category or custom
list.

### Appearance

-   Change the application theme.
-   Planned theme choices may include light and dark modes.

## Technology and Project Constraints

-   **Framework:** Flutter
-   **Language:** Dart
-   **Platform approach:** Offline, local-data-based application
-   **Backend/API:** Not planned for this course project
-   **State management:** Flutter's built-in `setState`, callbacks, and
    navigation; no external state-management framework

The local persistence approach and database implementation are still to
be finalized.

## Planned Architecture

The project follows a separation between models, services, tests, and
the user interface.

``` text
lib/
├── model/
│   ├── book.dart
│   ├── book_page.dart
│   ├── library_item.dart
│   ├── reading_list.dart
│   ├── reading_progress.dart
│   ├── reading_history.dart
│   └── ...
├── service/
│   └── ...
├── data/
│   └── ...
├── screens/
│   └── ...
└── main.dart

test/
└── ...
```

This is a proposed structure and may change as the model, service,
database, and UI designs are finalized.

### Model Layer

The model layer represents the application's business concepts.
Candidate models currently include:

  -----------------------------------------------------------------------
  Model                               Responsibility
  ----------------------------------- -----------------------------------
  `Book`                              Stores book information.

  `BookPage`                          Represents a page of reading
                                      content.

  `LibraryItem`                       Represents a book saved in the
                                      reader's personal library,
                                      including favorite and
                                      reading-status information.

  `ReadingList`                       Represents a custom collection of
                                      books.

  `ReadingProgress`                   Stores the reader's current
                                      position in a book.

  `ReadingHistory`                    Records recently opened books.
  -----------------------------------------------------------------------

These are proposed models and will be reviewed during the design
process.

### Service Layer

The service layer will contain business operations and rules, such as:

-   Searching and filtering books.
-   Creating and managing reading lists.
-   Adding and removing books from the personal library.
-   Updating and retrieving reading progress.
-   Recording and retrieving reading history.
-   Changing the application theme.

### Test Layer

Unit tests will verify service operations under different conditions:

-   Normal cases: valid operations and expected results.
-   Invalid cases: invalid input or operations that violate business
    rules.
-   Boundary and special cases: empty collections, missing items, page
    limits, and other relevant edge conditions.

The project milestone requires at least five test cases in total. Tests
will be expanded to cover the implemented service operations.

## Development Status

The project is being developed incrementally.

  -----------------------------------------------------------------------
  Area                                Current status
  ----------------------------------- -----------------------------------
  Application goal and target users   Defined in Milestone 1

  Use case diagram and user stories   Drafted in Milestone 1

  UI mockups                          Initial design created with Google
                                      Stitch; refinement is ongoing

  Entity identification               In progress

  ERD and relationships               To be finalized

  Model attributes and Dart classes   To be designed and implemented

  Services and business rules         To be implemented

  Unit tests                          To be implemented

  Local database and persistence      Approach to be decided

  Flutter UI implementation           Planned
  -----------------------------------------------------------------------

## Getting Started

After the Flutter project has been set up:

1.  Install the Flutter SDK and a supported development environment.

2.  Clone or download the project.

3.  Open the project directory in your IDE.

4.  Fetch the project's dependencies:

    ``` bash
    flutter pub get
    ```

5.  Run the application on an emulator or connected device:

    ``` bash
    flutter run
    ```

Run the test suite with:

``` bash
flutter test
```

> These commands assume the Flutter project and its dependencies have
> been configured.

## Project Scope

eBooky is an academic mobile development project. Its initial scope
focuses on local book discovery, book details, personal library
organization, reading progress, reading history, and a small
demonstration of in-app reading.

The project does not currently plan to provide online accounts, cloud
synchronization, online book downloads, payments, or a remote backend.

## License and Book Content

This is an academic project. Book descriptions, cover images, and
reading samples should use original, properly licensed, or public-domain
material. Copyrighted book content should not be reproduced without
permission.

## Acknowledgment

Developed as part of the **Mobile Development -- Term 1, GEN 11**
course.
