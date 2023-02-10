# Welcome to FeedBackEr!

FeedBackEr is a presentation feedback web application created using the Ruby on Rails framework.

## Table of Contents

1. [Overview](#overview)
   1. [FeedBackEr](#feedbacker)
   2. [Included Features](#included-features)
   3. [Possible Improvements](#possible-improvements)
   4. [Technologies Used](#technologies-used)
2. [Instructor Guide](#instructor-guide)
   1. [Preparing Rails](#preparing-rails-and-starting-the-server)
   2. [Creating Presentations](#creating-presentations)
   3. [Assigning Feedback](#assigning-feedback)
   4. [Instructor Features](#instructor-features)
3. [Student Guide](#student-guide)
   1. [Registering Account](#registering-account)
   2. [Viewing Feedback](#viewing-feedback)
   3. [Giving Feedback](#giving-feedback)
4. [Code Guide](#code-guide)
   1. [Models](#models)
   2. [Views](#views)
   3. [Controllers](#controllers)
      - [Developer Controller Contribution](#developer-controller-contribution)
   4. [Database](#database)
   5. [Test Suites](#test-suites)
   6. [Documentation and Style](#documentation-and-style)
5. [Credits](#credits)
6. [References](#references)

## Overview

### FeedBackEr

FeedBackEr is a web application used to allow students to provide feedback on other students presentations. As an instructor, it can serve as a tool to manage student presentations and the associated grades. FeedBackEr gives students the opportunity to give and recieve peer feedback, which is a valuable tool among students, our future teachers and leaders.

### Included Features

FeedBackEr has a variety of features currently implemented in our beta version meant to enhance the peer feedback process. These features are as follws:

#### Customizable Feedback Forms

Presentations vary greatly between presenters, topic, and assignment. Due to this fact, we aim to provide the most customizable feedback options.

Each created feedback form can have an arbitrary number of custom-titled questions, with either textual or numeric input on each. Minimum and maximum value can be set for numeric questions, and minimum and maximum length can be set for text questions. Questions can also be set as required or optional, and the visibility of the response values and respondent identities can also be configured (e.g. only visible to presenters, only visible to instructors, visible to either, or visible to everyone).

![Form Creation Interface](https://cdn.discordapp.com/attachments/1019067030663598080/1049485169716908122/image.png)

#### Flexible Assignment of Feedback

A feedback form is just a set of questions, not inherently tied to any given presentation. A single form can be reused for evaluating multiple presentations, namely for allowing multiple entries for the same presentation assignment (something we don't track yet) to be evaluated the same way, and each presentation can have multiple feedback forms associated with it, namely for having distinct self-evaluation, peer evaluation, and instructor evaluation.

The latter use case is also made possible by the fact that instructors have control over exactly which users evaluate which presenters with a given form, able to unassign and unassign evaluations individually. Of course, for convenience there are also options on the frontend available for assigning evaluations in bulk.

![Feedback Assignment Interface](https://cdn.discordapp.com/attachments/1019067030663598080/1049486355283058718/image.png)
![View of Assigned Feedback](https://cdn.discordapp.com/attachments/1019067030663598080/1049490893868105840/image.png)

#### Authenticated Accounts

While many of these presentations may be public, students may not always want their feedback broadcast to the world, especially the critical reviews. That is why each instructor and student has their own account, allowing them access to certain pages and features, and only showing them what is relevant to that user.

Students and instructors have their own interfaces, giving them easy access to the FeedBackEr features they have access to. While students can only see what is relevant to them, such as their presentations and assigned feedback, instructors have access to all presentations and feedback assignments, as well as the ability to assign them.

Each account uses a unique email (perferably student or organization emails) as their user identifier when logging in, as well as a secure password that is stored as a digest (using [BCrypt](#technologies-used)) in our database. These helps keep your FeedBackEr and other accounts safe as a breach in our database will not lead to leaked passwords.

#### Paged Roster and User Management

Registered users have access to the **users** page, which lists all of the registered users on the site. This roster automatically split into pages of 30 users, which can be naviated using the page navigation menu under the _Class Roster_ header.

![Class Roster Page](https://cdn.discordapp.com/attachments/776139977649684522/1047907169288327249/Screenshot_2022-12-01_at_11.08.30_AM.png)

As an admin, you have the ability to have students drop the class and promote your newly registered instructors to their admin roles on the site. You can perform these actions by clicking on the name of a specific user and then clicking one of the "admin tools" buttons, "Drop Student" or "Promote to Instructor".

![Account Page Admin View](https://cdn.discordapp.com/attachments/776139977649684522/1047908076252037140/Screenshot_2022-12-01_at_11.12.26_AM.png)

Admin also has the ability to add new students to the roser. This action is performed by clicking add students in the Roster View which then takes you to the create account page. Once the account is created the page redirects back to the Roster view where you can find the new student at the bottom.

![Admin Add Student] https://cdn.discordapp.com/attachments/1013613626499801201/1048002905829027880/Screen_Shot_2022-12-01_at_5.27.41_PM.png

### Possible Improvements

#### Student Groups

Presentations are often given as groups, and more often than not, these same groups give multiple presentations throughout the duration of a course. While FeedBackEr currently has support for adding multiple student presenters to a presentation, there is not a way to set up groups of students that can be easily selected when creating a new presentation. Adding presentation groups could make creating new presentation and assigning feedback quicker and easier for instructors. Not only would these presentation groups make assigning presenters easier, but they could be used to assign feedback to select groups of students in just a few clicks!

#### Multiple Course Support

FeedBackEr currently is a single course section implementation, as such, each section requires it's own running instance of FeedBackEr. As instructors often teach more than one section, and students are often taking more than one course, support for more than one course/section is be a _necessary_ feature to add as FeedBackEr is developed.

#### Password Requirements

There is currently only one requirement for a user password: it must be at least 6 characters. This is not very secure, and can lead to users having easily accessible passwords (think 'abc123', '123456', 'zxcvbn') that can be guessed with enough tries (see [locked accounts](#locked-accounts)). Requiring the use of special characters, capital letters, and numbers makes the list of possible simple passwords much larger.

#### Locked Accounts

While it is highly suggested that you use strong passwords, whether through a generator or the use of numbers, special characters, and different cases, it is unavoidable that some users will use simple passwords that can be guessed with a certain number of attempts. Adding a limit of how many sign in attempts can be made from a certain ip address in a period of time prevents this.

#### Password Recovery

Everyone forgets their password every now and then.

There are a few different ways FeedBackEr could implement password recovery, including:

- Email Based Password Reset:
  An email sent to a user contains a link to reset their password
- Password Recovery Codes:
  A user has a set of recovery codes they are told to write down, these can allow you into your account to change your password
- Temporary Password:
  An email sent to a user contains a temporary password, thus you can access your account and change your password

### Technologies Used

The [Ruby on Rails](https://rubyonrails.org) framework (version 7.0.4) was used to develop FeedBackEr.

Within the Rails framework, embedded Ruby files (erb) were used to create the views and [Ruby](https://www.ruby-lang.org/en/) (version 3.1.2) was used for the controller, model, and testing code. [SASS](https://sass-lang.com) and [Bootstrap 3](https://getbootstrap.com/docs/3.3/) were used for styling. A small amount of Javascript using [jQuery](https://jquery.com) was also used for the dropdown navigation menu.

Ruby allows for easy use of [Ruby Gems](https://rubygems.org) through [Bundler](https://bundler.io).
FeedBackEr utilizes the following gems:

#### General:

- rails (v 7.0.4)
- sprockets-rails
- sqlite3 (v 1.4)
- puma (v 5.0)
- importmap-rails
- turbo-rails
- stimulus-rails
- jbuilder
- boostrap-sass (v 3.4.1)
- bcrypt (v 3.1.7)
- tzinfo-data
- bootsnap
- sassc-rails
- faker
- redcarpet

#### For Development:

- debug
- web-console

#### For Testing:

- capybara (v 3.37.1)
- guard (v 2.18.0)
- guard-minitest (v 2.4.6)
- minitest (v 5.15.0)
- minitest-reporters (v 1.5.0)
- rails-controller-testing (v 1.0.5)
- selenium-webdriver (v 4.2.0)
- webdrivers (v 5.0.0)

## Instructor Guide

### Preparing Rails and Starting the Server

This guide assumes that you have already set up the following technologies. If you have not, please follow the links to intall them.

- [Ruby 3.1.2](https://www.ruby-lang.org/en/downloads/)
- [Rails 7.0.4](https://guides.rubyonrails.org/v5.0/getting_started.html)

The first step in setting up your FeedBackEr site is downloading the project from [Github](https://github.com/cse3901-2022au-giles/team4-presentation-feedback-site). This contains everything you will need to get started with FeedBackEr!

In your terminal, navigate the the FeedBackeEr directory. While in this directory, you must first install the gems listed in the [technologies used](#technologies-used) section. Bundler makes this extremely easy using the **Gemfile**. All you need to do is run the following command:

```
bundle install
```

Now that all of the gems have been installed, you must migrate the database in preperation for the site to be launched. You can do this with the command:

```
rake db:create db:migrate
```

In order for the application to work correctly, the database will need to be seeded to populate the reference tables containing the list of question types and the list of applicable configuration options for each question. To do this, enter:

```
rake db:seed
```

Currently, the seed file also contains lines to populate the users table for testing purposes. This will provide you with one admin login with email: "admin@email.com" and password: "adminpass22", and many randomly generated student users. To avoid this, you can comment out lines 1 through 22 in **app/seeds.rb.**

After these commands, you should be able to launch your FeedBackEr server with:

```
rails server
```

This should provide you with a web address listed after "Listening on". Copy this address and paste it into the browser of your choice. This should take you to the FeedBackEr home page!

### Creating Presentations

As an instructor (with a seeded database, use email: "admin@email.com" password: "adminpass22"), click on the presentations link on the top navigation bar. This will take you to an index of all of the presentations on the site. Keep in mind, when a student accesses the presentations page, it will only show their presentations. On the presentations page, you should see a "New Presentation" button. When you click on this button, it will take you to the create presentation page.

On the create presentation page, type out the name of the presentation and the date it was given. This is the main identifying information that the presentation has. There will also be a selection box listing all of the users on the side. This is where you select the students who gave this presentation. You can select one student by clicking on their name, which will be highlighted blue. You can select multiple students by holding control (or command on mac) when you click student names.

After you select all of the students who presented, click on the "Create Presentation" button to add this presentation to the site. It should then take you to the presentations index page where the new presentation is displayed!

![Create Presentation Page](https://cdn.discordapp.com/attachments/776139977649684522/1047886290076577883/Screenshot_2022-12-01_at_9.45.48_AM.png)

### Instructor Features

Instructors have access to all of the information on the website (excluding user passwords). Through the user page you can view all of the site's users, make newly registered users into instructors, and drop students from your class (deleting the user account). From the presentations page you can view all the created presentations and their presenters. By clicking on a presentation you can view all of the feedback given and by whom.

### Creating a Feedback Form

The "Feedback Forms" page listed on the navbar shows the interface for managing forms. Instructors have options to add a new form, edit an existing form, copy an existing form, preview a form, or delete a form.

![Feedback Form Management Page](https://cdn.discordapp.com/attachments/1019067030663598080/1049537690346995773/image.png)

The former three options will take the user to the form editor interface, from which they can set the form title and add, edit, or delete questions, with options for setting the question's type, text, ordering, visibility, and anonymity.

![Feedback Form Editor](https://cdn.discordapp.com/attachments/1019067030663598080/1049538557208973332/image.png)

The page contains front-end validation to ensure that the form has been set correctly before it can be saved. This includes making sure that every question has a text prompt and a value type, as well as checking that the settings have valid values (e.g. the max length for a text response cannot be shorter than the min length, unless it's been set to 0/nil for unlimited length). 

Once the validations pass, the form can be saved to the database, with a new entry created if doing so from the "new" page and the existing entry modified if doing so from the "edit" page. Afterwards, the user will be taken to a preview of the saved form, in which it will have the exact same appearance as what's visible to users submitting evaluations with it.

![Feedback Form Preview, Pt. 1](https://cdn.discordapp.com/attachments/1019067030663598080/1049540231948402798/image.png)

Like the editor interface, the completion interface also contains front-end validations to ensure that the form is filled out correctly, namely that all required questions have been responded to and that all responses are in the correct value range (for numeric response) or length range (for written response).

![Feedback Form Preview, Pt. 2](https://cdn.discordapp.com/attachments/1019067030663598080/1049898646465957998/image.png)

### Assigning Feedback

The "Assign Feedback" item on the navbar will take the instructor to a page that allows them to manage the assigned copies of each feedback form. A button is available on the top to make additional assignments, followed by a list of all evaluations assigned to the current user, followed by the lists of users evaluating each presentation using each of the currently-present forms. Buttons on each form and presentation listing are present for viewing the responses and for making additional assignments, with the latter pointing to the same link as the button at the top of the page, but with parameters set to pre-select the given form and/or presentation.

![Assignment Management Page, Pt. 1](https://cdn.discordapp.com/attachments/1019067030663598080/1049548063376670739/image.png)
![Assignment Management Page, Pt. 2](https://cdn.discordapp.com/attachments/1019067030663598080/1049548658623922206/image.png)

Upon pressing the "Create Assignments" button or any of the "Assign More" buttons, the instructor will be taken to a page that allows them to assign copies of a selected form to be used for evaluating a selected presentation. The instructor has the option to select a specfic student as the evaluator, though in most cases it would be more convenient to use one of the bulk selection options (peers, self, instructors, or everyone).

![New Assignment Page, Pt. 1](https://cdn.discordapp.com/attachments/1019067030663598080/1049550530600521748/image.png)
![New Assignment Page, Pt. 2](https://cdn.discordapp.com/attachments/1019067030663598080/1049549341418852372/image.png)

After pressing the "Assign" button, the instructor will be taken back to the main "Assigned Feedback" page, where they will be able to see the new assigned copies. They will also have the option to individually unassign evaluators in case of mistaken assignments. We still have yet to implement a direct way to do this in bulk, though, with the quickest workaround being to create a copy of the form and then delete the old one.

![Assignment Management Page, Pt. 3](https://cdn.discordapp.com/attachments/1019067030663598080/1049551253052608554/image.png)

### Viewing Responses

From the "Assigned Feedback" page, the "View All Responses" button on each listed form will take the instructor to a page listing the responses for each evaluated presentation for each question in the form. For quantitative questions, the mean, median, low, and high are listed to provide an analytical summary.

![View Responses Page, All Presentations](https://cdn.discordapp.com/attachments/1019067030663598080/1049897227667120199/image.png)

(Note Question 2 on this form was set to be anonymous to everyone, and the effects of this, as well as the configurable visibility settings, are now visible as of the full release).

Each presentation listing nested under the form listing also has a button for viewing the responses for that specific presentation only.

![View Responses Page, Single Presentation](https://cdn.discordapp.com/attachments/1019067030663598080/1049897398291419186/image.png)

## Student Guide

### Registering Account

When you first access the FeedBackEr site, you will first need to create your account. On the FeedBackEr home page, there is a big blue button that says "Sign Up!". This will take you to a sign up page where you will enter your name, email, and a secure password. After you enter information for all of those fields, just hit "Create Account" and you are all registered. Once you are registered, the next step is for you to wait until 1) your instructor assigns you feedback or 2) one of your presentations receives feedback.

![log in screen](https://cdn.discordapp.com/attachments/776139977649684522/1047885204414550047/Screenshot_2022-12-01_at_9.41.07_AM.png)

### Viewing Feedback

You can access the feedback you receive from your peers on the **presentations** page. Here you will be able to view all the presentations that you, or a group you were in, have given. When you click to view a specific presentation, the feedback provided by your peers will be listed on the page for you to view!

### Giving Feedback

## Code Guide

### Models

This project uses a variety of models to store and associate the users, presentations, and feedback on the site. The models are described below:

#### Users

The user model is located in the **app/models/user.rb** file. The user model provides validations for valid names (must be present), emails (must be unique, present, and follow an email REGEX), and passwords (must be present and at least 6 characters long). The user model also provides the association between users and presentation as a many to many association, meaning each user can have many presentations, and each presentation can have many users. The user model also contains a method to provide a password digest for a given string, which is used for testing. 

#### Presentations

The presentations model is located in the **app/models/presentation.rb** file. The presentation model validates that each presentation, a name and date are present. It also provides the aformentioned association between presentations and users, which is a many to many association. 

#### Feedback

The feedback forms have multiple interconnected models in **app/models/presentation.rb** for tracking various aspects of each form, including five of which are populated by user action and three of which are populated upon initialization and used as reference tables.

The user-populated models are as follows:
- The basic bookkeeping info (FeedbackForm, containing a title)
- Attached questions (FeedbackQuestion, containing the form ID, a text prompt, a order number, and a type indicator)
- Settings applied to questions (FeedbackSetting, containing the question ID, the ID of the settings option, and the applied value)
- Assigned copies of forms (FeedbackAssignment, containing the ID of the form to assign, the ID of the presenter being evaluated, and the ID of the user doing the evaluation)
- Responses (FeedbackResponse, containing the ID of the assigned copy, the ID of the question, and the response value)

The reference models are as follows:
- Available question types (FeedbackQuestionType, containing an internal label, a reader-friendly descriptor, and an indicator for whether the allowed values are quantitative), with initial values for numeric and text
- Available settings options (FeedbackQuestionSettingsOption, containing an indicator for which type the option is applicable to (null to make it applicable to all), an internal label, a reader-friendly descriptor, and an indicator for whether the allowed values are quantitative, and a default value), with initial values for required/optional, min/max value (applicable to numeric type), min/max length (applicable to text type), response visibility, and response anonymity
- Available values that can be applied to qualitative-valued options (FeedbackQuestionSettingsValue, containing the ID of the corresponding option, an internal label, and a reader-friendly descriptor), with initial values of yes/no for the "required" option, presenters only / instructors only / instructors and presenters / everyone for the visibility option, and nobody / presenters only / instructors only / instructors and presenters / everyone for the anonymity option

### Views

#### Info

The info views are located in the **app/views/info** directory and contains the files **about.html.erb** and **contact.html.erb**. These are static pages that contain information about FeedBackEr (including this about page!). This README also serves as the about page, and the contact page contains a link to each of teh developers' github pages.

#### Layouts

The layouts are located in the **app/views/layouts** directory and contains the files **\_footer.html.erb**, **\_forbidden.html.erb**, **\_header.html.erb**, **\_rails_default.html.erb**, **application.html.erb**, **mailer.html.erb**, and **mailer.text.erb**. The files that lead with an underscore are _partials_ that are commonly rendered throughout the site. Most of them are self explanatory. **\_header.html.erb** provides the html for the navigation bar and the **\_footer.html.erb** for the footer. **\_forbidden.html.erb** is used when a student attempts to access an instructors only page, the create presentation page for example. **\_rails_default.html.erb** is used to provide the HTML header with the default rails information.

The **application.html.erb** is the site layout, which renders html for each page, including the navigation bar and footer, as well as other standard information, and uses the erb **<% yield %>** to render the page currently being accessed.

**mailer.html.erb**, and **mailer.text.erb** are automatically generated by rails and are not used by FeedBackEr.

#### Presentations

The presentation views are located in the **app/views/presentations** directory and contains a variety of files for each of the presentation pages. These pages include the index of presentations, the create presentation page, the edit presentation page, and the page for each individual presentations information and feedback. The **new.html.erb** and **edit.html.erb** use the **\_form.html.erb** partial to render a form that allows for the information of a presentation to be entered.

#### Sessions

The only view for sessions is the view for the log in page, which is located in the file **app/views/sessions/new.html.erb**. This generates a form for a user to enter their email and password, which is then sent to the sessions controller to autenticate the user.

#### Site

The only view in the site category is the home page, found in **app/views/site/home.html.erb**. This renders the different home pages for a non-logged in user, a student user, and an instructor user.

#### Users

The user views follow a very similar format to the presentation views. Located in the **app/views/users** directory, there are views for the indexing, creation, viewing, and editing of users.

#### Feedback

The feedback-related views are organized into three directories, each corresponding to the related controllers.

In **app/views/feedback_forms**, the index page displays the contents pointed to by the "Feedback Forms" link in the instructor navbar, with the other pages in the directory accessible from here; the "new" and "edit" pages display the interface for creating and editing a form, both using the "_form_editor" partial; and the "show" page displays the preview of the given form, using the "_feedback_form_interface" partial found in the "shared" directory that's also used on the page for actually submitting the form. All of these are only intended for instructor view.

In **app/views/feedback_assignments**, the index page displays the contents pointed to by the "Assigned Feedback" link on the student navbar and the "Assign Feedback" link on the instructor navbar, selectively rendering depending on the current user's role, with the "_my_assigned_feedback" partial in the directory being used in both cases. The "new" page, only intended for instructor view, displays the contents of the page pointed to by the "Create Assignments" and "Assign More" buttons on the index page.

In **app/views/feedback_responses**, the index page displays the list of responses to a given form, either for a single presentation or for all associated presentations depending on whether a presentation ID parameter is passed to the controller. The "new" page displays the interface for filling out and submitting an assigned evaluation.

### Controllers

#### Static Pages (Info and Site)

The info and site controllers are located in **app/controllers/info_controller.rb** and **app/controllers/site_controller.rb** respectively. These controllers only contain methods to render their associated views.

#### Users

The users controller, found in **app/controllers/users_controller.rb**, handles the creation and editing of users when receiving the form data from the new users page view, as well as indexing and showing specific users. The users controller also contains methods for determining if a user is logged in and whether the logged in user is an admin.

#### Presentations

The presentations controller, found in **app/controllers/presentations_controller.rb**, has a very similar structure to the users controller, and has many of the same methods for creating, editing, and viewing presentations. The create function also includes a section that associates all of the presenting users with the specific presentation being created or edited.

#### Sessions

The sessions controller, found in **app/controllers/sessions_controller.rb**, includes create and destroy methods for creating a new user session. The create method allows an authenticated user to log in to the site by receiving form information from the **app/views/sessions/new.html.erb** view. The destroy method logs a user out of the site.

#### Feedback

As mentioned under the views section, there are three controllers associated with the feedback system.

The FeedbackForms controller (**app/controllers/feedback_forms_controller.rb**) contains actions for managing the forms themselves, intended to only be accessible to admin users. All seven default resource routes are implemented and operate according to convention, with the #new action also have an option to take a form ID as a parameter to allow a copy of an existing form the be created, with the fields in the creation interface populated with the existing values.

The FeedbackAssignments controller (**app/controllers/feedback_assignments_controller.rb**) contains actions for assigning forms to users for evaluating a given assignment and viewing with evaluations have been assigned to who. The #index, #new, #create, and #destroy resource routes are available, with all but #index intended to be only accessible to admin users. #new can take parameters for form ID and presentation ID to preselect the inputs for a small amount of added convenience, and #create takes a parameter to specify bulk assignment for the given form and presentation ("peers", "presenters", "instructors", "everyone", or "custom" - specify a specific user ID in the latter case). #destroy works on a single assigned copy for a given user ID, presentation ID, and form ID, though future versions may add the ability to perform bulk deletions using a null user ID or presentation ID.

The FeedbackResponses controller (**app/controllers/feedback_assignments_controller.rb**) contains actions for sending and viewing responses to assigned evaluations. The #index, #new, and #create resource routes are available, though the other four could potentially be implemented in a future version. All three of the current routes are intended to be accessible to both admin users and regular users, as would be necessary for the site to function properly as #new and #create are what allow users to actually submit feedback. #index has options to display responses for all presentations being evaluated using that form, or just a single presentation specified with an ID.

#### Developer Controller Contribution

Canaan Porter: Generated presentations and users controllers. Modified presentations controller to add user associations to presentation upon creation and editing. Created the sessions controller. Created make_admin controller action in the users controller to promote users to instructor.

Austin Greer: Contributed to User (confirming admin account status / displaying all the users/ updating account info) and Sessions (rerouting to the home page after logging in)

Alvin Ishimwe: Developed user: Allowing admin to delete users from roster in addition to being able add students to the roster. Defined method to verify correct user and paginated users page.

Thomas Li: Generated and implemented FeedbackForms, FeedbackAssignments, and FeedbackResponses controllers.

### Database

#### Schema

The **db/schema.rb** file contains all the final database tables created through migrations generated throughout the development of FeedBackEr. These migrations can be viewed in the **db/migrate** directory.

#### Seeds

The **db/seeds.rb** and **db/seeds0.rb** files are used to fill the database with users to test the site during development. This currently generates one admin user and 99 test student users with random names and emails (using [faker](https://github.com/faker-ruby/faker)), along with the initial values for the reference tables listing the question types and available settings options. When ready for production, the **seeds.rb** file will generate only the reference values along with an admin user for inital login, then this admin can promote other users to admin (instructor) status.

### Test Suites

The automated test suites for this project are located in the **test** directory. This includes tests for the controllers and models, that can be run using:

```
rails test
```

### Documentation and Style

At the top of each model file there is a comment block that describes the model, including all of the different table columns and associations.

This project follows the Rubocop style guide for programming in Ruby, assisted by the Rubocop gem to make any corrections to style.

For JavaScript, [the Mozilla Developer Network (MDN) style guide](https://developer.mozilla.org/en-US/docs/MDN/Writing_guidelines/Writing_style_guide/Code_style_guide/JavaScript) was used.

## Credits

This project was developed by:

- **[Thomas Li](https://github.com/li11315-osu)**
- **[Canaan Porter](https://github.com/CPort28)**
- **[Austin Greer](https://github.com/austin-OS)**
- **[Alvin Ishimwe](https://github.com/ai003)**

## References

- [Ruby On Rails Tutorial](https://www.railstutorial.org/book)
- [Rails Guides](https://guides.rubyonrails.org)
- [Bootstrap 3](https://getbootstrap.com/docs/3.3/)
