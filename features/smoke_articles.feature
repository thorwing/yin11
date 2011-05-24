Feature: smoke tests for Articles
  Only Editor and Admin can create new articles.
  Only Editor and Admin can edit articles.
  Only Editor and Admin can delete articles.
  Editor can upload images for a articles, and one of the images will be displayed as thumbnail.
  Editor can add descriptions on images.
  User can vote fro a article.
  User can comment on a articel, comments can be nested.

  Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There is a "Ray Admin"
    And There are minimal testing records