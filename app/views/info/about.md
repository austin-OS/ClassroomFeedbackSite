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

Presentations vary greatly between presenters, topic, and assignment. Due to this fact, we aim to provide the most customizable feedback options. Each presentation has it's own feedback form for assigned students to fill out, which can be customized greatly using the feedback form creator **ADD MORE AS IMPLEMENTED**

#### Authenticated Accounts

While many of these presentations may be public, students may not always want their feedback broadcast to the world, especially the critical reviews. That is why each instructor and student has their own account, allowing them access to certain pages and features, and only showing them what is relevant to that user. 

Students and instructors have their own interfaces, giving them easy access to the FeedBackEr features they have access to. While students can only see what is relevant to them, such as their presentations and assigned feedback, instructors have access to all presentations and feedback assignments, as well as the ability to assign them. 

Each account uses a unique email (perferably student or organization emails) as their user identifier when logging in, as well as a secure password that is stored as a digest (using [BCrypt](#technologies-used)) in our database. These helps keep your FeedBackEr and other accounts safe as a breach in our database will not lead to leaked passwords.

**ADD MORE**

### Possible Improvements

#### Student Groups

Presentations are often given as groups, and more often than not, these same groups give multiple presentations throughout the duration of a course. While FeedBackEr currently has support for adding multiple student presenters to a presentation, there is not a way to set up groups of students that can be easily selected when creating a new presentation. Adding presentation groups could make creating new presentation and assigning feedback quicker and easier for instructors. Not only would these presentation groups make assigning presenters easier, but they could be used to assign feedback to select groups of students in just a few clicks!

#### Multiple Course Support

FeedBackEr currently is a single course section implementation, as such, each section requires it's own running instance of FeedBackEr. As instructors often teach more than one section, and students are often taking more than one course, support for more than one course/section is be a *necessary* feature to add as FeedBackEr is developed.

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

**ADD MORE**

### Technologies Used

The [Ruby on Rails](https://rubyonrails.org) framework (version 7.0.4) was used to develop FeedBackEr.

Within the Rails framework, embedded Ruby files (erb) were used to create the views and [Ruby](https://www.ruby-lang.org/en/) (version 3.1.2) was used for the controller, model, and testing code. [SASS](https://sass-lang.com) and [Bootstrap 3](https://getbootstrap.com/docs/3.3/) were used for styling. A small amount of Javascript using [jQuery](https://jquery.com) was also used for the dropdown navigation menu.

Ruby allows for easy use of [Ruby Gems](https://rubygems.org) through [Bundler](https://bundler.io).
FeedBackEr utilizes the following gems:

General:
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

For Development:
- debug
- web-console

For Testing:
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
If you would like to seed the database for testing purposes, use:
```
rake db:seed
```
This will provide you with one admin login with email: "admin@email.com" and password: "adminpass22", and many randomly generated student users.

After these commands, you should be able to launch your FeedBackEr server with:
```
rails server
```
This should provide you with a web address listed after "Listening on". Copy this address and paste it into the browser of your choice. This should take you to the FeedBackEr home page!

### Creating Presentations

As an instructor (with a seeded database, use email: "admin@email.com" password: "adminpass22"), click on the presentations link on the top navigation bar. This will take you to an index of all of the presentations on the site. Keep in mind, when a student accesses the presentations page, it will only show their presentations. On the presentations page, you should see a "New Presentation" button. When you click on this button, it will take you to the create presentation page.

On the create presentation page, type out the name of the presentation and the date it was given. This is the main identifying information that the presentation has. There will also be a selection box listing all of the users on the side. This is where you select the students who gave this presentation. You can select one student by clicking on their name, which will be highlighted blue. You can select multiple students by holding control (or command on mac) when you click student names.

After you select all of the students who presented, click on the "Create Presentation" button to add this presentation to the site. It should then take you to the presentations index page where the new presentation is displayed!

### Assigning Feedback

### Instructor Features

Instructors have access to all of the information on the website (excluding user passwords). Through the user page you can view all of the site's users, make newly registered users into instructors, and drop students from your class (deleting the user account). From the presentations page you can view all the created presentations and their presenters. By clicking on a presentation you can view all of the feedback given and by whom. **ADD MORE**

## Student Guide

### Registering Account

When you first access the FeedBackEr site, you will first need to create your account. On the FeedBackEr home page, there is a big blue button that says "Sign Up!". This will take you to a sign up page where you will enter your name, email, and a secure password. After you enter information for all of those fields, just hit "Create Account" and you are all registered. Once you are registered, the next step is for you to wait until 1) your instructor assigns you feedback or 2) one of your presentations receives feedback.

### Viewing Feedback

You can access the feedback you receive from your peers on the **presentations** page. Here you will be able to view all the presentations that you, or a group you were in, have given. When you click to view a specific presentation, the feedback provided by your peers will be listed on the page for you to view!

### Giving Feedback

## Code Guide

### Models

This project uses a variety of models to store and associate the users, presentations, and feedback on the site. The models are described below:

#### Users

The user model is located in the **app/models/user.rb** file. The user model provides validations for valid names (must be present), emails (must be unique, present, and follow an email REGEX), and passwords (must be present and at least 6 characters long). The user model also provides the association between users and presentation as a many to many association, meaning each user can have many presentations, and each presentation can have many users. The user model also contains a method to provide a password digest for a given string, which is used for testing. **ADD FEEDBACK GROUPS**

#### Presentations

The presentations model is located in the **app/models/presentation.rb** file. The presentation model validates that each presentation, a name and date are present. It also provides the aformentioned association between presentations and users, which is a many to many association. **ADD FEEDBACKS**

#### Feedback

### Views

#### Info

The info views are located in the **app/views/info** directory and contains the files **about.html.erb** and **contact.html.erb**. These are static pages that contain information about FeedBackEr (including this about page!). This README also serves as the about page, and the contact page contains a link to each of teh developers' github pages.

#### Layouts

The layouts are located in the **app/views/layouts** directory and contains the files **_footer.html.erb**, **_forbidden.html.erb**, **_header.html.erb**, **_rails_default.html.erb**, **application.html.erb**, **mailer.html.erb**, and **mailer.text.erb**. The files that lead with an underscore are *partials* that are commonly rendered throughout the site. Most of them are self explanatory. **_header.html.erb** provides the html for the navigation bar and the **_footer.html.erb** for the footer. **_forbidden.html.erb** is used when a student attempts to access an instructors only page, the create presentation page for example. **_rails_default.html.erb** is used to provide the HTML header with the default rails information.

The **application.html.erb** is the site layout, which renders html for each page, including the navigation bar and footer, as well as other standard information, and uses the erb **<% yield %>** to render the page currently being accessed.

**mailer.html.erb**, and **mailer.text.erb** are automatically generated by rails and are not used by FeedBackEr.

#### Presentations

The presentation views are located in the **app/views/presentations** directory and contains a variety of files for each of the presentation pages. These pages include the index of presentations, the create presentation page, the edit presentation page, and the page for each individual presentations information and feedback. The **new.html.erb** and **edit.html.erb** use the **_form.html.erb** partial to render a form that allows for the information of a presentation to be entered. 

#### Sessions

The only view for sessions is the view for the log in page, which is located in the file **app/views/sessions/new.html.erb**. This generates a form for a user to enter their email and password, which is then sent to the sessions controller to autenticate the user.

#### Site

The only view in the site category is the home page, found in **app/views/site/home.html.erb**. This renders the different home pages for a non-logged in user, a student user, and an instructor user.

#### Users

The user views follow a very similar format to the presentation views. Located in the **app/views/users** directory, there are views for the indexing, creation, viewing, and editing of users.

### Controllers

#### Static Pages (Info and Site)

The info and site controllers are located in **app/controllers/info_controller.rb** and **app/controllers/site_controller.rb** respectively. These controllers only contain methods to render their associated views.

#### Users

The users controller, found in **app/controllers/users_controller.rb**, handles the creation and editing of users when receiving the form data from the new users page view, as well as indexing and showing specific users. The users controller also contains methods for determining if a user is logged in and whether the logged in user is an admin.

#### Presentations

The presentations controller, found in **app/controllers/presentations_controller.rb**, has a very similar structure to the users controller, and has many of the same methods for creating, editing, and viewing presentations. The create function also includes a section that associates all of the presenting users with the specific presentation being created or edited.

#### Sessions

The sessions controller, found in **app/controllers/sessions_controller.rb**, includes create and destroy methods for creating a new user session. The create method allows an authenticated user to log in to the site by receiving form information from the **app/views/sessions/new.html.erb** view. The destroy method logs a user out of the site.

#### Developer Controller Contribution

Canaan Porter: Generated presentations and users controllers. Modified presentations controller to add user associations to presentation upon creation and editing. Created the sessions controller.

### Database

#### Schema

The **db/schema.rb** file contains all the final database tables created through migrations generated throughout the development of FeedBackEr. These migrations can be viewed in the **db/migrate** directory.

#### Seeds

The **db/seeds.rb** and **db/seeds0.rb** files are used to fill the database with users to test the site during development. This currently generates one admin user and 99 test student users with random names and emails (using [faker](https://github.com/faker-ruby/faker)). When ready for production, the **seeds.rb** file will generate only an admin user for inital login, then this admin can promote other users to admin (instructor) status.

### Test Suites

The automated test suites for this project are located in the **test** directory. This includes tests for the controllers and models, that can be run using:
```
rails test
```

### Documentation and Style

At the top of each model file there is a comment block that describes the model, including all of the different table columns and associations.

This project follows the Rubocop style guide for programming in Ruby, assisted by the Rubocop gem to make any corrections to style.

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
