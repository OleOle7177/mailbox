# Mailbox

Приложение позволяет просматривать почту gmail-аккаунта пользователя (используется протокол POP3).

## Установка

Установите гемы:

	$ bundle install

Создайте базу данных и запустите миграции: 

	$ rake db:create
	$ rake db:schema:load 

Запустите приложение: 

	$ rails s

## Работа с приложением: 

Для авторизации используется протокол OAuth 2.0: пользователь перенаправляется на страницу google для логина (получение токена), а после возвращается обратно в приложение. 

В аккаунте пользователя на gmail необходимо разрешить доступ к почте сторонним приложениям. 

## Особенности реализации:

При получении почты с сервера и сохранении сообщений в локальную базу данных все ошибки логгируются в файл mail.log. 

Все прикрепленные к сообщениям файлы хранятся в папке storage (в корне приложения).

Секретный ключи приложения должны хранятся в файле google_keys.yml (удалены из репозитория). 

## Тестирование: 

Для запуска всех тестов наберите в командной строке: 

	$ rspec
___________________________________________________________

Mailbox is an application that provides user an ability to get emails from his gmail-account (POP3 protocol is used). 

## Installation

Install gems with bundler:

	$ bundle install

Create database and run migrations: 

	$ rake db:create
	$ rake db:schema:load 

Launch the application: 

	$ rails s

## Start: 

Authorization is built with the OAuth 2.0 scheme: user is redirected to google for login (get access token) and then comes back to application. 

You should also give an access to unsafe applications in your gmail account.

Secret keys of application should be stored in google_keys.yml (deleted from repo).

## Features:

All errors during retrieving emails and saving them to database are logged in mail.log file.

All attachments are saved to storage folder in root folder of your application.  

## Tests: 

Run tests with command:

	$ rspec
